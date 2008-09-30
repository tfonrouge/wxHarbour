/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxhFuncs
  Teo. Mexico 2008
*/

#ifdef __XHARBOUR__

#include "wx_hbcompat.ch"

#endif

#include "hbclass.ch"
#include "property.ch"
#include "wx.ch"

#include "wxharbour.ch"

STATIC containerObj
STATIC menuData

/*
  ContainerObj
  Teo. Mexico 2008
*/
FUNCTION ContainerObj
  IF containerObj = NIL
    containerObj := TContainerObj():New()
  ENDIF
RETURN containerObj

/*
 * wxh_BoxSizerBegin
 * Teo. Mexico 2008
 */
FUNCTION wxh_BoxSizerBegin( label, orient, strech, align, border, sideBorders )
  LOCAL sizer
  LOCAL parent
  LOCAL lastSizer

  parent := containerObj():LastParent()
  lastSizer := containerObj():LastSizer()

  IF label = NIL
    sizer := wxBoxSizer():New( orient )
  ELSE
    sizer := wxStaticBoxSizer():New( orient, parent, label )
    //sizer := wxStaticBoxSizer():New( wxStaticBox():New( parent, , label ) , orient )
  ENDIF

  IF lastSizer == NIL
    wxh_SetSizer( parent, sizer )
  ELSE
    wxh_SizerInfoAdd( sizer, lastSizer, strech, align, border, sideBorders )
  ENDIF

  containerObj():AddToSizerList( sizer )

RETURN sizer

/*
 * wxh_BrowseDb
 * Teo. Mexico 2008
 */
FUNCTION wxh_BrowseDb( table, window, id, pos, size, style, name )
  LOCAL wxhBrw

  IF window = NIL
    window := containerObj():LastParent()
  ENDIF

  wxhBrw := wxhBrowseDb():New( table, window, id, pos, size, style, name )

  containerObj():SetLastChild( wxhBrw )

RETURN wxhBrw

/*
  wxh_BrowseDbAddColumn
  Teo. Mexico 2008
*/
PROCEDURE wxh_BrowseDbAddColumn( zero, wxhBrw, title, block, picture, width )
  LOCAL hColumn := HB_HSetCaseMatch( {=>}, .F. )

  hColumn["title"]   := title
  hColumn["block"]   := block
  hColumn["picture"] := picture
  hColumn["width"]   := width

  IF zero
    wxhBrw:GetTable():ColumnZero := hColumn
  ELSE
    wxhBrw:GetTable():AddColumn( hColumn )
  ENDIF

RETURN

/*
 * wxh_Button
 * Teo. Mexico 2008
 */
FUNCTION wxh_Button( window, id, label, pos, size, style, validator, name, bAction )
  LOCAL button

  IF window = NIL
    window := containerObj():LastParent()
  ENDIF

  button := wxButton():New( window, id, label, pos, size, style, validator, name )

  IF bAction != NIL
    button:Connect( button:GetID(), wxEVT_COMMAND_BUTTON_CLICKED, bAction )
  ENDIF

  containerObj():SetLastChild( button )

RETURN button

/*
  wxh_Dialog
  Teo. Mexico 2008
*/
FUNCTION wxh_Dialog( fromClass, oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
  LOCAL dlg

  IF Empty( fromClass )
    dlg := wxDialog():New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
  ELSE
    dlg := __ClsInstFromName( fromClass ):New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
    IF !dlg:IsDerivedFrom( "wxDialog" )
      dlg:IsNotDerivedFrom_wxDialog()
    ENDIF
  ENDIF

  containerObj():AddToParentList( dlg )

RETURN dlg

/*
  wxh_Frame
  Teo. Mexico 2008
*/
FUNCTION wxh_Frame( frameType, fromClass, oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
  LOCAL oWnd

  IF Empty( fromClass )

    DO CASE
    CASE frameType == "MDIPARENT"
      oWnd := wxMDIParentFrame():New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
    CASE frameType == "MDICHILD"
      oWnd := wxMDIChildFrame():New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
    OTHERWISE
      oWnd := wxFrame():New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
    ENDCASE

  ELSE

    oWnd := __ClsInstFromName( fromClass ):New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )

    DO CASE
    CASE frameType == "MDIPARENT"
      IF !oWnd:IsDerivedFrom( "wxMDIParentFrame" )
        oWnd:IsNotDerivedFrom_wxMDIParentFrame()
      ENDIF
    CASE frameType == "MDICHILD"
      IF !oWnd:IsDerivedFrom( "wxMDIChildFrame" )
        oWnd:IsNotDerivedFrom_wxMDIChildFrame()
      ENDIF
    OTHERWISE
      IF !oWnd:IsDerivedFrom( "wxFrame" )
        oWnd:IsNotDerivedFrom_wxFrame()
      ENDIF
    ENDCASE

  ENDIF

  containerObj():AddToParentList( oWnd )

RETURN oWnd

/*
 * wxh_GET
 * Teo. Mexico 2008
 */
FUNCTION wxh_GET( window, id, wxhGet, pos, size, style, validator, name )
  LOCAL Result

  IF window = NIL
    window := containerObj():LastParent()
  ENDIF

  Result := wxHBTextCtrl():New( window, id, wxhGet, pos, size, style, validator, name )

  containerObj():SetLastChild( Result )

RETURN Result

/*
 * wxh_GridSizerBegin
 * Teo. Mexico 2008
 */
PROCEDURE wxh_GridSizerBegin( rows, cols, vgap, hgap, strech, align, border, sideBorders )
  LOCAL sizer
  LOCAL parent
  LOCAL lastSizer

  sizer := wxGridSizer():New( rows, cols, vgap, hgap )

  parent := containerObj():LastParent()
  lastSizer := containerObj():LastSizer

  IF lastSizer == NIL
    wxh_SetSizer( parent, sizer )
  ELSE
    wxh_SizerInfoAdd( sizer, lastSizer, strech, align, border, sideBorders )
  ENDIF

  containerObj():AddToSizerList( sizer )

RETURN

/*
  wxh_BookAddPage
  Teo. Mexico 2008
*/
PROCEDURE wxh_BookAddPage( title, select, imageId )

  containerObj():AddToNextBookPage( {"title"=>title,"select"=>select,"imageId"=>imageId} )

RETURN

/*
  wxh_BookBegin
  Teo. Mexico 2008
*/
FUNCTION wxh_BookBegin( bookClass, parent, id, pos, size, style, name )
  LOCAL book

  IF parent == NIL
    parent := containerObj():LastParent()
  ENDIF

  book := bookClass:New( parent, id, pos, size, style, name )

  containerObj():SetLastChild( book )

  containerObj():AddToParentList( book )

RETURN book

/*
  wxh_BookEnd
  Teo. Mexico 2008
*/
PROCEDURE wxh_BookEnd( book )
  containerObj():RemoveLastParent( book )
RETURN

/*
  wxh_MenuBarBegin
  Teo. Mexico 2006
*/
FUNCTION wxh_MenuBarBegin( window, style )
  menuData := TGlobal():New()
  menuData:g_menuID := 1
  menuData:g_menuBar := wxMenuBar():New( style )
  IF window = NIL
    //menuData:g_window := wxh_LastTopLevelWindow()
    menuData:g_window := containerObj():LastParent( "wxFrame" )
  ELSE
    menuData:g_window := window
  ENDIF
RETURN menuData:g_menuBar

/*
  wxh_MenuBegin
  Teo. Mexico 2006
*/
PROCEDURE wxh_MenuBegin( title )
  LOCAL hData := {=>}

  IF menuData:g_menuList = NIL
    menuData:g_menuList := {}
  ENDIF

  hData["menu"] := wxMenu():New()
  hData["title"] := title
  AAdd( menuData:g_menuList, hData )

RETURN

/*
  wxh_MenuEnd
  Teo. Mexico 2006
*/
PROCEDURE wxh_MenuEnd
  LOCAL hData
  LOCAL menuListSize
  LOCAL menuItem
  LOCAL nLast

  IF Empty( menuData:g_menuList )
    menuData:g_window:SetMenuBar( menuData:g_menuBar )
    menuData := NIL
    RETURN
  ENDIF

  nLast := menuData:lenMenuList

  hData := menuData:g_menuList[ nLast ]

  menuListSize := Len( menuData:g_menuList )

  IF menuListSize = 1 /* Append to menuBar */
    menuData:g_menuBar:Append( hData["menu"], hData["title"] )
  ELSE                /* Append SubMenu */
    menuItem := wxMenuItem():New( menuData:g_menuList[ nLast -1 ]["menu"], menuData:g_menuID++, hData["title"], "", wxITEM_NORMAL, hData["menu"] )
    menuData:g_menuList[ nLast - 1 ]["menu"]:Append( menuItem )
  ENDIF

  ASize( menuData:g_menuList, menuListSize - 1)

RETURN

/*
  wxh_MenuItemAdd
  Teo. Mexico 2006
*/
FUNCTION wxh_MenuItemAdd( text, id, helpString, kind, bAction, bEnabled )
  LOCAL menuItem
  LOCAL nLast

  IF id=NIL
    id := menuData:g_menuID++
  ENDIF

  nLast := menuData:lenMenuList

  menuItem := wxMenuItem():New( menuData:g_menuList[ nLast ]["menu"], id, text, helpString, kind )

  menuData:g_menuList[ nLast ]["menu"]:Append( menuItem )

  IF bAction != NIL
    menuData:g_window:Connect( id, wxEVT_COMMAND_MENU_SELECTED, bAction )
  ENDIF

  IF bEnabled != NIL
    menuItem:Enable( bEnabled:Eval() )
  ENDIF

RETURN menuItem

/*
 * wxh_PanelBegin
 * Teo. Mexico 2008
 */
FUNCTION wxh_PanelBegin( parent, id, pos, size, style, name )
  LOCAL panel

  IF parent = NIL
    parent := containerObj():LastParent()
  ENDIF

  panel := wxPanel():New( parent, id, pos, size, style, name )

  containerObj():SetLastChild( panel )

  containerObj():AddToParentList( panel )

RETURN panel

/*
  wxh_PanelEnd
  Teo. Mexico 2008
*/
PROCEDURE wxh_PanelEnd
  containerObj():RemoveLastParent( "wxPanel" )
RETURN

/*
 * wxh_SAY
 * Teo. Mexico 2008
 */
FUNCTION wxh_SAY( window, id, label, pos, size, style, name )
  LOCAL Result

  IF window = NIL
    window := containerObj():LastParent()
  ENDIF

  Result := wxStaticText():New( window, id, label, pos, size, style, name )

  containerObj():SetLastChild( Result )

RETURN Result

/*
  wxh_SetSizer
  Teo. Mexico 2008
*/
PROCEDURE wxh_SetSizer( window, sizer )
  LOCAL bookCtrl
  LOCAL IsWindowBook := .F.
  
  FOR EACH bookCtrl IN containerObj():BookCtrls
    IF window:IsDerivedFrom( bookCtrl )
      IsWindowBook := .T.
    ENDIF
  NEXT
  
  IF IsWindowBook
    Alert( "Sizer cannot be a direct child of a " + window:ClassName() + " control.;Check your Sizer definition at line " + LTrim(Str(ProcLine(2))) + " on " + ProcName( 2 ) )
  ENDIF

  window:SetSizer( sizer )

RETURN

/*
 * wxh_SizerInfoAdd
 * Teo. Mexico 2008
 */
PROCEDURE wxh_SizerInfoAdd( child, parentSizer, strech, align, border, sideBorders, flag, useLast, addSizerInfoToLastItem )
  LOCAL sizerInfo

  IF child = NIL .AND. ! ( addSizerInfoToLastItem == .T. )

    /* Check if last child has been processed */
    IF containerObj():GetLastChild()[ "processed" ]
      RETURN
    ENDIF

    child := containerObj():GetLastChild()[ "child" ]
    sizerInfo := containerObj():GetLastChild()[ "sizerInfo" ]

    /* no sizerInfo available */
    IF sizerInfo == NIL
      RETURN
    ENDIF

    containerObj():GetLastChild()[ "processed" ] := .T. /* mark processed */

    strech      := sizerInfo[ "strech" ]
    align       := sizerInfo[ "align" ]
    border      := sizerInfo[ "border" ]
    sideBorders := sizerInfo[ "sideBorders" ]
    flag        := sizerInfo[ "flag" ]

  ENDIF

  /* collect default parentSizer */
  IF parentSizer = NIL
    /* check if we have a parent control */
    IF containerObj():GetLastChild()[ "child" ] == NIL
      IF containerObj():GetLastParent( -1 ) != NIL
        parentSizer := ATail( containerObj():GetLastParent( -1 )[ "sizers" ] )
      ENDIF
    ELSE
      parentSizer := containerObj():LastSizer()
    ENDIF
  ENDIF

  IF parentSizer = NIL
    //Alert( "No parent Sizer available.", {"QUIT"})
    TRACE "Child:", child:ClassName, "No parent Sizer available"
    RETURN
  ENDIF

  IF strech = NIL
    strech := 0
  ENDIF

  IF align = NIL
    IF parentSizer != NIL
      IF parentSizer:IsDerivedFrom("wxGridSizer")
        align := HB_BITOR( wxALIGN_CENTER_HORIZONTAL, wxALIGN_CENTER_VERTICAL )
      ELSE
        IF parentSizer:GetOrientation() = wxVERTICAL
          align := HB_BITOR( wxALIGN_CENTER_HORIZONTAL, wxALL )
        ELSE
          align := HB_BITOR( wxALIGN_CENTER_VERTICAL, wxALL )
        ENDIF
      ENDIF
    ELSE
      align := 0
    ENDIF
  ENDIF

  IF sideBorders = NIL
    sideBorders := wxALL
  ENDIF

  IF border = NIL
    border := 5
  ENDIF

  IF flag = NIL
    flag := 0
  ENDIF

  /* just add to last item */
  IF addSizerInfoToLastItem == .T.

    IF ! useLast == .T.
      sizerInfo := { "strech"=>strech, "align"=>align, "border"=>border, "sideBorders"=>sideBorders, "flag"=>flag }
      containerObj():AddSizerInfoToLastItem( sizerInfo )
    ENDIF

    RETURN

  ENDIF

  containerObj():SizerAddOnLastChild()

  parentSizer:Add( child, strech, HB_BITOR( align, sideBorders, flag ), border )

RETURN

/*
 * wxh_SizerEnd
 * Teo. Mexico 2008
 */
PROCEDURE wxh_SizerEnd
  containerObj():RemoveLastSizer()
RETURN

/*
  wxh_ShowWindow : shows wxFrame/wxDialog
  Teo. Mexico 2008
*/
FUNCTION wxh_ShowWindow( oWnd, modal, fit, centre )
  LOCAL Result

  containerObj():ClearData()

  IF fit
    IF oWnd:GetSizer() != NIL
      oWnd:GetSizer():SetSizeHints( oWnd )
    ENDIF
  ENDIF

  IF centre
    oWnd:Centre()
  ENDIF

  IF modal
    IF !oWnd:IsDerivedFrom("wxDialog")
      oWnd:IsNotDerivedFrom_wxDialog()
    ENDIF
    Result := oWnd:ShowModal()
  ELSE
    Result := oWnd:Show( .T. )
  ENDIF

RETURN Result

/*
 * wxh_Spacer
 * Teo. Mexico 2008
 */
PROCEDURE wxh_Spacer( width, height, strech, align, border )
  LOCAL lastSizer

  lastSizer := containerObj():LastSizer()

  IF lastSizer == NIL
    Alert( "No Sizer available to add a Spacer",{"QUIT"})
    RETURN
  ENDIF

  IF width = NIL
    width := 5
  ENDIF

  IF height = NIL
    height := 5
  ENDIF

  IF strech = NIL
    strech := 1
  ENDIF

  IF align = NIL
    IF !lastSizer:GetOrientation() = wxHORIZONTAL
      align := HB_BITOR( wxALIGN_CENTER_HORIZONTAL, wxALL )
    ELSE
      align := HB_BITOR( wxALIGN_CENTER_VERTICAL, wxALL )
    ENDIF
  ENDIF

  IF border = NIL
    border := 5
  ENDIF

  lastSizer:Add( width, height, strech, align, border )

RETURN

/*
  wxh_StatusBar
  Teo. Mexico 2006
*/
FUNCTION wxh_StatusBar( oW, id, style, name, fields, widths )
  LOCAL sb

  IF oW = NIL
    oW := containerObj():LastParent()
  ENDIF

  sb := wxStatusBar():New( oW, id, style, name )

  IF widths!=NIL .AND. fields=NIL
    fields := Len( widths )
  ENDIF

  IF fields != NIL
    sb:SetFieldsCount( fields, widths )
  ENDIF

  oW:SetStatusBar( sb )

RETURN sb

/*
  wxh_TreeCtrl
  Teo. Mexico 2008
 */
FUNCTION wxh_TreeCtrl( window, id, pos, size, style, validator, name )
  LOCAL Result

  IF window = NIL
    window := ContainerObj():LastParent()
  ENDIF

  Result := wxTreeCtrl():New( window, id, pos, size, style, validator, name )

  containerObj():SetLastChild( Result )

RETURN Result

/*
  TContainerObj
  Teo. Mexico 2008
*/
CLASS TContainerObj
PRIVATE:
  DATA FParentList
PROTECTED:
PUBLIC:
  DATA BookCtrls INIT { "wxNotebook", "wxListbook", "wxAuiNotebook" }
  METHOD AddSizerInfoToLastItem( sizerInfo )
  METHOD AddToNextBookPage( hInfo )
  METHOD AddToParentList( parent )
  METHOD AddToSizerList( sizer )
  METHOD CheckForAddPage
  METHOD ClearData
  METHOD GetLastChild
  METHOD GetLastParent( index )
  METHOD LastParent
  METHOD LastSizer
  METHOD RemoveLastParent
  METHOD RemoveLastSizer
  METHOD SetLastChild( child )
  METHOD SizerAddOnLastChild
PUBLISHED:
ENDCLASS

/*
  AddSizerInfoToLastItem
  Teo. Mexico 2008
*/
METHOD PROCEDURE AddSizerInfoToLastItem( sizerInfo ) CLASS TContainerObj

  /* if has not child yet defined then is a parent ctrl */
  IF ATail( ::FParentList )[ "lastChild" ][ "child" ] == NIL
    /* control is in lastChild in the previuos Parent list */
    IF ::GetLastParent( -1 ) != NIL
      ::GetLastParent( -1 )[ "lastChild" ][ "sizerInfo" ] := sizerInfo
    ENDIF
  ELSE
    ATail( ::FParentList )[ "lastChild" ][ "sizerInfo" ] := sizerInfo
  ENDIF

RETURN

/*
  AddToNextBookPage
  Teo. Mexico 2008
*/
METHOD PROCEDURE AddToNextBookPage( hInfo ) CLASS TContainerObj
  LOCAL bookCtrl
  LOCAL IsParentBook := .F.
  
  FOR EACH bookCtrl IN ::BookCtrls
    IF ::LastParent():IsDerivedFrom( bookCtrl )
      IsParentBook := .T.
    ENDIF
  NEXT
  
  IF !IsParentBook
    Alert( "Previuos page not a " + bookCtrl + " control" )
    RETURN
  ENDIF

  ATail( ::FParentList )[ "pageInfo" ] := hInfo

RETURN

/*
  AddToParentList
  Teo. Mexico 2008
*/
METHOD PROCEDURE AddToParentList( parent ) CLASS TContainerObj
  IF parent:IsDerivedFrom( "wxFrame" ) .OR. parent:IsDerivedFrom( "wxDialog" )
    IF !Empty( ::FParentList )
      Alert("ParentList stack not empty, please review your code.",{"ACCEPT"})
    ENDIF
    ::FParentList := {}
  ENDIF
  IF parent == NIL
    Alert( "Trying to add a NIL value to the ParentList stack",{"QUIT"})
    ::QUIT()
  ENDIF
  AAdd( ::FParentList, { "parent"=>parent, "sizers"=>{}, "pageInfo"=>NIL, "lastChild"=>{ "child"=>NIL, "processed"=>.F., "sizerInfo"=>NIL } } )
RETURN

/*
  AddToSizerList
  Teo. Mexico 2008
*/
METHOD PROCEDURE AddToSizerList( sizer ) CLASS TContainerObj
  AAdd( ATail( ::FParentList )[ "sizers" ], sizer )
RETURN

/*
  ClearData
  Teo. Mexico 2008
*/
METHOD PROCEDURE ClearData CLASS TContainerObj
  ::FParentList := NIL
RETURN

/*
  CheckForAddPage
  Teo. Mexico 2008
*/
METHOD PROCEDURE CheckForAddPage( window ) CLASS TContainerObj
  LOCAL hInfo
  LOCAL bookCtrl
  LOCAL IsParentBook := .F.

  FOR EACH bookCtrl IN ::BookCtrls
    IF ::LastParent():IsDerivedFrom( bookCtrl )
      IsParentBook := .T.
    ENDIF
  NEXT
    
  IF IsParentBook
    hInfo := ATail( ::FParentList )[ "pageInfo" ]
    IF  hInfo != NIL
      ::LastParent():AddPage( window, hInfo["title"], hInfo["select"], hInfo["imageId"] )
      ATail( ::FParentList )[ "pageInfo" ] := NIL
    ELSE
      ::LastParent():AddPage( window, "Tab" )
    ENDIF
  ENDIF

RETURN

/*
  GetLastChild
  Teo. Mexico 2008
*/
METHOD FUNCTION GetLastChild CLASS TContainerObj
RETURN ATail( ::FParentList )[ "lastChild" ]

/*
  GetLastParent
  Teo. Mexico 2008
*/
METHOD FUNCTION GetLastParent( index ) CLASS TContainerObj
  IF Empty( index )
    RETURN ATail( ::FParentList )
  ENDIF
  index := Len( ::FParentList ) + index
  IF index < 1 .OR. index > Len( ::FParentList )
    RETURN NIL
  ENDIF
RETURN ::FParentList[ index ]

/*
  LastParent
  Teo. Mexico 2008
*/
METHOD FUNCTION LastParent CLASS TContainerObj
RETURN ATail( ::FParentList )[ "parent" ]

/*
  LastSizer
  Teo. Mexico 2008
*/
METHOD FUNCTION LastSizer CLASS TContainerObj
  IF Empty( ::FParentList )
    RETURN NIL
  ENDIF
RETURN ATail( ATail( ::FParentList )[ "sizers" ] )

/*
  RemoveLastParent
  Teo. Mexico 2008
*/
METHOD PROCEDURE RemoveLastParent( className ) CLASS TContainerObj

  /* do some checking */
  IF className != NIL
    IF !Upper( ATail( ::FParentList )[ "parent" ]:ClassName ) == Upper( className )
      Alert("Attempt to remove wrong parent on stack (ClassName not equal).;"+Upper( ATail( ::FParentList )[ "parent" ]:ClassName ) + "==" + Upper( className )+";"+"Check for missing/wrong END ... clauses to your controls definition.",{"QUIT"})
      ::QUIT()
    ENDIF
  ENDIF

  ASize( ::FParentList, Len( ::FParentList ) - 1 )

  ::SizerAddOnLastChild()

RETURN

/*
  RemoveLastSizer
  Teo. Mexico 2008
*/
METHOD PROCEDURE RemoveLastSizer CLASS TContainerObj
  LOCAL a
  a := ATail( ::FParentList )[ "sizers" ]
  IF Empty( a )
    Alert("Attempt to remove a Sizer on a empty sizers stack.",{"QUIT"})
    //::QUIT()
  ENDIF
  ::SizerAddOnLastChild()
  ASize( a, Len( a ) - 1 )
RETURN

/*
  SetLastChild
  Teo. Mexico 2008
*/
METHOD PROCEDURE SetLastChild( child ) CLASS TContainerObj
  IF ::GetLastChild()[ "child" ] == child
    RETURN
  ENDIF

  ::SizerAddOnLastChild()

  ::CheckForAddPage( child )

  ::GetLastChild()[ "child" ] := child
  ::GetLastChild()[ "processed" ] := .F.

RETURN

/*
  SizerAddOnLastChild
  Teo. Mexico 2008
*/
METHOD PROCEDURE SizerAddOnLastChild CLASS TContainerObj
  LOCAL child
  LOCAL sizerInfo

  child := ::GetLastChild()[ "child" ]

  IF child != NIL .AND. ! ::GetLastChild()[ "processed" ]

    ::GetLastChild()[ "processed" ] := .T. /* avoid infinite recursion */

    sizerInfo := ::GetLastChild()[ "sizerInfo" ]
    ::GetLastChild()[ "sizerInfo" ] := NIL

    IF sizerInfo == NIL
      wxh_SizerInfoAdd( child )
    ELSE
      wxh_SizerInfoAdd( child, NIL, sizerInfo[ "strech" ], sizerInfo[ "align" ], sizerInfo[ "border" ], sizerInfo[ "sideBorders" ], sizerInfo[ "flag" ] )
    ENDIF

  ENDIF

RETURN

/*
  End Class TContainerObj
*/

/*
  TGlobal class to hold global vars...
  Teo. Mexico 2007
*/
CLASS TGlobal
PRIVATE:
PROTECTED:
PUBLIC:
  DATA g_menuID INIT 1
  DATA g_menuList
  DATA g_menuBar
  DATA g_window
  METHOD lenMenuList INLINE Len( ::g_menuList )
PUBLISHED:
ENDCLASS

/*
  End Class TGlobal
*/
