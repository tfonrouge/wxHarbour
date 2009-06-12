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

#include "wxh/textctrl.ch"

#include "wxharbour.ch"

#ifdef __XHARBOUR__

#include "wx_hbcompat.ch"

#endif

STATIC containerObj
STATIC menuData

/*
  wxMenuItem_1
  Teo. Mexico 2009
*/
CLASS wxMenuItem_1 FROM wxMenuItem
PRIVATE:
PROTECTED:
PUBLIC:
  DATA enableBlock
PUBLISHED:
ENDCLASS

/*
  EndClass wxMenuItem_1
*/

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
  __wxh_BookAddPage
  Teo. Mexico 2008
*/
PROCEDURE __wxh_BookAddPage( title, select, imageId )

  containerObj():AddToNextBookPage( {"title"=>title,"select"=>select,"imageId"=>imageId} )

RETURN

/*
  __wxh_BookBegin
  Teo. Mexico 2008
*/
FUNCTION __wxh_BookBegin( bookClass, parent, id, pos, size, style, name )
  LOCAL book

  IF parent == NIL
    parent := containerObj():LastParent()
  ENDIF

  book := bookClass:New( parent, id, pos, size, style, name )

  containerObj():SetLastChild( book )

  containerObj():AddToParentList( book )

RETURN book

/*
  __wxh_BookEnd
  Teo. Mexico 2008
*/
PROCEDURE __wxh_BookEnd( book )
  containerObj():RemoveLastParent( book )
RETURN

/*
 * __wxh_BoxSizerBegin
 * Teo. Mexico 2008
 */
FUNCTION __wxh_BoxSizerBegin( parent, label, orient, strech, align, border, sideBorders )
  LOCAL sizer
  LOCAL lastSizer

  IF parent = NIL
    parent := containerObj():LastParent()
  ENDIF

  lastSizer := containerObj():LastSizer()

  IF label = NIL
    sizer := wxBoxSizer():New( orient )
  ELSE
    sizer := wxStaticBoxSizer():New( orient, parent, label )
    //sizer := wxStaticBoxSizer():New( wxStaticBox():New( parent, , label ) , orient )
  ENDIF

  IF lastSizer == NIL
    __wxh_SetSizer( parent, sizer )
  ELSE
    __wxh_SizerInfoAdd( sizer, lastSizer, strech, align, border, sideBorders )
  ENDIF

  containerObj():AddToSizerList( sizer )

RETURN sizer

/*
  __wxh_Browse
  Teo. Mexico 2008
 */
FUNCTION __wxh_Browse( dataSource, window, id, label, pos, size, minSize, style, name, onKey, onSelectCell )
  LOCAL wxhBrw

  IF window = NIL
    window := containerObj():LastParent()
  ENDIF

  wxhBrw := wxhBrowse():New( window, id, label, pos, size, style, name, onKey )

  IF dataSource != NIL
    wxhBrw:DataSource := dataSource
  ENDIF

  wxhBrw:SelectCellBlock := onSelectCell

  IF minSize != NIL
    wxhBrw:SetMinSize( minSize )
  ENDIF

  containerObj():SetLastChild( wxhBrw )

RETURN wxhBrw

/*
  __wxh_BrowseAddColumn
  Teo. Mexico 2008
*/
PROCEDURE __wxh_BrowseAddColumn( zero, wxhBrw, title, block, picture, width, type, wp )
  LOCAL column := wxhBColumn():New( title, block )

  column:Picture := picture
  column:Width   := width

  IF zero
    wxhBrw:ColumnZero := column
  ELSE
    wxhBrw:AddColumn( column )
  ENDIF
  
  IF type != NIL
    type := Upper( type )
    DO CASE
    CASE type == "BOOL"
      wxhBrw:grid:SetColFormatBool( wxhBrw:ColCount() - 1 )
    CASE type == "NUMBER"
      wxhBrw:grid:SetColFormatNumber( wxhBrw:ColCount() - 1 )
    CASE type == "FLOAT"
      IF wp != NIL
        wxhBrw:grid:SetColFormatFloat( wxhBrw:ColCount() - 1, wp[ 1 ], wp[ 2 ] )
      ENDIF
    ENDCASE
  ENDIF

RETURN

/*
  __wxh_Button
  Teo. Mexico 2008
*/
FUNCTION __wxh_Button( window, id, label, pos, size, style, validator, name, default, bAction )
  LOCAL button

  IF window = NIL
    window := containerObj():LastParent()
  ENDIF

  button := wxButton():New( window, id, label, pos, size, style, validator, name )

  IF bAction != NIL
    button:ConnectCommandEvt( button:GetID(), wxEVT_COMMAND_BUTTON_CLICKED, bAction )
  ENDIF

  IF default == .T.
    button:SetDefault()
  ENDIF

  containerObj():SetLastChild( button )

RETURN button

/*
  __wxh_CheckBox
  Teo. Mexico 2009
*/
FUNCTION __wxh_CheckBox( window, id, label, wxhGet, pos, size, style, validator, name, bAction )
  LOCAL checkBox

  IF window = NIL
    window := containerObj():LastParent()
  ENDIF

  checkBox := wxHBCheckBox():New( window, id, label, wxhGet, pos, size, style, validator, name )

  IF bAction != NIL
    checkBox:ConnectCommandEvt( checkBox:GetID(), wxEVT_COMMAND_CHECKBOX_CLICKED, bAction )
  ENDIF

  containerObj():SetLastChild( checkBox )

RETURN checkBox

/*
  __wxh_Gauge
  Teo. Mexico 2008
*/
FUNCTION __wxh_Gauge( window, id, range, pos, size, style, validator, name, type )
  LOCAL gauge

  IF window = NIL
    window := containerObj():LastParent()
  ENDIF

  IF type != NIL
    IF style = NIL
      style := type
    ELSE
      style := _hb_BitOr( style, type )
    ENDIF
  ENDIF

  gauge := wxGauge():New( window, id, range, pos, size, style, validator, name )

  containerObj():SetLastChild( gauge )

RETURN gauge

/*
  __wxh_Grid
  Teo. Mexico 2008
 */
FUNCTION __wxh_Grid( window, id, pos, size, style, name, rows, cols )
  LOCAL grid

  IF window = NIL
    window := containerObj():LastParent()
  ENDIF

  grid := wxGrid():New( window, id, pos, size, style, name )

  IF cols != NIL .OR. rows != NIL
    grid:CreateGrid( rows, cols )
  ENDIF

  containerObj():SetLastChild( grid )

RETURN grid

/*
  __wxh_RadioBox
  Teo. Mexico 2009
*/
FUNCTION __wxh_RadioBox( parent, id, label, point, size, choices, majorDimension, style, validator, name, wxhGet, bAction )
  LOCAL radioBox

  IF parent = NIL
    parent := containerObj():LastParent()
  ENDIF

  radioBox := wxHBRadioBox():New( parent, id, label, point, size, choices, majorDimension, style, validator, name, wxhGet )

  IF bAction != NIL
    radioBox:ConnectCommandEvt( radioBox:GetID(), wxEVT_COMMAND_RADIOBOX_SELECTED, bAction )
  ENDIF

  containerObj():SetLastChild( radioBox )

RETURN radioBox

/*
  __wxh_Choice
  Teo. Mexico 2009
*/
FUNCTION __wxh_Choice( parent, id, point, size, choices, style, validator, name, wxhGet, bAction )
  LOCAL choice

  IF parent = NIL
    parent := containerObj():LastParent()
  ENDIF

  choice := wxHBChoice():New( parent, id, point, size, choices, style, validator, name, wxhGet )

  IF bAction != NIL
    choice:ConnectCommandEvt( choice:GetID(), wxEVT_COMMAND_CHOICE_SELECTED, bAction )
  ENDIF

  containerObj():SetLastChild( choice )

RETURN choice

/*
  __wxh_ComboBox
  Teo. Mexico 2009
*/
FUNCTION __wxh_ComboBox( parent, id, value, point, size, choices, style, validator, name, wxhGet, bAction )
  LOCAL comboBox

  IF parent = NIL
    parent := containerObj():LastParent()
  ENDIF

  comboBox := wxHBComboBox():New( parent, id, value, point, size, choices, style, validator, name, wxhGet )

  IF bAction != NIL
    comboBox:ConnectCommandEvt( comboBox:GetID(), wxEVT_COMMAND_TEXT_UPDATED, bAction )
  ENDIF

  containerObj():SetLastChild( comboBox )

RETURN comboBox

/*
  __wxh_Dialog
  Teo. Mexico 2008
*/
FUNCTION __wxh_Dialog( fromClass, oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName, onClose, initDlg )
  LOCAL dlg

  IF Empty( fromClass )
    dlg := wxDialog():New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
  ELSE
    dlg := __ClsInstFromName( fromClass ):New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
    IF !dlg:IsDerivedFrom( "wxDialog" )
      dlg:IsNotDerivedFrom_wxDialog()
    ENDIF
  ENDIF

  IF onClose != NIL
    dlg:ConnectCloseEvt( dlg:GetId(), wxEVT_CLOSE_WINDOW, onClose )
  ENDIF

  IF initDlg != NIL
    dlg:ConnectInitDialogEvt( dlg:GetId(), wxEVT_INIT_DIALOG, initDlg )
  ENDIF

  containerObj():AddToParentList( dlg )

RETURN dlg

/*
  __wxh_Frame
  Teo. Mexico 2008
*/
FUNCTION __wxh_Frame( frameType, fromClass, oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName, onClose )
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

  IF onClose != NIL
    oWnd:ConnectCloseEvt( oWnd:GetId(), wxEVT_CLOSE_WINDOW, onClose )
  ENDIF

  containerObj():AddToParentList( oWnd )

RETURN oWnd

/*
 * __wxh_GET
 * Teo. Mexico 2008
 */
FUNCTION __wxh_GET( window, id, wxhGet, pos, size, multiLine, style, validator, name, picture, warn, toolTip, bAction )
  LOCAL Result

  IF window = NIL
    window := containerObj():LastParent()
  ENDIF

  IF multiLine == .T.
    IF Empty( style )
      style := wxTE_MULTILINE
    ELSE
      style := _hb_BitOr( wxTE_MULTILINE, style )
    ENDIF
  ENDIF
  
  __wxh_TransWidth( NIL, window, Len( wxhGet:AsString ), size )

  Result := wxHBTextCtrl():New( window, id, wxhGet, pos, size, style, validator, name, picture, warn, toolTip, bAction )

  containerObj():SetLastChild( Result )

RETURN Result

/*
 * __wxh_GridSizerBegin
 * Teo. Mexico 2008
 */
PROCEDURE __wxh_GridSizerBegin( rows, cols, vgap, hgap, strech, align, border, sideBorders )
  LOCAL sizer
  LOCAL parent
  LOCAL lastSizer

  sizer := wxGridSizer():New( rows, cols, vgap, hgap )

  parent := containerObj():LastParent()
  lastSizer := containerObj():LastSizer

  IF lastSizer == NIL
    __wxh_SetSizer( parent, sizer )
  ELSE
    __wxh_SizerInfoAdd( sizer, lastSizer, strech, align, border, sideBorders )
  ENDIF

  containerObj():AddToSizerList( sizer )

RETURN

/*
  __wxh_ListCtrl
  Teo. Mexico 2009
*/
FUNCTION __wxh_ListCtrl( window, id, value, pos, size, style, validator, name, bAction )
  LOCAL listCtrl

  IF window = NIL
    window := containerObj():LastParent()
  ENDIF

  listCtrl := wxListCtrl():New( window, id, value, pos, size, style, validator, name )

  IF bAction != NIL
    listCtrl:ConnectCommandEvt( listCtrl:GetID(), wxEVT_COMMAND_TEXT_UPDATED, bAction )
  ENDIF

  containerObj():SetLastChild( listCtrl )

RETURN listCtrl

/*
  __wxh_MenuBarBegin
  Teo. Mexico 2006
*/
FUNCTION __wxh_MenuBarBegin( window, style )
  menuData := TGlobal():New()
  menuData:g_menuBar := wxMenuBar():New( style )
  IF window = NIL
    //menuData:g_window := __wxh_LastTopLevelWindow()
    menuData:g_window := containerObj():LastParent( "wxFrame" )
  ELSE
    menuData:g_window := window
  ENDIF
RETURN menuData:g_menuBar

/*
  __wxh_MenuBegin
  Teo. Mexico 2006
*/
FUNCTION __wxh_MenuBegin( title, evtHandler )
  LOCAL hData := {=>}
  LOCAL menu

  IF menuData = NIL
    menuData := TGlobal():New()
    AAdd( menuData:g_menuList, NIL ) /* a NULL MenuBar (1st item in array) */
  ENDIF

  IF evtHandler != NIL
    menuData:g_window := evtHandler
  ENDIF

  menu := wxMenu():New()
  hData["menu"] := menu
  hData["title"] := title
  AAdd( menuData:g_menuList, hData )

RETURN menu

/*
  __wxh_MenuEnd
  Teo. Mexico 2006
*/
PROCEDURE __wxh_MenuEnd
  LOCAL hData
  LOCAL menuListSize
  LOCAL menuItem
  LOCAL nLast
  LOCAL parentMenu

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

    parentMenu := menuData:g_menuList[ nLast -1 ]

    IF parentMenu = NIL
      menuData := NIL
      RETURN
    ELSE
      menuItem := wxMenuItem_1():New( parentMenu["menu"], menuData:g_menuID++, hData["title"], "", wxITEM_NORMAL, hData["menu"] )
      parentMenu["menu"]:Append( menuItem )
    ENDIF

  ENDIF

  ASize( menuData:g_menuList, menuListSize - 1)

RETURN

/*
  __wxh_MenuItemAdd
  Teo. Mexico 2006
*/
FUNCTION __wxh_MenuItemAdd( text, id, helpString, kind, bAction, bEnabled )
  LOCAL menu
  LOCAL menuItem
  LOCAL nLast

  IF id=NIL
    id := menuData:g_menuID++
  ENDIF

  IF menuData:g_menuList = NIL
    wxhAlert( "No Menu at sight to add this MenuItem. Check your DEFINE MENU and ADD MENUITEM definition at line " + LTrim(Str(ProcLine( 1 ))) + " on " + ProcName( 1 ) )
    RETURN NIL
  ENDIF

  nLast := menuData:lenMenuList
  menu := menuData:g_menuList[ nLast ]["menu"]

  menuItem := wxMenuItem_1():New( menu, id, text, helpString, kind )

  menu:Append( menuItem )

  IF bAction != NIL
    menuData:g_window:ConnectCommandEvt( id, wxEVT_COMMAND_MENU_SELECTED, bAction )
  ENDIF

  IF bEnabled != NIL
    IF ValType( bEnabled ) = "B"
      menuItem:enableBlock := bEnabled
      menu:ConnectMenuEvt( -1, wxEVT_MENU_OPEN, ;
        BEGIN_CB |menuEvent|
          LOCAL menu
          LOCAL menuItem
          LOCAL menuItemList

          menu := menuEvent:GetMenu()
          menuItemList := menu:GetMenuItems()

          FOR EACH menuItem IN menuItemList
            IF menuItem:enableBlock != NIL
              menuItem:Enable( menuItem:enableBlock:Eval() )
            ENDIF
          NEXT

          RETURN NIL
        END_CB )
    ELSE
      menuItem:Enable( bEnabled )
    ENDIF
  ENDIF

RETURN menuItem

/*
 * __wxh_PanelBegin
 * Teo. Mexico 2008
 */
FUNCTION __wxh_PanelBegin( parent, id, pos, size, style, name, bEnabled )
  LOCAL panel

  IF parent = NIL
    parent := containerObj():LastParent()
  ENDIF

  panel := wxPanel():New( parent, id, pos, size, style, name )

  IF bEnabled != NIL
    panel:enableBlock := bEnabled
  ENDIF

  containerObj():SetLastChild( panel )

  containerObj():AddToParentList( panel )

RETURN panel

/*
  __wxh_PanelEnd
  Teo. Mexico 2008
*/
PROCEDURE __wxh_PanelEnd
  containerObj():RemoveLastParent( "wxPanel" )
RETURN

/*
 * __wxh_SAY
 * Teo. Mexico 2008
 */
FUNCTION __wxh_SAY( window, id, label, pos, size, style, name )
  LOCAL Result

  IF window = NIL
    window := containerObj():LastParent()
  ENDIF
  
  __wxh_TransWidth( NIL, window, Len( label ), size )

  Result := wxStaticText():New( window, id, label, pos, size, style, name )

  containerObj():SetLastChild( Result )

RETURN Result

/*
  __wxh_ScrollBar
  Teo. Mexico 2008
*/
FUNCTION __wxh_ScrollBar( window, id, pos, size, orient, style, validator, name, bAction )
  LOCAL sb

  IF window = NIL
    window := containerObj():LastParent()
  ENDIF

  IF Empty( style )
    style := orient
  ELSE
    style := _hb_BitOr( orient, style )
  ENDIF

  sb := wxScrollBar():New( window, id, pos, size, style, validator, name )
  sb:SetScrollbar( 0, 1, 100, 1)

  IF bAction != NIL
    sb:ConnectCommandEvt( sb:GetID(), wxEVT_COMMAND_BUTTON_CLICKED, bAction )
  ENDIF

  containerObj():SetLastChild( sb )

RETURN sb

/*
  __wxh_SetSizer
  Teo. Mexico 2008
*/
PROCEDURE __wxh_SetSizer( window, sizer )
  LOCAL bookCtrl
  LOCAL IsWindowBook := .F.

  FOR EACH bookCtrl IN containerObj():BookCtrls
    IF window:IsDerivedFrom( bookCtrl )
      IsWindowBook := .T.
    ENDIF
  NEXT

  IF IsWindowBook
    wxhAlert( "Sizer cannot be a direct child of a " + window:ClassName() + " control.;Check your Sizer definition at line " + LTrim(Str(ProcLine(2))) + " on " + ProcName( 2 ) )
  ENDIF

  window:SetSizer( sizer )

RETURN

/*
  __wxh_ShowWindow : shows wxFrame/wxDialog
  Teo. Mexico 2008
*/
FUNCTION __wxh_ShowWindow( oWnd, modal, fit, centre )
  LOCAL Result
  LOCAL ctrl

  containerObj():ClearData()

  IF fit
    IF oWnd:GetSizer() != NIL
      oWnd:GetSizer():SetSizeHints( oWnd )
    ENDIF
  ENDIF

  IF centre
    oWnd:Centre()
  ENDIF

  IF .T. /* Focus on first available control */
    FOR EACH ctrl IN oWnd:GetChildren()
      IF ctrl != NIL .AND. ctrl:IsDerivedFrom("wxTextCtrl")
        ctrl:SetFocus()
        EXIT
      ENDIF
    NEXT
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
 * __wxh_SizerInfoAdd
 * Teo. Mexico 2008
 */
PROCEDURE __wxh_SizerInfoAdd( child, parentSizer, strech, align, border, sideBorders, flag, useLast, addSizerInfoToLastItem )
  LOCAL sizerInfo

  IF Empty( containerObj():ParentList )
    RETURN
  ENDIF

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
    //wxhAlert( "No parent Sizer available.", {"QUIT"})
    //TRACE "Child:", child:ClassName, "No parent Sizer available"
    RETURN
  ENDIF

  IF strech = NIL
    strech := 0
  ENDIF

  IF align = NIL
    IF parentSizer != NIL
      IF parentSizer:IsDerivedFrom("wxGridSizer")
        align := _hb_BitOr( wxALIGN_CENTER_HORIZONTAL, wxALIGN_CENTER_VERTICAL )
      ELSE
        IF parentSizer:GetOrientation() = wxVERTICAL
          align := _hb_BitOr( wxALIGN_CENTER_HORIZONTAL, wxALL )
        ELSE
          align := _hb_BitOr( wxALIGN_CENTER_VERTICAL, wxALL )
        ENDIF
      ENDIF
    ELSE
      align := 0
    ENDIF
  ENDIF

  /* TODO: Make a more configurable way to do this */
  IF parentSizer != NIL .AND. parentSizer:IsDerivedFrom("wxGridSizer")
    align := _hb_BitOr( align, wxALIGN_CENTER_VERTICAL )
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

  parentSizer:Add( child, strech, _hb_BitOr( align, sideBorders, flag ), border )

RETURN

/*
 * __wxh_SizerEnd
 * Teo. Mexico 2008
 */
PROCEDURE __wxh_SizerEnd
  containerObj():RemoveLastSizer()
RETURN

/*
 * __wxh_Spacer
 * Teo. Mexico 2008
 */
PROCEDURE __wxh_Spacer( width, height, strech, align, border )
  LOCAL lastSizer
  
  containerObj():SizerAddOnLastChild()

  lastSizer := containerObj():LastSizer()

  IF lastSizer == NIL
    wxhAlert( "No Sizer available to add a Spacer",{"QUIT"})
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
    IF lastSizer:IsDerivedFrom("wxBoxSizer")
      IF !lastSizer:GetOrientation() = wxHORIZONTAL
        align := _hb_BitOr( wxALIGN_CENTER_HORIZONTAL, wxALL )
      ELSE
        align := _hb_BitOr( wxALIGN_CENTER_VERTICAL, wxALL )
      ENDIF
    ENDIF
  ENDIF

  IF border = NIL
    border := 5
  ENDIF

  lastSizer:Add( width, height, strech, align, border )

RETURN

/*
  __wxh_SpinCtrl
  Teo. Mexico 2008
*/
FUNCTION __wxh_SpinCtrl( parent, id, value, pos, size, style, min, max, initial, name, bAction )
  LOCAL spinCtrl

  IF parent = NIL
    parent := containerObj():LastParent()
  ENDIF

  spinCtrl := wxSpinCtrl():New( parent, id, value, pos, size, style, min, max, initial, name )

  IF bAction != NIL
    spinCtrl:ConnectCommandEvt( spinCtrl:GetID(), wxEVT_COMMAND_SPINCTRL_UPDATED, bAction )
  ENDIF

  containerObj():SetLastChild( spinCtrl )

RETURN spinCtrl

/*
  __wxh_StatusBar
  Teo. Mexico 2006
*/
FUNCTION __wxh_StatusBar( oW, id, style, name, fields, widths )
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
  __wxh_StaticLine
  Teo. Mexico 2008
*/
FUNCTION __wxh_StaticLine( window, id, pos, orient, name )
  LOCAL sl

  IF window = NIL
    window := containerObj():LastParent()
  ENDIF

  sl := wxStaticLine():New( window, id, pos, NIL, orient, name )

  containerObj():SetLastChild( sl )

RETURN sl

/*
  __wxh_StaticText
  Teo. Mexico 2008
*/
FUNCTION __wxh_StaticText( parent, id, label, pos, size, style, name )
  LOCAL staticText

  IF parent = NIL
    parent := containerObj():LastParent()
  ENDIF

  staticText := wxStaticText():New( parent, id, label, pos, size, style, name )

  containerObj():SetLastChild( staticText )

RETURN staticText

/*
  __wxh_TransWidth
  Teo. Mexico 2009
*/
STATIC FUNCTION __wxh_TransWidth( width, window, defaultWidth, aSize )
  LOCAL pointSize
  
  IF window != NIL

	pointSize := window:GetPointSize() - 3

	IF aSize != NIL
	  width := aSize[ 1 ]
	ENDIF
	
	IF width = NIL
	  width := -1
	ENDIF

	IF HB_ISCHAR( width )
	  width := pointSize * Val( width )
	ELSEIF ( width = NIL .OR. ( HB_ISNUMERIC( width ) .AND. width = -1 ) ) .AND. defaultWidth != NIL
	  width := pointSize * defaultWidth
	ENDIF
	
	IF aSize != NIL
	  aSize[ 1 ] := width
	ENDIF

  ENDIF
  
RETURN width

/*
  __wxh_TextCtrl
  Teo. Mexico 2008
*/
FUNCTION __wxh_TextCtrl( window, id, value, pos, size, style, validator, name, multiLine, bAction )
  LOCAL textCtrl

  IF window = NIL
    window := containerObj():LastParent()
  ENDIF

  IF multiLine == .T.
    IF Empty( style )
      style := wxTE_MULTILINE
    ELSE
      style := _hb_BitOr( wxTE_MULTILINE, style )
    ENDIF
  ENDIF

  textCtrl := wxTextCtrl():New( window, id, value, pos, size, style, validator, name )

  IF bAction != NIL
    textCtrl:ConnectCommandEvt( textCtrl:GetID(), wxEVT_COMMAND_TEXT_UPDATED, bAction )
  ENDIF

  containerObj():SetLastChild( textCtrl )

RETURN textCtrl

/*
  __wxh_SearchCtrl
  Teo. Mexico 2008
*/
FUNCTION __wxh_SearchCtrl( window, id, value, pos, size, style, validator, name, multiLine, bAction )
  LOCAL searchCtrl

  IF window = NIL
    window := containerObj():LastParent()
  ENDIF

  IF multiLine == .T.
    IF Empty( style )
      style := wxTE_MULTILINE
    ELSE
      style := _hb_BitOr( wxTE_MULTILINE, style )
    ENDIF
  ENDIF

  searchCtrl := wxSearchCtrl():New( window, id, value, pos, size, style, validator, name )

  IF bAction != NIL
    searchCtrl:ConnectCommandEvt( searchCtrl:GetID(), wxEVT_COMMAND_TEXT_UPDATED, bAction )
  ENDIF

  containerObj():SetLastChild( searchCtrl )

RETURN searchCtrl

/*
  __wxh_TreeCtrl
  Teo. Mexico 2008
 */
FUNCTION __wxh_TreeCtrl( window, id, pos, size, style, validator, name )
  LOCAL Result

  IF window = NIL
    window := ContainerObj():LastParent()
  ENDIF

  Result := wxTreeCtrl():New( window, id, pos, size, style, validator, name )

  containerObj():SetLastChild( Result )

RETURN Result

/*
  wxhInspectVar
  Teo. Mexico 2008
*/
PROCEDURE wxhInspectVar( xVar )
  LOCAL oDlg
  LOCAL aMsg
  LOCAL value
  LOCAL cMsg,msgAccs
  LOCAL a,aMethods
  LOCAL oErr

  SWITCH ValType( xVar )
  CASE 'O'
    aMsg := xVar:ClassSel()
    ASort( aMsg,,, {|x,y| PadR( x, 64 ) < PadR( y, 64 ) } )
    a := {}
    aMethods := {}

    FOR EACH cMsg IN aMsg
      msgAccs := SubStr( cMsg, 2 )
      IF cMsg = "_" .AND. AScan( aMsg, msgAccs,,, .T. ) != 0
        BEGIN SEQUENCE WITH {|oErr| break( oErr ) }
          //value := AsString( __wxh_objGetDataValue( xVar, msgAccs ) )
          value := "xVar:msgAccs"
        RECOVER USING oErr
          value := oErr:Description
        END SEQUENCE
        AAdd( a, { msgAccs, value })
      ELSEIF AScan( aMsg, "_" + msgAccs,,, .T. ) = 0
        AAdd( aMethods, msgAccs )
      ENDIF
    NEXT
    a := __objGetValueList( xVar, .T., 0 )
    EXIT
  END

  IF Empty( a )
    wxMessageBox("Cannot inspect value.","wxhInspectVar", wxICON_EXCLAMATION )
    RETURN
  ENDIF

  CREATE DIALOG oDlg ;
         HEIGHT 800 WIDTH 600 ;
         TITLE "Inspecting Var: "

  BEGIN BOXSIZER VERTICAL
    @ BROWSE DATASOURCE a ;
      SIZERINFO ALIGN EXPAND STRETCH
    BEGIN BOXSIZER HORIZONTAL ALIGN RIGHT
      @ BUTTON ID wxID_CLOSE ACTION oDlg:Close()
    END SIZER
  END SIZER

  SHOW WINDOW oDlg MODAL CENTRE

RETURN

/*
  TContainerObj
  Teo. Mexico 2008
*/
CLASS TContainerObj
PRIVATE:
  DATA FMainContainerStack INIT {}
  METHOD GetParentList INLINE ATail( ::FMainContainerStack )
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
  PROPERTY ParentList READ GetParentList
PUBLISHED:
ENDCLASS

/*
  AddSizerInfoToLastItem
  Teo. Mexico 2008
*/
METHOD PROCEDURE AddSizerInfoToLastItem( sizerInfo ) CLASS TContainerObj

  /* if has not child yet defined then is a parent ctrl */
  IF ATail( ::ParentList )[ "lastChild" ][ "child" ] == NIL
    /* control is in lastChild in the previuos Parent list */
    IF ::GetLastParent( -1 ) != NIL
      ::GetLastParent( -1 )[ "lastChild" ][ "sizerInfo" ] := sizerInfo
    ENDIF
  ELSE
    ATail( ::ParentList )[ "lastChild" ][ "sizerInfo" ] := sizerInfo
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
    wxhAlert( "Previuos page not a " + bookCtrl + " control" )
    RETURN
  ENDIF

  ATail( ::ParentList )[ "pageInfo" ] := hInfo

RETURN

/*
  AddToParentList
  Teo. Mexico 2008
*/
METHOD PROCEDURE AddToParentList( parent ) CLASS TContainerObj
  IF parent:IsDerivedFrom( "wxFrame" ) .OR. ;
     parent:IsDerivedFrom( "wxDialog" ) .OR. ;
     ::ParentList == NIL
    AAdd( ::FMainContainerStack, {} )
  ENDIF
  IF parent == NIL
    wxhAlert( "Trying to add a NIL value to the ParentList stack",{"QUIT"})
    ::QUIT()
  ENDIF
  AAdd( ::ParentList, { "parent"=>parent, "sizers"=>{}, "pageInfo"=>NIL, "lastChild"=>{ "child"=>NIL, "processed"=>.F., "sizerInfo"=>NIL } } )
RETURN

/*
  AddToSizerList
  Teo. Mexico 2008
*/
METHOD PROCEDURE AddToSizerList( sizer ) CLASS TContainerObj
  AAdd( ATail( ::ParentList )[ "sizers" ], sizer )
RETURN

/*
  ClearData
  Teo. Mexico 2008
*/
METHOD PROCEDURE ClearData CLASS TContainerObj
  HB_ADel( ::FMainContainerStack, Len( ::FMainContainerStack ), .T. )
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
    hInfo := ATail( ::ParentList )[ "pageInfo" ]
    IF  hInfo != NIL
      ::LastParent():AddPage( window, hInfo["title"], hInfo["select"], hInfo["imageId"] )
      ATail( ::ParentList )[ "pageInfo" ] := NIL
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
  IF Empty( ::ParentList )
    RETURN NIL
  ENDIF
RETURN ATail( ::ParentList )[ "lastChild" ]

/*
  GetLastParent
  Teo. Mexico 2008
*/
METHOD FUNCTION GetLastParent( index ) CLASS TContainerObj
  IF Empty( index )
    RETURN ATail( ::ParentList )
  ENDIF
  index := Len( ::ParentList ) + index
  IF index < 1 .OR. index > Len( ::ParentList )
    RETURN NIL
  ENDIF
RETURN ::ParentList[ index ]

/*
  LastParent
  Teo. Mexico 2008
*/
METHOD FUNCTION LastParent CLASS TContainerObj
  IF Empty( ::ParentList )
    RETURN NIL
  ENDIF
RETURN ATail( ::ParentList )[ "parent" ]

/*
  LastSizer
  Teo. Mexico 2008
*/
METHOD FUNCTION LastSizer CLASS TContainerObj
  IF Empty( ::ParentList )
    RETURN NIL
  ENDIF
RETURN ATail( ATail( ::ParentList )[ "sizers" ] )

/*
  RemoveLastParent
  Teo. Mexico 2008
*/
METHOD PROCEDURE RemoveLastParent( className ) CLASS TContainerObj

  /* do some checking */
  IF className != NIL
    IF !Upper( ATail( ::ParentList )[ "parent" ]:ClassName ) == Upper( className )
      wxhAlert("Attempt to remove wrong parent on stack (ClassName not equal).;"+Upper( ATail( ::ParentList )[ "parent" ]:ClassName ) + "==" + Upper( className )+";"+"Check for missing/wrong END ... clauses to your controls definition.",{"QUIT"})
      ::QUIT()
    ENDIF
  ENDIF

  ASize( ::ParentList, Len( ::ParentList ) - 1 )

  ::SizerAddOnLastChild()

RETURN

/*
  RemoveLastSizer
  Teo. Mexico 2008
*/
METHOD PROCEDURE RemoveLastSizer CLASS TContainerObj
  LOCAL a
  a := ATail( ::ParentList )[ "sizers" ]
  IF Empty( a )
    wxhAlert("Attempt to remove a Sizer on a empty sizers stack.",{"QUIT"})
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

  IF Empty( ::ParentList )
    RETURN
  ENDIF

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

  IF Empty( ::ParentList )
    RETURN
  ENDIF

  child := ::GetLastChild()[ "child" ]

  IF child != NIL .AND. ! ::GetLastChild()[ "processed" ]

    ::GetLastChild()[ "processed" ] := .T. /* avoid infinite recursion */

    sizerInfo := ::GetLastChild()[ "sizerInfo" ]
    ::GetLastChild()[ "sizerInfo" ] := NIL

    IF sizerInfo == NIL
      __wxh_SizerInfoAdd( child )
    ELSE
      __wxh_SizerInfoAdd( child, NIL, sizerInfo[ "strech" ], sizerInfo[ "align" ], sizerInfo[ "border" ], sizerInfo[ "sideBorders" ], sizerInfo[ "flag" ] )
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

  CONSTRUCTOR New()

  METHOD lenMenuList INLINE Len( ::g_menuList )
PUBLISHED:
ENDCLASS

/*
  New
  Teo. Mexico 2009
*/
METHOD New() CLASS TGlobal
  ::g_menuList := {}
RETURN Self

/*
  End Class TGlobal
*/
