/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxHarbour.ch
  Teo. Mexico 2006
*/

#xcommand CREATE FRAME <oFrame> ;
          [ PARENT <oParent> ] ;
          [ ID <nID> ] ;
          [ TITLE <cTitle> ] ;
          [ FROM <nTop>, <nLeft> SIZE <nHeight>, <nWidth> ] ;
          [ STYLE <nStyle> ] ;
          [ NAME <cName> ] ;
          => ;
          <oFrame> := wxFrame():New( [<oParent>], [<nID>], <cTitle>, {<nTop>,<nLeft>}, {<nHeight>,<nWidth>}, [<nStyle>], [<cName>] )

#xcommand CREATE DIALOG <oDlg> ;
          [ PARENT <oParent> ] ;
          [ ID <nID> ] ;
          [ TITLE <cTitle> ] ;
          [ FROM <nTop>, <nLeft> SIZE <nHeight>, <nWidth> ] ;
          [ STYLE <nStyle> ] ;
          [ NAME <cName> ] ;
          => ;
          <oDlg> := wxDialog():New( [<oParent>], [<nID>], <cTitle>, {<nTop>,<nLeft>}, {<nHeight>,<nWidth>}, [<nStyle>], [<cName>] )


#xcommand CREATE STATUSBAR [<oSB>] ;
          [ ID <nID> ] ;
          [ STYLE <nStyle> ] ;
          [ NAME <cName> ] ;
          [ FIELDS <nFields> ] ;
          [ WIDTHS <aWidths,...> ] ;
          ON <oFrame> ;
          => ;
          [<oSB> := ] DefineStatusBar( <oFrame>, [<nID>], [<nStyle>], [<cName>], [<nFields>], [{<aWidths>}] ) ;;

#xcommand DEFINE MENUBAR [<oMB>] [STYLE <nStyle>] ON <oWindow> ;
          => ;
          [<oMB> := ] DefineMenuBar( <oWindow>, [<nStyle>] )

#xcommand DEFINE MENU <cLabel> ;
          => ;
          DefineMenu( <cLabel> )

#xcommand ADD MENUITEM <cLabel> ;
              [ID <nID>] ;
              [HELPLINE <cHelpString>] ;
              [<kind: CHECK,RADIO>] ;
              [ACTION <bAction> ] ;
          => ;
          AddMenuItem( <cLabel>, [<nID>], [<cHelpString>], [wxITEM_<kind>], [<{bAction}>] )

#xcommand ADD SEPARATOR ;
          => ;
          AddMenuItem( NIL, wxID_SEPARATOR )

#xcommand ENDMENU ;
          => ;
          EndMenu()

#xcommand ENDMENUBAR ;
          => ;
          EndMenuBar()

/*
  Button
  Teo. Mexico 2006
*/

#xcommand BUTTON => ;
          wxButton():New( )










