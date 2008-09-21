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
    parent:SetSizer( sizer )
  ELSE
    wxh_SizerAdd( lastSizer, sizer, strech, align, border, sideBorders )
  ENDIF

  containerObj():AddToSizerList( sizer )

RETURN sizer

/*
 * wxh_Button
 * Teo. Mexico 2008
 */
FUNCTION wxh_Button( window, id, label, pos, size, style, validator, name, bAction )
  LOCAL Result

  IF window = NIL
    window := ContainerObj():LastParent()
  ENDIF

  Result := wxButton():New( window, id, label, pos, size, style, validator, name )

  IF bAction != NIL
    window:Connect( Result:GetID(), wxEVT_COMMAND_BUTTON_CLICKED, bAction )
  ENDIF

  containerObj():SetLastChild( Result )

RETURN Result

/*
 * wxh_BrowseDb
 * Teo. Mexico 2008
 */
FUNCTION wxh_BrowseDb( table, window, id, pos, size, style, name )
  LOCAL Result

  IF window = NIL
    window := containerObj():LastParent()
  ENDIF

  Result := wxBrowseDb():New( table, window, id, pos, size, style, name )

  containerObj():SetLastChild( Result )

RETURN Result

/*
  wxh_BrowseDbAddColumn
  Teo. Mexico 2008
*/
PROCEDURE wxh_BrowseDbAddColumn( zero, wxBrw, title, block, picture, width )
  LOCAL hColumn := HB_HSetCaseMatch( {=>}, .F. )

  hColumn["title"]   := title
  hColumn["block"]   := block
  hColumn["picture"] := picture
  hColumn["width"]   := width

  IF zero
    wxBrw:GetTable():ColumnZero := hColumn
  ELSE
    wxBrw:GetTable():AddColumn( hColumn )
  ENDIF

RETURN

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
FUNCTION wxh_GET( var, window, id, value, pos, size, style, validator, name )
  LOCAL Result

  IF window = NIL
    window := containerObj():LastParent()
  ENDIF

  var := var

  Result := wxTextCtrl():New( window, id, value, pos, size, style, validator, name )

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
    parent:SetSizer( sizer )
  ELSE
    wxh_SizerAdd( lastSizer, sizer, strech, align, border, sideBorders )
  ENDIF

  containerObj():AddToSizerList( sizer )

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
  wxh_NotebookAddPage
  Teo. Mexico 2008
*/
PROCEDURE wxh_NotebookAddPage( title, select, imageId )

  containerObj():AddToNextNotebookPage( {"title"=>title,"select"=>select,"imageId"=>imageId} )

RETURN

/*
  wxh_NotebookBegin
  Teo. Mexico 2008
*/
FUNCTION wxh_NotebookBegin( parent)//, id, pos, size, style, name )
  LOCAL notebook

  IF parent == NIL
    parent := containerObj():LastParent()
  ENDIF

  //notebook := wxNotebook():New( parent, id, pos, size, style, name )
  notebook := wxNotebook():New( parent )//, id, pos, size, style, name )

  containerObj():SetLastChild( notebook )

  containerObj():AddToParentList( notebook )

RETURN notebook

/*
  wxh_NotebookEnd
  Teo. Mexico 2008
*/
PROCEDURE wxh_NotebookEnd
  containerObj():RemoveLastParent( "wxNotebook" )
RETURN

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
 * wxh_SizerAdd
 * Teo. Mexico 2008
 */
PROCEDURE wxh_SizerAdd( parentSizer, child, strech, align, border, sideBorders, flag )

  IF child = NIL

    /* Check if last child has been processed */
    IF containerObj():GetLastChild()[ 2 ]
      RETURN
    ENDIF

    child := containerObj():GetLastChild()[ 1 ]
    containerObj():GetLastChild()[ 2 ] := .T. /* mark processed */
    parentSizer := containerObj():GetLastChild()[ 3 ]

  ELSE

    IF parentSizer = NIL
      parentSizer := containerObj():LastSizer()
    ENDIF

  ENDIF

  IF parentSizer = NIL
    //Alert( "No parent Sizer available.", {"QUIT"})
    ? "No parent Sizer available."
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

  containerObj():CheckLastChildSizerAdd()

  IF parentSizer != NIL
    parentSizer:Add( child, strech, HB_BITOR( align, sideBorders, flag ), border )
  ENDIF

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
  TContainerObj
  Teo. Mexico 2008
*/
CLASS TContainerObj
PRIVATE:
  DATA FParentList
  DATA FLastChild INIT { NIL, .F., NIL }
PROTECTED:
PUBLIC:
  METHOD AddToParentList( parent )
  METHOD AddToSizerList( sizer )
  METHOD CheckForAddPage
  METHOD CheckLastChildSizerAdd
  METHOD ClearData
  METHOD GetLastChild INLINE ::FLastChild
  METHOD LastParent
  METHOD LastSizer
  METHOD RemoveLastParent
  METHOD RemoveLastSizer
  METHOD SetLastChild( child )
PUBLISHED:
ENDCLASS

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
  ::CheckLastChildSizerAdd()
  AAdd( ::FParentList, { "parent"=>parent, "sizers"=>{} } )
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
  ::FLastChild := { NIL, .F., NIL }
RETURN

/*
  CheckForAddPage
  Teo. Mexico 2008
*/
METHOD PROCEDURE CheckForAddPage( window ) CLASS TContainerObj

  IF ::LastParent():IsDerivedFrom("wxNotebook")
    ::LastParent():AddPage( window, "Tab" )
  ENDIF

RETURN

/*
  CheckLastChildSizerAdd
  Teo. Mexico 2008
*/
METHOD PROCEDURE CheckLastChildSizerAdd CLASS TContainerObj
  IF ::FLastChild[ 1 ] != NIL
    IF ! ::FLastChild[ 2 ]
      ::FLastChild[ 2 ] := .T. /* avoid infinite recursion */
      @ SIZER PARENTSIZER ::FLastChild[ 3 ] CHILD ::FLastChild[ 1 ]
      ::FLastChild[ 3 ] := NIL
    ENDIF
  ENDIF
RETURN

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
RETURN ATail( ATail( ::FParentList )[ "sizers" ] )

/*
  RemoveLastParent
  Teo. Mexico 2008
*/
METHOD PROCEDURE RemoveLastParent( className ) CLASS TContainerObj

  /* do some checking */
  IF className != NIL
    IF !Upper( ATail( ::FParentList )[ "parent" ]:ClassName ) == Upper( className )
      Alert("Attempt to remove wrong parent on stack (ClassName not equal).",{"QUIT"})
      ::QUIT()
    ENDIF
  ENDIF

  /*
    We dont call CheckLastChildSizerAdd here because is
    supposed that a END SIZER was done already
  */

  ASize( ::FParentList, Len( ::FParentList ) - 1 )

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
  ::CheckLastChildSizerAdd()
  ASize( a, Len( a ) - 1 )
RETURN

/*
  SetLastChild
  Teo. Mexico 2008
*/
METHOD PROCEDURE SetLastChild( child ) CLASS TContainerObj
  IF ::FLastChild[ 1 ] == child
    RETURN
  ENDIF

  ::CheckForAddPage( child )

  ::CheckLastChildSizerAdd()
  ::FLastChild[ 1 ] := child
  ::FLastChild[ 2 ] := .F.
  ::FLastChild[ 3 ] := ::LastSizer()
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
