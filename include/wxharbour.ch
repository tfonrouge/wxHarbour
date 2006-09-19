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
          [ FROM <nTop>, <nLeft> SIZE <nHeight>, <nWidth> ] ;
          [ STYLE <nStyle> ] ;
          [ NAME <cName> ] ;
          [ TITLE <cTitle> ] ;
          [ ID <nID> ] ;
          [ PARENT <oParent> ] ;
          => ;
          <oFrame> := wxFrame():New( [<oParent>], [<nID>], <cTitle>, {<nTop>,<nLeft>}, {<nHeight>,<nWidth>}, [<nStyle>], [<cName>] )

#xcommand CREATE DIALOG <oDlg> ;
          [ FROM <nTop>, <nLeft> SIZE <nHeight>, <nWidth> ] ;
          [ STYLE <nStyle> ] ;
          [ NAME <cName> ] ;
          [ TITLE <cTitle> ] ;
          [ ID <nID> ] ;
          [ PARENT <oParent> ] ;
          => ;
          <oDlg> := wxDialog():New( [<oParent>], [<nID>], <cTitle>, {<nTop>,<nLeft>}, {<nHeight>,<nWidth>}, [<nStyle>], [<cName>] )


#xcommand CREATE STATUSBAR [<oSB>] ;
          [ON <oFrame>] ;
          [ ID <nID> ] ;
          [ STYLE <nStyle> ] ;
          [ NAME <cName> ] ;
          [ FIELDS <nFields> ] ;
          [ WIDTHS <aWidths,...> ] ;
          => ;
          [<oSB> := ] DefineStatusBar( <oFrame>, [<nID>], [<nStyle>], [<cName>], [<nFields>], [{<aWidths>}] ) ;;

#xcommand CREATE MENUBAR [<oMB>] [STYLE <nStyle>] ;
          => ;
          [<oMB> := ] DefineMenuBar( [<nStyle>] )

#xcommand CREATE MENU <cLabel> ;
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










