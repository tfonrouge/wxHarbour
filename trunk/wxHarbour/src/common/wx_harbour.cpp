/*
 * $Id$
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
    wxharbour:
    Teo. Mexico 2009
*/

#include "wx/wx.h"
#include "wx/strconv.h"
#include "wx/hashset.h"
#include "wxh.h"

#include "hbapicdp.h"
#include "hbdate.h"

/* PHB_BASEARRAY keys, wxh_Item* values */
WX_DECLARE_HASH_MAP( PHB_BASEARRAY, wxh_Item*, wxPointerHash, wxPointerEqual, MAP_PHB_BASEARRAY );

/* wxObject* keys, wxh_Item* values */
WX_DECLARE_HASH_MAP( wxObject*, wxh_Item*, wxPointerHash, wxPointerEqual, MAP_WXOBJECT );

/* long keys (crc32), wxh_Item* values */
WX_DECLARE_HASH_MAP( long, wxh_Item*, wxIntegerHash, wxIntegerEqual, MAP_CRC32 );

static MAP_PHB_BASEARRAY map_phbBaseArr;
static MAP_WXOBJECT map_wxObject;
static MAP_CRC32 map_crc32;

static PHB_ITEM lastTopLevelWindow;

/*
 WXHBaseClass:ObjectH : returns the harbour's object handle
 Teo. Mexico 2009
 */
HB_FUNC( WXHBASECLASS_OBJECTH )
{
    PHB_ITEM pSelf = hb_stackSelfItem();
    if( pSelf )
        hb_retptr( hb_arrayId( pSelf ) );
}

/*
    destructor
    Teo. Mexico 2009
*/
wxh_Item::~wxh_Item()
{
    map_phbBaseArr.erase( objHandle );
    map_wxObject.erase( wxObj	 );

    if( map_crc32.find( uiProcNameLine ) != map_crc32.end() )
        map_crc32.erase( uiProcNameLine );

    /* release codeblocks stored in event list */
    if( evtList.size() > 0 )
    {
        for( vector<PCONN_PARAMS>::iterator it = evtList.begin(); it < evtList.end(); it++ )
        {
            PCONN_PARAMS pConnParams = *it;
            if( pConnParams->pItmActionBlock )
            {
                hb_itemRelease( pConnParams->pItmActionBlock );
                pConnParams->pItmActionBlock = NULL;
            }
            delete pConnParams;
        }
    }

    if( delete_WX )
    {
        if( wxObj )
            delete wxObj;
    }
    if( pSelf )
    {
        hb_objSendMsg( pSelf, "ClearObjData", 0 );
        hb_itemRelease( pSelf );
        pSelf = NULL;
    }
}

/*
    constructor
    Teo. Mexico 2009
*/
wxh_ObjParams::wxh_ObjParams( PHB_ITEM pHbObj )
{
    pParamParent = NULL;
    linkChildParentParams = false;
    if( pHbObj == NULL )
        pSelf = hb_stackSelfItem();
    else
        pSelf = pHbObj;
    pWxh_Item = wxh_ItemListGet_PWXH_ITEM( pSelf );
}

/*
    destructor
    Teo. Mexico 2009
*/
wxh_ObjParams::~wxh_ObjParams()
{
    ProcessParamLists();
}

/*
    Get_wxObject
    Teo. Mexico 2009
*/
wxObject* wxh_ObjParams::Get_wxObject()
{
    return wxh_ItemListGet_WX( pSelf );
}

/*
    param
    Teo. Mexico 2009
*/
wxObject* wxh_ObjParams::param( const int param )
{
    return wxh_par_WX( param );
}

/*
    paramChild
    Teo. Mexico 2009
*/
wxObject* wxh_ObjParams::paramChild( PHB_ITEM pChildItm )
{
    wxObject* wxObj = NULL;

    if( pChildItm )
    {
        wxObj = wxh_ItemListGet_WX( pChildItm );

        if( wxObj )
        {
            map_paramListChild[ pChildItm ] = wxObj;
            linkChildParentParams = true;
        }
    }

    return wxObj;
}

/*
    paramChild
    Teo. Mexico 2009
*/
wxObject* wxh_ObjParams::paramChild( const int param )
{
    return paramChild( hb_param( param, HB_IT_OBJECT ) );
}

/*
    paramParent
    Teo. Mexico 2009
*/
wxObject* wxh_ObjParams::paramParent( PHB_ITEM pParentItm )
{
    wxObject* wxObj = NULL;

    if( pParentItm )
    {
        wxObj = wxh_ItemListGet_WX( pParentItm );

        if( wxObj )
        {
            if( this->pParamParent == NULL )
                this->pParamParent = pParentItm;
            else
                hb_errRT_BASE_SubstR( EG_ARG, WXH_ERRBASE + 3, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
            linkChildParentParams = true;
        }
    }

    return wxObj;
}

/*
    paramParent
    Teo. Mexico 2009
*/
wxObject* wxh_ObjParams::paramParent( const int param )
{
    return paramParent( hb_param( param, HB_IT_OBJECT ) );
}

/*
    ProcessParamLists
    Teo. Mexico 2009
*/
void wxh_ObjParams::ProcessParamLists()
{
    if( linkChildParentParams )
    {
        /* add the Parent object (if any) to the child/parent lists */
        if( ( wxh_ItemListGet_PWXH_ITEM( pSelf ) != NULL ) )
        {
            SetChildItem( pSelf );
        }

        /* add the Child objects to the child/parent lists */
        while( map_paramListChild.size() > 0 )
        {
            MAP_PHB_ITEM::iterator it = map_paramListChild.begin();
            SetChildItem( it->first );
            map_paramListChild.erase( it );
        }

        linkChildParentParams = false;
    }
}

/*
    Return
    Teo. Mexico 2009
*/
void wxh_ObjParams::Return( wxObject* wxObj, bool bItemRelease )
{
    /* checks for a valid new pSelf object */
    if( pSelf && ( map_phbBaseArr.find( (HB_BASEARRAY *) hb_arrayId( pSelf ) ) == map_phbBaseArr.end() ) )
    {
        pWxh_Item = NULL;
        PHB_ITEM pItem = NULL;

        pWxh_Item = new wxh_Item;
        pWxh_Item->nullObj = false;
        pWxh_Item->wxObj = wxObj;
        pWxh_Item->uiClass = hb_objGetClass( pSelf );
        pWxh_Item->objHandle = (HB_BASEARRAY *) hb_arrayId( pSelf );

        /* Objs derived from wxTopLevelWindow are not volatile to local */
        if( hb_clsIsParent( hb_objGetClass( pSelf ), "WXTOPLEVELWINDOW" ) )
        {
            /* calculate the crc32 for the procname/procline/uiClass that created this obj */
            char szName[ HB_SYMBOL_NAME_LEN + HB_SYMBOL_NAME_LEN + 5 ];
            UINT uiProcOffset = 1;
            USHORT usProcLine = 0;

            hb_procname( uiProcOffset, szName, TRUE );
            if( strncmp( "__WXH_", szName, 6 ) == 0 )
                hb_procname( ++uiProcOffset, szName, TRUE );

            long lOffset = hb_stackBaseProcOffset( uiProcOffset );
            if( lOffset > 0 )
                usProcLine = hb_stackItem( lOffset )->item.asSymbol.stackstate->uiLineNo;

            UINT uiCrc32 = hb_crc32( (long) hb_objGetClass( pSelf ) + usProcLine, (const char *) szName, strlen( szName ) );

//			 qoutf("METHODNAME: %s:%d, crc32: %u", szName, usProcLine, uiCrc32 );

            /* check if we are calling again the obj creation code and a wxh_Item exists */
            if( map_crc32.find( uiCrc32 ) != map_crc32.end() )
            {
                delete map_crc32[ uiCrc32 ];
            }

            map_crc32[ uiCrc32 ] = pWxh_Item;
            pWxh_Item->uiProcNameLine = uiCrc32;

            //pItem = wxh_itemNullObject( pSelf );
            //pWxh_Item->nullObj = true;
            pItem = hb_itemNew( pSelf );
            lastTopLevelWindow = pItem;
        }

        if( pItem )
        {
            pWxh_Item->pSelf = pItem;
        }

        map_phbBaseArr[ (HB_BASEARRAY *) hb_arrayId( pSelf ) ] = pWxh_Item;
        map_wxObject[ wxObj ] = pWxh_Item;

        linkChildParentParams = true;
        ProcessParamLists();

        hb_objSendMsg( pSelf, "OnCreate", 0 );
    
        if( hb_stackReturnItem() != pSelf )
        {
            hb_itemReturn( pSelf );
        }
        
        if( bItemRelease )
            hb_itemRelease( pSelf );

    }else
        hb_errRT_BASE_SubstR( EG_ARG, WXH_ERRBASE + 4, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
}

/*
    SetChildItem
    Teo. Mexico 2009
*/
void wxh_ObjParams::SetChildItem( const PHB_ITEM pChildItm )
{
    wxh_Item* pWxh_ItemChild = wxh_ItemListGet_PWXH_ITEM( pChildItm );

    if( pWxh_ItemChild )
    {
        if( pWxh_ItemChild->pSelf == NULL )
        {
            pWxh_ItemChild->pSelf = hb_itemNew( pChildItm );
        }
        else
            pWxh_ItemChild->uiRefCount++;
    }else
        hb_errRT_BASE_SubstR( EG_ARG, WXH_ERRBASE + 2, NULL, HB_ERR_FUNCNAME, HB_ERR_ARGS_BASEPARAMS );
}

/*
    End Class wxh_ObjParams
*/

/*
    wxh_ItemListDel_WX
    Teo. Mexico 2009
*/
void wxh_ItemListDel_WX( wxObject* wxObj, bool bDeleteWxObj )
{
    wxh_Item* pWxh_Item = wxh_ItemListGet_PWXH_ITEM( wxObj );

    if( pWxh_Item )
    {
        pWxh_Item->delete_WX = bDeleteWxObj;
        delete pWxh_Item;
    }
}

/*
    wxh_ItemListGet_HB
    Teo. Mexico 2009
*/
PHB_ITEM wxh_ItemListGet_HB( wxObject* wxObj )
{
    PHB_ITEM pSelf = NULL;

    if( wxObj )
    {
    wxh_Item* pWxh_Item = wxh_ItemListGet_PWXH_ITEM( wxObj );

    if( pWxh_Item )
    {
        pSelf = pWxh_Item->pSelf;
        if( hb_itemType( pSelf ) != HB_IT_OBJECT )
        pSelf = NULL;
    }
    else {
        wxString clsName( wxObj->GetClassInfo()->GetClassName() );
        //const char *ascii = clsName.ToAscii();
        //qoutf("wxh_ItemListGet_HB (no wxh_Item): %s", ascii );
    }
    }
    return pSelf;
}

/*
    wxh_ItemListGet_PWXH_ITEM
    Teo. Mexico 2009
*/
wxh_Item* wxh_ItemListGet_PWXH_ITEM( wxObject* wxObj )
{
    wxh_Item* pWxh_Item = NULL;

    if( wxObj && ( map_wxObject.find( wxObj ) != map_wxObject.end() ) )
    {
        pWxh_Item = map_wxObject[ wxObj ];
    }

    return pWxh_Item;
}

/*
    wxh_ItemListGet_PWXH_ITEM
    Teo. Mexico 2009
*/
wxh_Item* wxh_ItemListGet_PWXH_ITEM( PHB_ITEM pSelf )
{
    wxh_Item* pWxh_Item = NULL;

    if( pSelf && ( map_phbBaseArr.find( (HB_BASEARRAY *) hb_arrayId( pSelf ) ) != map_phbBaseArr.end() ) )
    {
        pWxh_Item = map_phbBaseArr[ (HB_BASEARRAY *) hb_arrayId( pSelf ) ];
    }

    return pWxh_Item;
}

/*
    wxh_ItemListGet_WX
    Teo. Mexico 2009
*/
wxObject* wxh_ItemListGet_WX( PHB_ITEM pSelf )
{
    wxObject* wxObj = NULL;

    if( pSelf && ( map_phbBaseArr.find( (HB_BASEARRAY *) hb_arrayId( pSelf ) ) != map_phbBaseArr.end() ) )
    {
        wxObj = map_phbBaseArr[ (HB_BASEARRAY *) hb_arrayId( pSelf ) ]->wxObj;
    }

    return wxObj;
}

/*
    wxh_ItemListReleaseAll
    Teo. Mexico 2009
*/
void wxh_ItemListReleaseAll()
{
    MAP_WXOBJECT::iterator it;
    while( ! map_wxObject.empty() )
    {
        it = map_wxObject.begin();
        it->second->delete_WX = false;
        delete it->second;
        //wxh_ItemListDel_WX( it->first );
    }
}

/*
    wxh_ItemListSwap
    Teo. Mexico 2009
*/
bool wxh_ItemListSwap( wxObject *oldObj, wxObject *newObj )
{
    wxh_Item *pWxh_Item = wxh_ItemListGet_PWXH_ITEM( oldObj );
    
    if( pWxh_Item )
    {
        pWxh_Item->wxObj = newObj;
        map_wxObject.erase( oldObj );
        map_wxObject[ newObj ] = pWxh_Item;
        delete oldObj;
        return true;
    }
    return false;
}

/*
    wxh_itemNewReturn
    Teo. Mexico 2009
*/
void wxh_itemNewReturn( const char * szClsName, wxObject* ctrl, wxObject* parent )
{
    PHB_ITEM pSelf = wxh_ItemListGet_HB( ctrl );
    
    if( pSelf == NULL )
    {
        PHB_DYNS pDynSym = hb_dynsymFindName( szClsName );
        
        if( pDynSym )
        {
            hb_vmPushDynSym( pDynSym );
            hb_vmPushNil();
            hb_vmDo( 0 );
            
            pSelf = hb_itemNew( hb_stackReturnItem() );
            
            wxh_ObjParams objParams = wxh_ObjParams( pSelf );

            if( parent )
                objParams.paramParent( wxh_ItemListGet_HB( parent ) );

            objParams.Return( ctrl, true );
        }
    }
    else
    {
        hb_itemReturn( pSelf );
    }
}

/*
 wxh_itemNullObject
 Teo. Mexico 2009
 */
PHB_ITEM wxh_itemNullObject( PHB_ITEM pSelf )
{
    if( HB_IS_OBJECT( pSelf ) )
    {
        //hb_gcRefDec( hb_arrayId( pSelf ) );
    }

    return pSelf;
}

HB_FUNC( WXH_NULLOBJECT )
{
    hb_itemReturn( wxh_itemNullObject( hb_param( 1, HB_IT_OBJECT ) ) );
}

HB_FUNC( WXH_DESTROYNULLOBJECT )
{
    PHB_ITEM pSelf = hb_param( 1, HB_IT_OBJECT );
    
    if ( pSelf ) 
    {
        pSelf->type = HB_IT_NIL;
    }
}

/*
 wxh_itemReturn
 Teo. Mexico 2009
 */
void wxh_itemReturn( wxObject *wxObj )
{
    hb_itemReturn( wxh_ItemListGet_HB( wxObj ) );
}

/*
    wxh_par_WX
    Teo. Mexico 2009
*/
wxObject* wxh_par_WX( const int param )
{
    return wxh_ItemListGet_WX( hb_param( param, HB_IT_OBJECT ) );
}

/*
    wxh_par_arrayInt
    Teo. Mexico 2010
*/
void wxh_par_arrayInt( int param, int* arrayInt, const size_t len )
{

    if( ISARRAY( param ) )
    {
        PHB_ITEM pArray = hb_param( param, HB_IT_ARRAY );
        PHB_ITEM pItm;
        ULONG ulLen = min( (size_t) hb_arrayLen( pArray ), len );
        for( ULONG ulI = 1; ulI <= ulLen; ulI++ )
        {
            pItm = hb_arrayGetItemPtr( pArray, ulI );
            if( hb_itemType( pItm ) && HB_IT_NUMERIC )
            {
                arrayInt[ ulI - 1 ] = hb_arrayGetNI( pArray, ulI );
            }
        }
    }

}

/*
 wxh_par_wxArrayString
 Teo. Mexico 2009
 */
wxArrayString wxh_par_wxArrayString( int param )
{
    wxArrayString arrayString;
    
    if( ISARRAY( param ) )
    {
        PHB_ITEM pArray = hb_param( param, HB_IT_ARRAY );
        PHB_ITEM pItm;
        ULONG ulLen = hb_arrayLen( pArray );
        for( ULONG ulI = 1; ulI <= ulLen; ulI++ )
        {
            pItm = hb_arrayGetItemPtr( pArray, ulI );
            if( hb_itemType( pItm ) && ( HB_IT_STRING || HB_IT_MEMO ) )
            {
                arrayString.Add( wxh_CTowxString( hb_itemGetCPtr( pItm ) ) );
            }
        }
    }
    
    return arrayString;
}

/*
 wxh_par_wxColour
 Teo. Mexico 2009
 */
wxColour wxh_par_wxColour( int param )
{
    PHB_ITEM pItem = hb_param( param, HB_IT_ANY );
    
    switch ( hb_itemType( pItem ) )
    {
        case HB_IT_STRING:
            return wxColour( wxh_parc( param ) );
        default:
            break;
    }
    return wxColour();
}

/*
 wxh_par_wxDateTime
 Teo. Mexico 2009
 */
wxDateTime wxh_par_wxDateTime( int param )
{
    long lDate = hb_pardl( param );
    int iYear, iMonth, iDay;
    hb_dateDecode( lDate, &iYear, &iMonth, &iDay );
    return wxDateTime( iDay, (wxDateTime::Month) (iMonth - 1), iYear, 0, 0, 0, 0 );
}

/*
    wxh_par_wxPoint
    Teo. Mexico 2009
*/
wxPoint wxh_par_wxPoint( int param )
{
    PHB_ITEM pStruct = hb_param( param, HB_IT_ARRAY );
    if( pStruct && hb_arrayLen( pStruct ) == 2 )
    {
        PHB_ITEM p1,p2;
        p1 = hb_arrayGetItemPtr( pStruct, 1 );
        p2 = hb_arrayGetItemPtr( pStruct, 2 );
        int x = HB_IS_NUMERIC( p1 ) ? hb_itemGetNI( p1 ) : -1;
        int y = HB_IS_NUMERIC( p2 ) ? hb_itemGetNI( p2 ) : -1;
        return wxPoint( x, y );
    }
    else
        return wxPoint( -1, -1 );
}

/*
    wxh_par_wxSize
    Teo. Mexico 2009
*/
wxSize wxh_par_wxSize( int param )
{
    PHB_ITEM pStruct = hb_param( param, HB_IT_ARRAY );
    if( pStruct && hb_arrayLen( pStruct ) == 2 )
    {
        PHB_ITEM pWidth,pHeight;
        pWidth = hb_arrayGetItemPtr( pStruct, 1 );
        pHeight = hb_arrayGetItemPtr( pStruct, 2 );
        int iWidth = HB_IS_NUMERIC( pWidth ) ? hb_itemGetNI( pWidth ) : -1;
        int iHeight = HB_IS_NUMERIC( pHeight ) ? hb_itemGetNI( pHeight ) : -1;
        return wxSize( iWidth, iHeight );
    }
    else
        return wxSize( -1, -1 );
}

/*
    wxh_CTowxStr
    Teo. Mexico 2009
*/
wxString wxh_CTowxString( const char * szStr, bool convOEM )
{
#ifdef _UNICODE
    const wxMBConv& mbConv = wxConvUTF8;

    if( convOEM && szStr )
    {
        ULONG ulStrLen = strlen( szStr );
        PHB_CODEPAGE pcp = hb_vmCDP();

        if( ulStrLen > 0 && pcp )
        {
            wxString wxStr;
            ULONG ulUTF8Len = hb_cdpUTF8StringLength( szStr, ulStrLen );
            char *strUTF8 = (char *) hb_xgrab( ulUTF8Len + 1 );
            hb_cdpStrToUTF8( pcp, false, szStr, ulStrLen, (char *) strUTF8, ulUTF8Len + 1 );
            wxStr = wxString( strUTF8, mbConv );
            hb_xfree( strUTF8 );
            return wxStr;
        }
    }
#else
    const wxMBConv& mbConv = wxConvLocal;

    HB_SYMBOL_UNUSED( convOEM );

#endif

    return wxString( szStr, mbConv );
}

/*
 * wxh_LastTopLevelWindow
 * Teo. Mexico 2009
 */
HB_FUNC( WXH_LASTTOPLEVELWINDOW )
{
    hb_itemReturn( lastTopLevelWindow );
}

/*
 wxh_parc
 Teo. Mexico 2009
 */
wxString wxh_parc( int param )
{
    return wxh_CTowxString( hb_parc( param ) );
}

/*
 wxh_ret_wxSize
 Teo. Mexico 2009
 */
void wxh_ret_wxSize( wxSize* size )
{
    PHB_ITEM pSize = hb_itemNew( NULL );
    hb_arrayNew( pSize, 2 );
    hb_arraySetNI( pSize, 1, size->GetWidth() );
    hb_arraySetNI( pSize, 2, size->GetHeight() );
    hb_itemReturnRelease( pSize );
}

/*
 wxh_ret_wxPoint
 Teo. Mexico 2009
 */
void wxh_ret_wxPoint( const wxPoint& point )
{
    PHB_ITEM pPoint = hb_itemNew( NULL );
    hb_arrayNew( pPoint, 2 );
    hb_arraySetNI( pPoint, 1, point.x );
    hb_arraySetNI( pPoint, 2, point.y );
    hb_itemReturnRelease( pPoint );
}

/*
    wxh_retc
    Teo. Mexico 2009
 */
void wxh_retc( const wxString & string )
{
    hb_retc( wxh_wxStringToC( string ) );
}

/*
    wxMutexGuiEnter
    Teo. Mexico 2009
*/
HB_FUNC( WXMUTEXGUIENTER )
{
    wxMutexGuiEnter();
}

/*
    wxMutexGuiLeave
    Teo. Mexico 2009
*/
HB_FUNC( WXMUTEXGUILEAVE )
{
    wxMutexGuiLeave();
}

/*
    qoutf
    Teo. Mexico 2009
*/
void qoutf( const char* format, ... )
{
    static char text[512];
    static PHB_DYNS s___qout = NULL;

    va_list argp;

    va_start( argp, format );
    vsprintf( text, format, argp );
    va_end( argp );

    if( s___qout == NULL )
    {
        s___qout = hb_dynsymGetCase( "QOUT" );
    }
    hb_vmPushDynSym( s___qout );
    hb_vmPushNil();
    hb_vmPushString( text, strlen( text ) );
    hb_vmDo( 1 );
}

/*
    qqoutf
    Teo. Mexico 2009
*/
void qqoutf( const char* format, ... )
{
    static char text[512];
    static PHB_DYNS s___qout = NULL;

    va_list argp;

    va_start( argp, format );
    vsprintf( text, format, argp );
    va_end( argp );

    if( s___qout == NULL )
    {
        s___qout = hb_dynsymGetCase( "QQOUT" );
    }
    hb_vmPushDynSym( s___qout );
    hb_vmPushNil();
    hb_vmPushString( text, strlen( text ) );
    hb_vmDo( 1 );
}

/*
    wxh_AddNavigationKeyEvent( wxEvtHandler, direction AS LOGICAL )
    Teo. Mexico 2009
*/
HB_FUNC( WXH_ADDNAVIGATIONKEYEVENT )
{
    wxEvtHandler* evtHandler = (wxEvtHandler *) wxh_par_WX( 1 );
    bool bDirection = ISNIL( 2 ) ? true : hb_parl( 2 );

    wxNavigationKeyEvent navEvent;
    navEvent.SetEventObject( evtHandler );
    navEvent.SetDirection( bDirection );
    hb_retl( evtHandler->ProcessEvent( navEvent ) );
}

/*
    wxh_L2BEBin
    Teo. Mexico 2010
 */
HB_FUNC( WXH_L2BEBIN )
{
    char szResult[ 4 ];
    HB_U32 i = ( HB_U32 ) hb_parnl( 1 );
    HB_PUT_BE_UINT32( szResult, i );
    hb_retclen( szResult, 4 );
}
