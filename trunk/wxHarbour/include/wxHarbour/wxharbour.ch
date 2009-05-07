/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxHarbour.ch
  Teo. Mexico 2009
*/

#ifndef _WXHARBOUR_H_
#define _WXHARBOUR_H_

#xcommand IMPLEMENT_APP( <app> ) => <app>:Implement()

#ifdef __XHARBOUR__
#xtranslate BEGIN_CB => \<
#xtranslate END_CB   => >

#xtranslate BEGIN SEQUENCE WITH <w> => BEGIN SEQUENCE

#xtranslate _SW_OTHERWISE => DEFAULT

#else
#xtranslate BEGIN_CB => \{
#xtranslate END_CB   => }

#xtranslate _SW_OTHERWISE => OTHERWISE

#xtranslate _hb_BitOr(  => HB_BitOr(

#endif

#include "hbclass.ch"
#include "property.ch"
#include "raddox.ch"
#include "wx.ch"

#include "wxh/auibook.ch"
#include "wxh/gauge.ch"
#include "wxh/notebook.ch"
#include "wxh/textctrl.ch"

#define wxhLABEL_QUIT           "Quit"
#define wxhLABEL_RETRY          "Retry"
#define wxhLABEL_DEFAULT        "Default"

/* CheckBox 3 states */
#define wxCHK_UNCHECKED         0
#define wxCHK_CHECKED           1
#define wxCHK_UNDETERMINED      2

/*
  Calls ::__Destroy() to remove wxh_Item associated to objects
  Teo. Mexico 2009
*/
#xcommand DESTROY <obj> => <obj>:__Destroy() ; <obj> := NIL

/*
  MessageBox
*/
#define wxhMessageBoxYesNo( title, mess, parent ) ;
        wxMessageBox( mess, title, _hb_BitOr(wxYES_NO,wxICON_QUESTION), parent )

/*
  NTrim
*/
#define NTrim( n ) ;
        LTrim( Str( n ) )

/*!
 * Frame/Dialog
 */
#xcommand CREATE [<type: MDIPARENT,MDICHILD>] FRAME <oFrame> ;
          [ CLASS <fromClass> ] ;
          [ PARENT <oParent> ] ;
          [ ID <nID> ] ;
          [ TITLE <cTitle> ] ;
          [ FROM <nTop>, <nLeft> ] [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
          [ STYLE <nStyle> ] ;
          [ NAME <cName> ] ;
          [ ON CLOSE <onClose> ] ;
          => ;
          <oFrame> := __wxh_Frame( [<"type">], [<fromClass>], [<oParent>], [<nID>], <cTitle>, {<nTop>,<nLeft>}, {<nWidth>,<nHeight>}, [<nStyle>], [<cName>], [<{onClose}>] )

#xcommand CREATE DIALOG <oDlg> ;
          [ CLASS <fromClass> ] ;
          [ PARENT <oParent> ] ;
          [ ID <nID> ] ;
          [ TITLE <cTitle> ] ;
          [ FROM <nTop>, <nLeft> ] [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
          [ STYLE <nStyle> ] ;
          [ NAME <cName> ] ;
          [ ON CLOSE <onClose> ] ;
          [ ON INITDIALOG <initDlg> ] ;
          => ;
          <oDlg> := __wxh_Dialog( [<fromClass>], [<oParent>], [<nID>], <cTitle>, {<nTop>,<nLeft>}, {<nWidth>,<nHeight>}, [<nStyle>], [<cName>], [<{onClose}>] [<initDlg>] )

#xcommand FIT WINDOW <oWnd> ;
          => ;
          iif( <oWnd>:GetSizer() != NIL, <oWnd>:GetSizer():SetSizeHints( <oWnd> ), NIL )

#xcommand CENTRE WINDOW <oWnd> ;
          => ;
          <oWnd>:Centre()

#xcommand SHOW WINDOW <oWnd> [<modal: MODAL>] [<fit: FIT>] [TO <var>] [<centre: CENTRE>];
          => ;
          [<var> := ] __wxh_ShowWindow( <oWnd>, <.modal.>, <.fit.>, <.centre.> )

/*
  Menues
*/
#xcommand DEFINE MENUBAR [ VAR <oMB>] [STYLE <nStyle>] [ON <oWindow>] ;
          => ;
          [<oMB> := ] __wxh_MenuBarBegin( [<oWindow>], [<nStyle>] )

#xcommand DEFINE MENU [<cLabel>] [VAR <menu>] [ON <evtHandler>] ;
          => ;
          [<menu> :=] __wxh_MenuBegin( [<cLabel>], [<evtHandler>] )

#xcommand ADD MENUITEM <cLabel> ;
              [VAR <menu>] ;
              [ID <nID>] ;
              [HELPLINE <cHelpString>] ;
              [<kind: CHECK,RADIO>] ;
              [ACTION <bAction> ] ;
              [ENABLED <bEnabled> ] ;
          => ;
          [<menu> :=] __wxh_MenuItemAdd( <cLabel>, [<nID>], [<cHelpString>], [wxITEM_<kind>], [<{bAction}>], [<{bEnabled}>] )

#xcommand ADD MENUSEPARATOR ;
          => ;
          __wxh_MenuItemAdd( NIL, wxID_SEPARATOR )

#xcommand ENDMENU ;
          => ;
          __wxh_MenuEnd()

/*
 * SIZERS
 *
 * TODO: On ALIGN CENTER we need to create a wxALIGN_CENTER_[HORIZONTAL|VERTICAL]
 *       in sync with the parent sizer, currently we do just wxALIGN_CENTER
 *
 */

#define wxALIGN_EXPAND  wxGROW
#define wxSTRETCH        1

#xcommand @ SIZERINFO ;
          [ CHILD <child> ] ;
          [ PARENTSIZER <parentSizer> ] ;
          [ <stretch: STRETCH> ] ;
          [ ALIGN <align: TOP, LEFT, BOTTOM, RIGHT, CENTRE, CENTRE_HORIZONTAL, CENTRE_VERTICAL, CENTER, CENTER_HORIZONTAL, CENTER_VERTICAL, EXPAND> ] ;
          [ BORDER <border> ] ;
          [ SIDEBORDERS <sideborders,...> ] ;
          [ <useLast: LAST> ] ;
          => ;
          __wxh_SizerInfoAdd( ;
            [ <child> ],;
            [ <parentSizer> ],;
            [ wx<stretch> ],;
            [ wxALIGN_<align> ],;
            [ <border> ],;
            [ _hb_BitOr(0,<sideborders>) ],;
            NIL,;
            [ <.useLast.> ],;
            .T. ) /* No processing, sizer info to stack */

#xcommand BEGIN BOXSIZER <orient: VERTICAL, HORIZONTAL> ;
          [ VAR <bs> ] ;
          [ ON <parent> ] ;
          [ [LABEL] <label> ] ;
          [ <stretch: STRETCH> ] ;
          [ ALIGN <align: TOP, LEFT, BOTTOM, RIGHT, CENTRE, CENTRE_HORIZONTAL, CENTRE_VERTICAL, CENTER, CENTER_HORIZONTAL, CENTER_VERTICAL, EXPAND> ] ;
          [ BORDER <border> ] ;
          [ SIDEBORDERS <sideborders,...> ] ;
          => ;
          [ <bs> := ]__wxh_BoxSizerBegin( ;
            [ <parent> ], ;
            [ <label> ], ;
            wx<orient>,;
            [ wx<stretch> ],;
            [ wxALIGN_<align> ],;
            [ <border> ],;
            [ _hb_BitOr(0,<sideborders>) ] ;
          )

#xcommand BEGIN GRIDSIZER [ROWS <rows>] [COLS <cols>] [VGAP <vgap>] [HGAP <hgap>] ;
          [ <stretch: STRETCH> ] ;
          [ ALIGN <align: TOP, LEFT, BOTTOM, RIGHT, CENTRE, CENTRE_HORIZONTAL, CENTRE_VERTICAL, CENTER, CENTER_HORIZONTAL, CENTER_VERTICAL, EXPAND> ] ;
          [ BORDER <border> ] ;
          [ SIDEBORDERS <sideborders,...> ] ;
          => ;
          __wxh_GridSizerBegin( ;
            [ <rows> ],;
            [ <cols> ],;
            [ <vgap> ],;
            [ <hgap> ],;
            [ wx<stretch> ],;
            [ wxALIGN_<align> ],;
            [ <border> ],;
            [ _hb_BitOr(0,<sideborders>) ] ;
          )

#xcommand END SIZER ;
          => ;
          __wxh_SizerEnd()


#xcommand @ SPACER ;
          [ WIDTH <width> ] ;
          [ HEIGHT <height> ] ;
          [ <stretch: STRETCH> ] ;
          [ FLAG <flag> ] ;
          [ BORDER <border> ] ;
          => ;
          __wxh_Spacer( ;
            [<width>],;
            [<height>],;
            [ wx<stretch> ],;
            [<flag>],;
            [<border>] ;
          )

/*
  End Sizers
*/

/*
  BROWSE
*/
#xcommand @ BROWSE [ VAR <wxBrw> ] ;
            [ LABEL <label> ] ;
            [ DATASOURCE <dataSource> ] ;
            [ ON <window> ] ;
            [ ID <id> ] ;
            [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
            [ STYLE <style> ] ;
            [ NAME <name> ] ;
            [ ONKEY <onKey> ] ;
            [ ONSELECTCELL <onSelectCell> ] ;
          => ;
            [<wxBrw>:=]__wxh_Browse( ;
              [<dataSource>],;
              [<window>],;
              [<id>],;
              [<label>],;
              ,;
              [{<nWidth>,<nHeight>}],;
              [<style>],;
              [<name>],;
              [<onKey>],;
              [<onSelectCell>] ;
            )

#xcommand @ BROWSE [<bclauses,...>] SIZERINFO [<sizerClauses,...>] ;
          => ;
          @ BROWSE [<bclauses>] ;;
          @ SIZERINFO [<sizerClauses>]

/*
  BCOLUMN
*/
#xcommand ADD BCOLUMN [<zero: ZERO>] TO <wxBrw> [ [TITLE] <title>] BLOCK <block> [PICTURE <picture>] [WIDTH <width>] [AS <asBool: BOOL,NUMBER,FLOAT> [<width>,<precision>] ];
          => ;
          __wxh_BrowseAddColumn( <.zero.>, <wxBrw>, <title>, <{block}>, [<picture>], [<width>], [<"asBool">], [{<width>,<precision>}] )

/*
 * Button
 * Teo. Mexico 2009
 */
#xcommand @ BUTTON [<label>] ;
            [ VAR <btn> ] ;
            [ ON <window> ] ;
            [ ID <id> ] ;
            [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
            [ STYLE <style> ] ;
            [ VALIDATOR <validator> ] ;
            [ NAME <name> ] ;
            [ <default: DEFAULT> ] ;
            [ ACTION <bAction> ] ;
          => ;
          [ <btn> := ]__wxh_Button( ;
            [<window>],;
            [<id>],;
            [<label>],;
            ,;
            [{<nWidth>,<nHeight>}],;
            [<style>],;
            [<validator>],;
            [<name>],;
            [<.default.>],;
            [<{bAction}>] )

#xcommand @ BUTTON [<btnclauses,...>] SIZERINFO [<sizerClauses,...>] ;
          => ;
          @ BUTTON [<btnclauses>] ;;
          @ SIZERINFO [<sizerClauses>]

/*
 * CheckBox
 * Teo. Mexico 2009
 */
#xcommand @ CHECKBOX [<dataVar>] [ LABEL <label> ] ;
            [ VAR <checkBox> ] ;
            [ ON <window> ] ;
            [ ID <id> ] ;
            [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
            [ STYLE <style> ] ;
            [ VALIDATOR <validator> ] ;
            [ NAME <name> ] ;
            [ ACTION <bAction> ] ;
          => ;
          [ <checkBox> := ]__wxh_CheckBox( ;
            [<window>],;
            [<id>],;
            [<label>],;
            [ wxhGET():New( <"dataVar">, <dataVar>, {|__localVal| iif( PCount()>0, <dataVar> := __localVal, <dataVar> ) } ) ],;
            ,;
            [{<nWidth>,<nHeight>}],;
            [<style>],;
            [<validator>],;
            [<name>],;
            [<{bAction}>] )

#xcommand @ CHECKBOX [<btnclauses,...>] SIZERINFO [<sizerClauses,...>] ;
          => ;
          @ CHECKBOX [<btnclauses>] ;;
          @ SIZERINFO [<sizerClauses>]

/*
 * Gauge
 * Teo. Mexico 2009
 */
#xcommand @ GAUGE ;
            [ VAR <gauge> ] ;
            [ ON <window> ] ;
            [ ID <id> ] ;
            [ <type: HORIZONTAL, VERTICAL> ] ;
	    [ RANGE <range> ] ;
            [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
            [ STYLE <style> ] ;
            [ VALIDATOR <validator> ] ;
            [ NAME <name> ] ;
            [ ACTION <bAction> ] ;
          => ;
          [ <gauge> := ]__wxh_Gauge( ;
            [<window>],;
            [<id>],;
            [<range>],;
            ,;
            [{<nWidth>,<nHeight>}],;
            [<style>],;
            [<validator>],;
            [<name>],;
            [wxGA_<type>] )

#xcommand @ GAUGE [<gaugeClauses,...>] SIZERINFO [<sizerClauses,...>] ;
          => ;
          @ GAUGE [<gaugeClauses>] ;;
          @ SIZERINFO [<sizerClauses>]

/*
 * RadioBox
 * Teo. Mexico 2009
 */
#xcommand @ RADIOBOX <dataVar> [ LABEL <label> ] ;
            [ ITEMS <choices> ] ;
            [ MAJORDIM <majorDimension> ] ;
            [ VAR <radioBox> ] ;
            [ ON <parent> ] ;
            [ ID <id> ] ;
            [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
            [ STYLE <style> ] ;
            [ VALIDATOR <validator> ] ;
            [ NAME <name> ] ;
            [ ACTION <bAction> ] ;
          => ;
          [ <radioBox> := ]__wxh_RadioBox( ;
            [<parent>],;
            [<id>],;
            [<label>],;
            ,;
            [{<nWidth>,<nHeight>}],;
            [<choices>],;
            [<majorDimension>],;
            [<style>],;
            [<validator>],;
            [<name>],;
            wxhGET():New( <"dataVar">, <dataVar>, {|__localVal| iif( PCount()>0, <dataVar> := __localVal, <dataVar> ) } ),;
            [<{bAction}>] )

#xcommand @ RADIOBOX [<btnclauses,...>] SIZERINFO [<sizerClauses,...>] ;
          => ;
          @ RADIOBOX [<btnclauses>] ;;
          @ SIZERINFO [<sizerClauses>]

/*
 * Choice
 * Teo. Mexico 2009
 */
#xcommand @ CHOICE <dataVar> ;
            [ ITEMS <choices> ] ;
            [ VAR <choice> ] ;
            [ ON <parent> ] ;
            [ ID <id> ] ;
            [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
            [ STYLE <style> ] ;
            [ VALIDATOR <validator> ] ;
            [ NAME <name> ] ;
            [ ACTION <bAction> ] ;
          => ;
          [ <choice> := ]__wxh_Choice( ;
            [<parent>],;
            [<id>],;
            ,;
            [{<nWidth>,<nHeight>}],;
            [<choices>],;
            [<style>],;
            [<validator>],;
            [<name>],;
            wxhGET():New( <"dataVar">, <dataVar>, {|__localVal| iif( PCount()>0, <dataVar> := __localVal, <dataVar> ) } ),;
            [<{bAction}>] )

#xcommand @ CHOICE [<btnclauses,...>] SIZERINFO [<sizerClauses,...>] ;
          => ;
          @ CHOICE [<btnclauses>] ;;
          @ SIZERINFO [<sizerClauses>]

/*
 * ComboBox
 * Teo. Mexico 2009
 */
#xcommand @ COMBOBOX <dataVar> ;
            [ ITEMS <choices> ] ;
            [ VAR <comboBox> ] ;
            [ ON <parent> ] ;
            [ ID <id> ] ;
            [ VALUE <value> ] ;
            [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
            [ STYLE <style> ] ;
            [ VALIDATOR <validator> ] ;
            [ NAME <name> ] ;
            [ ACTION <bAction> ] ;
          => ;
          [ <comboBox> := ]__wxh_ComboBox( ;
            [<parent>],;
            [<id>],;
            [<value>],;
            ,;
            [{<nWidth>,<nHeight>}],;
            [<choices>],;
            [<style>],;
            [<validator>],;
            [<name>],;
            wxhGET():New( <"dataVar">, <dataVar>, {|__localVal| iif( PCount()>0, <dataVar> := __localVal, <dataVar> ) } ),;
            [<{bAction}>] )

#xcommand @ COMBOBOX [<cbclauses,...>] SIZERINFO [<sizerClauses,...>] ;
          => ;
          @ COMBOBOX [<cbclauses>] ;;
          @ SIZERINFO [<sizerClauses>]

/*
  wxGrid
*/
#xcommand @ GRID [ VAR <grid> ] ;
            [ ON <window> ] ;
            [ ID <id> ] ;
            [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
            [ STYLE <style> ] ;
            [ NAME <name> ] ;
            [ ROWS <rows> ] ;
            [ COLS <cols> ] ;
          => ;
            [<grid>:=]__wxh_Grid( ;
              [<window>],;
              [<id>],;
              ,;
              [{<nWidth>,<nHeight>}],;
              [<style>],;
              [<name>],;
              [ <rows> ],;
              [ <cols> ] )

#xcommand @ GRID [<bclauses,...>] SIZERINFO [<sizerClauses,...>] ;
          => ;
          @ GRID [<bclauses>] ;;
          @ SIZERINFO [<sizerClauses>]

/*
  Notebook|Listbook
*/
#xcommand BEGIN <bookType: NOTEBOOK, LISTBOOK, AUINOTEBOOK> ;
            [ VAR <nb> ] ;
            [ ON <parent> ] ;
            [ ID <id> ] ;
            [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
            [ STYLE <style> ] ;
            [ NAME <name> ] ;
          => ;
          [ <nb> := ]__wxh_BookBegin( wx<bookType>(), ;
            [<parent>],;
            [<id>],;
            ,;
            [{<nWidth>,<nHeight>}],;
            [<style>],;
            [<name>] )

#xcommand END <bookType: NOTEBOOK, LISTBOOK, AUINOTEBOOK> => __wxh_BookEnd( "wx"+<"bookType"> )

#xcommand BEGIN <bookType: NOTEBOOK, LISTBOOK, AUINOTEBOOK> [<nbclauses,...>] SIZERINFO [<sizerClauses,...>] ;
          => ;
          BEGIN <bookType> [<nbclauses>] ;;
          @ SIZERINFO [<sizerClauses>]

#xcommand ADD BOOKPAGE [ [TITLE] <title> ] [<select: SELECT> ] [ IMAGEID <imageId> ] FROM ;
          => ;
          __wxh_BookAddPage( <title>, <.select.>, <imageId> )

/*
  Panel
*/
#xcommand BEGIN PANEL ;
            [ VAR <panel> ] ;
            [ ON <window> ] ;
            [ ID <id> ] ;
            [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
            [ STYLE <style> ] ;
            [ NAME <name> ] ;
            [ ENABLED <bEnabled> ] ;
          => ;
          [ <panel> := ]__wxh_PanelBegin( ;
            [<window>],;
            [<id>],;
            ,;
            [{<nWidth>,<nHeight>}],;
            [<style>],;
            [<name>],;
            [<{bEnabled}>] )

#xcommand END PANEL => __wxh_PanelEnd()

#xcommand BEGIN PANEL [<clauses,...>] SIZERINFO [<sizerClauses,...>] ;
          => ;
          BEGIN PANEL [<clauses>] ;;
          @ SIZERINFO [<sizerClauses>]

/*
 * SAY ... GET
 */
#xcommand @ SAY <label> ;
            [ ON <window> ] ;
            [ ID <id> ] ;
            [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
            [ STYLE <style: LEFT, RIGHT, CENTRE, CENTER> ] ;
            [ NAME <name> ] ;
          => ;
          __wxh_Say( ;
            [<window>],;
            [<id>],;
            <label>,;
            ,;
            [{<nWidth>,<nHeight>}],;
            [wxALIGN_<style>],;
            [<name>] )

#xcommand @ SAY [<clauses,...>] SIZERINFO [<sizerClauses,...>] ;
          => ;
          @ SAY [<clauses>] ;;
          @ SIZERINFO [<sizerClauses>]

#xcommand @ GET <dataVar> ;
            [ VAR <var> ] ;
            [ ON <window> ] ;
            [ ID <id> ] ;
            [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
            [ <mline: MULTILINE> ] ;
            [ STYLE <style> ] ;
            [ VALIDATOR <validator> ] ;
            [ NAME <name> ] ;
            [ PICTURE <picture> ] ;
            [ WARNING [<warnMsg>] WHEN <warnWhen> ] ;
            [ TOOLTIP <toolTip> ] ;
            [ ACTION <bAction> ] ;
          => ;
          [<var> :=] __wxh_Get(;
            [<window>],;
            [<id>],;
            wxhGET():New( <"dataVar">, <dataVar>, {|__localVal| iif( PCount()>0, <dataVar> := __localVal, <dataVar> ) } ),;
            ,;
            [{<nWidth>,<nHeight>}],;
            [<.mline.>],;
            [<style>],;
            [<validator>],;
            [<name>],;
            [<picture>],;
            [{<{warnWhen}>,<warnMsg>}],;
            [<{toolTip}>],;
            [<{bAction}>] )

#xcommand @ GET [<clauses,...>] SIZERINFO [<sizerClauses,...>] ;
          => ;
          @ GET [<clauses>] ;;
          @ SIZERINFO [<sizerClauses>]

#xcommand @ SAY [<sayclauses,...>] GET [<getclauses,...>] ;
          => ;
          BEGIN BOXSIZER HORIZONTAL ALIGN EXPAND ;;
          @ SAY [<sayclauses>] STYLE RIGHT ;;
          @ GET [<getclauses>] SIZERINFO STRETCH ;;
          END SIZER

#xcommand @ SAY ABOVE [<sayclauses,...>] GET [<getclauses,...>] ;
          => ;
          BEGIN BOXSIZER VERTICAL ALIGN EXPAND ;;
          @ SAY [<sayclauses>] SIZERINFO ALIGN LEFT ;;
          @ GET [<getclauses>] SIZERINFO ALIGN EXPAND ;;
          END SIZER

#xcommand @ SAY [<sayclauses,...>] CHOICE [<choiceclauses,...>] ;
          => ;
          BEGIN BOXSIZER HORIZONTAL ALIGN EXPAND ;;
          @ SAY [<sayclauses>] STYLE RIGHT ;;
          @ CHOICE [<choiceclauses>] ;;
          END SIZER

/*
  ScrollBar
  Teo. Mexico 2009
*/
#xcommand @ SCROLLBAR <orient: HORIZONTAL, VERTICAL>;
            [ VAR <sb> ] ;
            [ ON <window> ] ;
            [ ID <id> ] ;
            [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
            [ STYLE <style> ] ;
            [ VALIDATOR <validator> ] ;
            [ NAME <name> ] ;
            [ ACTION <bAction> ] ;
          => ;
          [ <sb> := ]__wxh_ScrollBar( ;
            [<window>],;
            [<id>],;
            ,;
            [{<nWidth>,<nHeight>}],;
            [wxSB_<orient>],;
            [<style>],;
            [<validator>],;
            [<name>],;
            [<{bAction}>] )

#xcommand @ SCROLLBAR [<clauses,...>] SIZERINFO [<sizerClauses,...>] ;
          => ;
          @ SCROLLBAR [<clauses>] ;;
          @ SIZERINFO [<sizerClauses>]

/*
 * SpinCtrl
 * Teo. Mexico 2009
 */
#xcommand @ SPINCTRL [<value>] ;
            [ VAR <spinCtrl> ] ;
            [ ON <window> ] ;
            [ ID <id> ] ;
            [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
            [ STYLE <style> ] ;
            [ MIN <min> ] ;
            [ MAX <max> ] ;
            [ INITIAL <initial> ] ;
            [ NAME <name> ] ;
            [ ACTION <bAction> ] ;
          => ;
          [ <spinCtrl> := ]__wxh_SpinCtrl( ;
            [<window>],;
            [<id>],;
            [<value>],;
            ,;
            [{<nWidth>,<nHeight>}],;
            [<style>],;
            [<min>],;
            [<max>],;
            [<initial>],;
            [<name>],;
            [<{bAction}>] )

#xcommand @ SPINCTRL [<scclauses,...>] SIZERINFO [<sizerClauses,...>] ;
          => ;
          @ SPINCTRL [<scclauses>] ;;
          @ SIZERINFO [<sizerClauses>]

/*
  StaticLine
  Teo. Mexico 2009
*/
#xcommand @ STATICLINE <orient: HORIZONTAL, VERTICAL>;
            [ VAR <sl> ] ;
            [ ON <window> ] ;
            [ ID <id> ] ;
            [ NAME <name> ] ;
          => ;
          [ <sl> := ]__wxh_StaticLine( ;
            [<window>],;
            [<id>],;
            ,;
            [wxLI_<orient>],;
            [<name>])

#xcommand @ STATICLINE [<clauses,...>] SIZERINFO [<sizerClauses,...>] ;
          => ;
          @ STATICLINE [<clauses>] ;;
          @ SIZERINFO [<sizerClauses>]

/*
 * StaticText
 * Teo. Mexico 2009
 */
#xcommand @ STATICTEXT [<label>] ;
            [ VAR <staticText> ] ;
            [ ON <window> ] ;
            [ ID <id> ] ;
            [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
            [ STYLE <style> ] ;
            [ NAME <name> ] ;
          => ;
          [ <staticText> := ]__wxh_StaticText( ;
            [<window>],;
            [<id>],;
            [<label>],;
            ,;
            [{<nWidth>,<nHeight>}],;
            [<style>],;
            [<name>] )

#xcommand @ STATICTEXT [<stClauses,...>] SIZERINFO [<sizerClauses,...>] ;
          => ;
          @ STATICTEXT [<stClauses>] ;;
          @ SIZERINFO [<sizerClauses>]

/*
  StatusBar
*/
#xcommand @ STATUSBAR [ VAR <oSB> ] ;
            [ ID <nID> ] ;
            [ STYLE <nStyle> ] ;
            [ NAME <cName> ] ;
            [ FIELDS <nFields> ] ;
            [ WIDTHS <aWidths,...> ] ;
            [ ON <oFrame> ] ;
          => ;
          [ <oSB> := ] __wxh_StatusBar( ;
            [<oFrame>], ;
            [<nID>], ;
            [<nStyle>], ;
            [<cName>], ;
            [<nFields>], ;
            [{<aWidths>}] ) ;;

/*
 * TextCtrl
 * Teo. Mexico 2009
 */
#xcommand @ TEXTCTRL [<value>] ;
            [ VAR <textCtrl> ] ;
            [ ON <window> ] ;
            [ ID <id> ] ;
            [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
            [ STYLE <style> ] ;
            [ VALIDATOR <validator> ] ;
            [ NAME <name> ] ;
            [ <mline: MULTILINE> ] ;
            [ ACTION <bAction> ] ;
          => ;
          [ <textCtrl> := ]__wxh_TextCtrl( ;
            [<window>],;
            [<id>],;
            [<value>],;
            ,;
            [{<nWidth>,<nHeight>}],;
            [<style>],;
            [<validator>],;
            [<name>],;
            [<.mline.>],;
            [<{bAction}>] )

#xcommand @ TEXTCTRL [<tcclauses,...>] SIZERINFO [<sizerClauses,...>] ;
          => ;
          @ TEXTCTRL [<tcclauses>] ;;
          @ SIZERINFO [<sizerClauses>]

/*
 * TreeCtrl
 * Teo. Mexico 2009
 */
#xcommand @ TREECTRL [<label>] ;
            [ VAR <btn> ] ;
            [ ON <window> ] ;
            [ ID <id> ] ;
            [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
            [ STYLE <style> ] ;
            [ VALIDATOR <validator> ] ;
            [ NAME <name> ] ;
            [ ACTION <bAction> ] ;
          => ;
          [ <btn> := ]__wxh_TreeCtrl( ;
            [<window>],;
            [<id>],;
            [<label>],;
            ,;
            [{<nWidth>,<nHeight>}],;
            [<style>],;
            [<validator>],;
            [<name>],;
            [<{bAction}>] )

#xcommand @ TREECTRL [<clauses,...>] SIZERINFO [<sizerClauses,...>] ;
          => ;
          @ TREECTRL [<clauses>] ;;
          @ SIZERINFO [<sizerClauses>]
#endif
