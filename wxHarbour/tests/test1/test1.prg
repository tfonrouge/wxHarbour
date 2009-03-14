/*
  (C) 2008 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  menu sample
  Teo. Mexico 2009
*/

#include "hbclass.ch"
#include "wxharbour.ch"

/*
  Main
  Teo. Mexico 2009
*/
FUNCTION Main()
  LOCAL MyApp

  MyApp := MyApp():New()

  IMPLEMENT_APP( MyApp )

RETURN NIL

/*
  MyApp
  Teo. Mexico 2009
*/
CLASS MyApp FROM wxApp
PRIVATE:
  DATA oWnd
PROTECTED:
PUBLIC:
  DATA grid, gridTableBase
  METHOD OnInit
PUBLISHED:
ENDCLASS

/*
  EndClass MyApp
*/

/*
  OnInit
  Teo. Mexico 2009
*/
METHOD FUNCTION OnInit() CLASS MyApp
//   LOCAL menuBar
//   LOCAL menu
//   LOCAL sb

  CREATE FRAME ::oWnd ;
         WIDTH 800 HEIGHT 600 ;
         TITLE "Menu Sample"

  DEFINE MENUBAR
    DEFINE MENU "Pro&grama"
      ADD MENUITEM "Configuracion de Arel" ENABLED .F.
      ADD MENUITEM "Seguridad " ENABLED .F.
      ADD MENUSEPARATOR
      ADD MENUITEM "Impresoras disponibles" ENABLED .F.
      ADD MENUSEPARATOR
      ADD MENUITEM E"Salir \tAlt+X" ID wxID_EXIT ACTION ::oWnd:Close() ;
          HELPLINE "Termina la sesión de Arel..."
    ENDMENU
    DEFINE MENU "&Administración"
      DEFINE MENU "Inventario"
        ADD MENUITEM "Catálogo General de Inventario" ACTION ::AX_Show_Inventario()
      ENDMENU
      ADD MENUITEM "Almacén" ENABLED .F.
      ADD MENUITEM "Compras" ENABLED .F.
      ADD MENUITEM "Ventas" ENABLED .F.
      ADD MENUSEPARATOR
      ADD MENUITEM "Cuentas por Pagar" ENABLED .F.
      ADD MENUITEM "Cuentas por Cobrar" ENABLED .F.
      ADD MENUSEPARATOR
    ENDMENU
    DEFINE MENU E"&Producción"
      ADD MENUITEM "Ordenes de Producción" //ACTION Produccion()
      ADD MENUITEM "Productos" //ACTION Productos()
      ADD MENUITEM "Componentes" //ACTION Componentes()
      DEFINE MENU "Configuración"
        ADD MENUITEM "Operaciones de Producción" ACTION ::AX_Show_OperacionesProduccion()
        ADD MENUITEM "Maquinaria y Equipo" ACTION ::AX_Show_MaquinariaYEquipo()
        ADD MENUITEM "Recursos Humanos" ACTION ::AX_Show_RecursoHumano()
      ENDMENU
    ENDMENU
    DEFINE MENU "Help"
      ADD MENUITEM "About..." ACTION wxMessageBox( "ArelX: Prototipo funcional de Produccion v0.1", "About", wxICON_INFORMATION, ::oWnd )
    ENDMENU
  ENDMENU

  BEGIN BOXSIZER VERTICAL
    @ BUTTON "Hola"
  END SIZER

  @ STATUSBAR

  //SHOW WINDOW ::oWnd FIT CENTRE

//   menuBar := wxMenubar():New()
//   menu := wxMenu():New()
//
//   menu:Append( wxID_CLOSE, "Opcion 1" )
//   menu:Append( wxID_CLOSE, "Opcion 2" )
//
//   menuBar:Append( menu, "Archivo" )
//
//   ::oWnd:SetMenuBar( menuBar )

//   sb := wxStatusBar():New( ::oWnd )

//   ::oWnd:SetStatusBar( sb )

//   ::grid := wxhGridBrowse():New( ::oWnd, wxID_ANY, NIL, NIL, NIL, "wxhGridBrowse" )
//   ::gridTableBase := wxhBrowseTableBase():New( ::oWnd )
//   ::grid:SetTable( ::gridTableBase, .T. )
//
//   ? "***", ::grid:GetTable():ClassName(), "==", ::gridTableBase:ClassName()

  SHOW WINDOW ::oWnd CENTRE

RETURN .T.

/*
  Open a new Dialog MODAL
*/
STATIC PROCEDURE Open( parentWnd )
  LOCAL oDlg
  parentWnd := NIL

  CREATE DIALOG oDlg ;
         PARENT parentWnd

//   BEGIN BOXSIZER VERTICAL
    @ BUTTON "Cerrar" ID wxID_CLOSE
//   END SIZER

//   wxButton():New( oDlg, wxID_ANY, "CloseT" )

  SHOW WINDOW oDlg MODAL

RETURN
