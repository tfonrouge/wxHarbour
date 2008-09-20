/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  wxFrame
  Teo. Mexico 2006
*/

#include "hbclass.ch"
#include "property.ch"

/*
  wx_Frame
  Teo. Mexico 2008
*/
FUNCTION wx_Frame( frameType, fromClass, oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
  LOCAL dlg

  IF Empty( fromClass )
    DO CASE
    CASE frameType == "MDIPARENT"
      RETURN wxMDIParentFrame():New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
    CASE frameType == "MDICHILD"
      RETURN wxMDIChildFrame():New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
    OTHERWISE
      RETURN wxFrame():New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )
    ENDCASE
  ENDIF

  dlg := __ClsInstFromName( fromClass ):New( oParent, nID, cTitle, nTopnLeft, nHeightnWidth, nStyle, cName )

  DO CASE
  CASE frameType == "MDIPARENT"
    IF !dlg:IsDerivedFrom( "wxMDIParentFrame" )
      dlg:IsNotDerivedFrom_wxMDIParentFrame()
    ENDIF
  CASE frameType == "MDICHILD"
    IF !dlg:IsDerivedFrom( "wxMDIChildFrame" )
      dlg:IsNotDerivedFrom_wxMDIChildFrame()
    ENDIF
  OTHERWISE
    IF !dlg:IsDerivedFrom( "wxFrame" )
      dlg:IsNotDerivedFrom_wxFrame()
    ENDIF
  ENDCASE

RETURN dlg

/*
  wxh_ShowWindow : shows wxFrame/wxDialog
  Teo. Mexico 2008
*/
FUNCTION wxh_ShowWindow( oWnd, modal, fit, centre )
  LOCAL Result

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
  wxFrame
  Teo. Mexico 2006
*/
CLASS wxFrame FROM wxTopLevelWindow
PRIVATE:
PROTECTED:
PUBLIC:
  CONSTRUCTOR New( parent, id, title, pos, size, style, name )
  METHOD Centre( direction )
  METHOD SetMenuBar( menuBar )
  METHOD SetStatusBar( statusBar )
  METHOD OnCreate
  METHOD OnShow
PUBLISHED:
ENDCLASS

/*
  OnCreate
  Teo. Mexico 2006
*/
METHOD PROCEDURE OnCreate CLASS wxFrame
RETURN

/*
  OnShow
  Teo. Mexico 2006
*/
METHOD PROCEDURE OnShow CLASS wxFrame
  ? "OnShow..."
  ?
RETURN

/*
  End Class wxFrame
*/

/*
  wxMDIParentFrame
  Teo. Mexico 2008
*/
CLASS wxMDIParentFrame FROM wxFrame
PRIVATE:
PROTECTED:
PUBLIC:
  CONSTRUCTOR New( parent, id, title, pos, size, style, name )
  METHOD Cascade
PUBLISHED:
ENDCLASS

/*
  End Class wxMDIParentFrame
*/

/*
  wxMDIChildFrame
  Teo. Mexico 2008
*/
CLASS wxMDIChildFrame FROM wxFrame
PRIVATE:
PROTECTED:
PUBLIC:
  CONSTRUCTOR New( parent, id, title, pos, size, style, name )
  METHOD Activate
  METHOD Maximize( maximize )
  METHOD Restore
PUBLISHED:
ENDCLASS

/*
  End Class wxMDIParentFrame
*/