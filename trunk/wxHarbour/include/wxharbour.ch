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

#include "hbclass.ch"
#include "property.ch"
#include "raddox.ch"
#include "wx.ch"

#include "wxh/textctrl.ch"

#define wxhLABEL_QUIT           "Quit"
#define wxhLABEL_RETRY          "Retry"
#define wxhLABEL_DEFAULT        "Default"

/* CheckBox 3 states */
#define wxCHK_UNCHECKED         0
#define wxCHK_CHECKED           1
#define wxCHK_UNDETERMINED      2

/*
  MessageBox
*/
#define wxhMessageBoxYesNo( title, mess, parent ) ;
        wxMessageBox( mess, title, HB_BITOR(wxYES_NO,wxICON_QUESTION), parent )

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
          => ;
          <oFrame> := wxh_Frame( [<"type">], [<fromClass>], [<oParent>], [<nID>], <cTitle>, {<nTop>,<nLeft>}, {<nWidth>,<nHeight>}, [<nStyle>], [<cName>] )

#xcommand CREATE DIALOG <oDlg> ;
          [ CLASS <fromClass> ] ;
          [ PARENT <oParent> ] ;
          [ ID <nID> ] ;
          [ TITLE <cTitle> ] ;
          [ FROM <nTop>, <nLeft> ] [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
          [ STYLE <nStyle> ] ;
          [ NAME <cName> ] ;
          => ;
          <oDlg> := wxh_Dialog( [<fromClass>], [<oParent>], [<nID>], <cTitle>, {<nTop>,<nLeft>}, {<nWidth>,<nHeight>}, [<nStyle>], [<cName>] )

#xcommand FIT WINDOW <oWnd> ;
          => ;
          iif( <oWnd>:GetSizer() != NIL, <oWnd>:GetSizer():SetSizeHints( <oWnd> ), NIL )

#xcommand CENTRE WINDOW <oWnd> ;
          => ;
          <oWnd>:Centre()

#xcommand SHOW WINDOW <oWnd> [<modal: MODAL>] [<fit: FIT>] [TO <var>] [<centre: CENTRE>];
          => ;
          [<var> := ] wxh_ShowWindow( <oWnd>, <.modal.>, <.fit.>, <.centre.> )

/*
  Menues
*/
#xcommand DEFINE MENUBAR [ VAR <oMB>] [STYLE <nStyle>] [ON <oWindow>] ;
          => ;
          [<oMB> := ] wxh_MenuBarBegin( [<oWindow>], [<nStyle>] )

#xcommand DEFINE MENU <cLabel> [VAR <menu>];
          => ;
          [<menu> :=] wxh_MenuBegin( <cLabel> )

#xcommand ADD MENUITEM <cLabel> ;
              [VAR <menu>] ;
              [ID <nID>] ;
              [HELPLINE <cHelpString>] ;
              [<kind: CHECK,RADIO>] ;
              [ACTION <bAction> ] ;
              [ENABLED <bEnabled> ] ;
          => ;
          [<menu> :=] wxh_MenuItemAdd( <cLabel>, [<nID>], [<cHelpString>], [wxITEM_<kind>], [<{bAction}>], [<{bEnabled}>] )

#xcommand ADD MENUSEPARATOR ;
          => ;
          wxh_MenuItemAdd( NIL, wxID_SEPARATOR )

#xcommand ENDMENU ;
          => ;
          wxh_MenuEnd()

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
          wxh_SizerInfoAdd( ;
            [ <child> ],;
            [ <parentSizer> ],;
            [ wx<stretch> ],;
            [ wxALIGN_<align> ],;
            [ <border> ],;
            [ HB_BITOR(0,<sideborders>) ],;
            NIL,;
            [ <.useLast.> ],;
            .T. ) /* No processing, sizer info to stack */

#xcommand BEGIN BOXSIZER <orient: VERTICAL, HORIZONTAL> ;
          [ VAR <bs> ] ;
          [ [LABEL] <label> ] ;
          [ <stretch: STRETCH> ] ;
          [ ALIGN <align: TOP, LEFT, BOTTOM, RIGHT, CENTRE, CENTRE_HORIZONTAL, CENTRE_VERTICAL, CENTER, CENTER_HORIZONTAL, CENTER_VERTICAL, EXPAND> ] ;
          [ BORDER <border> ] ;
          [ SIDEBORDERS <sideborders,...> ] ;
          => ;
          [ <bs> := ]wxh_BoxSizerBegin( ;
            [ <label> ], ;
            wx<orient>,;
            [ wx<stretch> ],;
            [ wxALIGN_<align> ],;
            [ <border> ],;
            [ HB_BITOR(0,<sideborders>) ] ;
          )

#xcommand BEGIN GRIDSIZER [ROWS <rows>] [COLS <cols>] [VGAP <vgap>] [HGAP <hgap>] ;
          [ <stretch: STRETCH> ] ;
          [ ALIGN <align: TOP, LEFT, BOTTOM, RIGHT, CENTRE, CENTRE_HORIZONTAL, CENTRE_VERTICAL, CENTER, CENTER_HORIZONTAL, CENTER_VERTICAL, EXPAND> ] ;
          [ BORDER <border> ] ;
          [ SIDEBORDERS <sideborders,...> ] ;
          => ;
          wxh_GridSizerBegin( ;
            [ <rows> ],;
            [ <cols> ],;
            [ <vgap> ],;
            [ <hgap> ],;
            [ wx<stretch> ],;
            [ wxALIGN_<align> ],;
            [ <border> ],;
            [ HB_BITOR(0,<sideborders>) ] ;
          )

#xcommand END SIZER ;
          => ;
          wxh_SizerEnd()


#xcommand @ SPACER ;
          [ WIDTH <width> ] ;
          [ HEIGHT <height> ] ;
          [ <stretch: STRETCH> ] ;
          [ FLAG <flag> ] ;
          [ BORDER <border> ] ;
          => ;
          wxh_Spacer( ;
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
            [<wxBrw>:=]wxh_Browse( ;
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

#xcommand @ BROWSE [<bclauses,...>] SIZERINFO [<wxsizerclauses,...>] ;
          => ;
          @ BROWSE [<bclauses>] ;;
          @ SIZERINFO [<wxsizerclauses>]

/*
  BCOLUMN
*/
#xcommand ADD BCOLUMN [<zero: ZERO>] TO <wxBrw> [ [TITLE] <title>] BLOCK <block> [PICTURE <picture>] [WIDTH <width>];
          => ;
          wxh_BrowseAddColumn( <.zero.>, <wxBrw>, <title>, <{block}>, [<picture>], [<width>] )

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
            [ ACTION <bAction> ] ;
          => ;
          [ <btn> := ]wxh_Button( ;
            [<window>],;
            [<id>],;
            [<label>],;
            ,;
            [{<nWidth>,<nHeight>}],;
            [<style>],;
            [<validator>],;
            [<name>],;
            [<{bAction}>] )

#xcommand @ BUTTON [<btnclauses,...>] SIZERINFO [<wxsizerclauses,...>] ;
          => ;
          @ BUTTON [<btnclauses>] ;;
          @ SIZERINFO [<wxsizerclauses>]

/*
 * CheckBox
 * Teo. Mexico 2009
 */
#xcommand @ CHECKBOX <dataVar> [ LABEL <label> ] ;
            [ VAR <checkBox> ] ;
            [ ON <window> ] ;
            [ ID <id> ] ;
            [ WIDTH <nWidth> ] [ HEIGHT <nHeight> ] ;
            [ STYLE <style> ] ;
            [ VALIDATOR <validator> ] ;
            [ NAME <name> ] ;
            [ ACTION <bAction> ] ;
          => ;
          [ <checkBox> := ]wxh_CheckBox( ;
            [<window>],;
            [<id>],;
            [<label>],;
            wxhGET():New( <"dataVar">, <dataVar>, {|__localVal| iif( PCount()>0, <dataVar> := __localVal, <dataVar> ) } ),;
            ,;
            [{<nWidth>,<nHeight>}],;
            [<style>],;
            [<validator>],;
            [<name>],;
            [<{bAction}>] )

#xcommand @ CHECKBOX [<btnclauses,...>] SIZERINFO [<wxsizerclauses,...>] ;
          => ;
          @ CHECKBOX [<btnclauses>] ;;
          @ SIZERINFO [<wxsizerclauses>]

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
          [ <radioBox> := ]wxh_RadioBox( ;
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

#xcommand @ RADIOBOX [<btnclauses,...>] SIZERINFO [<wxsizerclauses,...>] ;
          => ;
          @ RADIOBOX [<btnclauses>] ;;
          @ SIZERINFO [<wxsizerclauses>]

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
          [ <nb> := ]wxh_BookBegin( wx<bookType>() ;
            [<parent>],;
            [<id>],;
            ,;
            [{<nWidth>,<nHeight>}],;
            [<style>],;
            [<name>] )

#xcommand END <bookType: NOTEBOOK, LISTBOOK, AUINOTEBOOK> => wxh_BookEnd( "wx"+<"bookType"> )

#xcommand BEGIN <bookType: NOTEBOOK, LISTBOOK, AUINOTEBOOK> [<nbclauses,...>] SIZERINFO [<wxsizerclauses,...>] ;
          => ;
          BEGIN <bookType> [<nbclauses>] ;;
          @ SIZERINFO [<wxsizerclauses>]

#xcommand ADD BOOK PAGE [ [TITLE] <title> ] [ SELECT <select> ] [ IMAGEID <imageId> ] FROM ;
          => ;
          wxh_BookAddPage( <title>, <select>, <imageId> )

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
          => ;
          [ <panel> := ]wxh_PanelBegin( ;
            [<window>],;
            [<id>],;
            ,;
            [{<nWidth>,<nHeight>}],;
            [<style>],;
            [<name>] )

#xcommand END PANEL => wxh_PanelEnd()

#xcommand BEGIN PANEL [<clauses,...>] SIZERINFO [<wxsizerclauses,...>] ;
          => ;
          BEGIN PANEL [<clauses>] ;;
          @ SIZERINFO [<wxsizerclauses>]

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
          wxh_Say( ;
            [<window>],;
            [<id>],;
            <label>,;
            ,;
            [{<nWidth>,<nHeight>}],;
            [wxALIGN_<style>],;
            [<name>] )

#xcommand @ SAY [<clauses,...>] SIZERINFO [<wxsizerclauses,...>] ;
          => ;
          @ SAY [<clauses>] ;;
          @ SIZERINFO [<wxsizerclauses>]

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
            [ HELP <help> ] ;
            [ HELPLINE <helpLine> ] ;
            [ <refreshAll: REFRESH ALL> ] ;
          => ;
          [<var> :=] wxh_Get(;
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
            [<{help}>],;
            [<{helpLine}>],;
            [<.refreshAll.>] )

#xcommand @ GET [<clauses,...>] SIZERINFO [<wxsizerclauses,...>] ;
          => ;
          @ GET [<clauses>] ;;
          @ SIZERINFO [<wxsizerclauses>]

#xcommand @ SAY [<sayclauses,...>] GET [<getclauses,...>] ;
          => ;
          BEGIN BOXSIZER HORIZONTAL ALIGN EXPAND ;;
          @ SAY [<sayclauses>] STYLE RIGHT ;;
          @ GET [<getclauses>] ;;
          END SIZER

#xcommand @ SAY ABOVE [<sayclauses,...>] GET [<getclauses,...>] ;
          => ;
          BEGIN BOXSIZER VERTICAL ALIGN EXPAND ;;
          @ SAY [<sayclauses>] ;;
          @ GET [<getclauses>] ;;
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
          [ <sb> := ]wxh_ScrollBar( ;
            [<window>],;
            [<id>],;
            ,;
            [{<nWidth>,<nHeight>}],;
            [wxSB_<orient>],;
            [<style>],;
            [<validator>],;
            [<name>],;
            [<{bAction}>] )

#xcommand @ SCROLLBAR [<clauses,...>] SIZERINFO [<sizerclauses,...>] ;
          => ;
          @ SCROLLBAR [<clauses>] ;;
          @ SIZERINFO [<sizerclauses>]

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
          [ <sl> := ]wxh_StaticLine( ;
            [<window>],;
            [<id>],;
            ,;
            [wxLI_<orient>],;
            [<name>])

#xcommand @ STATICLINE [<clauses,...>] SIZERINFO [<sizerclauses,...>] ;
          => ;
          @ STATICLINE [<clauses>] ;;
          @ SIZERINFO [<sizerclauses>]

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
          [ <oSB> := ] wxh_StatusBar( ;
            [<oFrame>], ;
            [<nID>], ;
            [<nStyle>], ;
            [<cName>], ;
            [<nFields>], ;
            [{<aWidths>}] ) ;;

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
          [ <btn> := ]wxh_TreeCtrl( ;
            [<window>],;
            [<id>],;
            [<label>],;
            ,;
            [{<nWidth>,<nHeight>}],;
            [<style>],;
            [<validator>],;
            [<name>],;
            [<{bAction}>] )

#xcommand @ TREECTRL [<clauses,...>] SIZERINFO [<wxsizerclauses,...>] ;
          => ;
          @ TREECTRL [<clauses>] ;;
          @ SIZERINFO [<wxsizerclauses>]
#endif
