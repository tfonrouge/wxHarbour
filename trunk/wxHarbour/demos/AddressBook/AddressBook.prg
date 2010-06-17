/*
    $Id$
    Address book; test for RADO
*/

#include "wxharbour.ch"

#include "AddressBook.ch"

#ifdef _DEBUG_
#ifdef HB_OS_UNIX
	REQUEST HB_GT_XWC_DEFAULT
#endif
#ifdef HB_OS_WINDOWS
	REQUEST HB_GT_WVT_DEFAULT
#endif
#else
	REQUEST HB_GT_NUL_DEFAULT
#endif

REQUEST DBFCDX

FUNCTION Main()

#ifdef _DEBUG_
    SetMode( 40, 100 )
#endif

    RddSetDefault( "DBFCDX" )

    IMPLEMENT_APP( myApp():New() )

RETURN NIL

/*
    myApp: wxApp descendand class
*/
CLASS myApp FROM wxApp
PRIVATE:
PROTECTED:

    DATA frame
    DATA tbl_Name

    METHOD DefineDetailView()
    METHOD DefineToolbar()
    METHOD Version() INLINE "v0.1"

PUBLIC:

    DATA brw

    METHOD OnInit()

PUBLISHED:
ENDCLASS

/*
    OnInit
*/
METHOD FUNCTION OnInit() CLASS myApp

    ::tbl_Name := Tbl_Name():New()

    CREATE FRAME ::frame ;
        TITLE "Address Book " + ::Version() ;
        WIDTH 600 HEIGHT 400

    ::DefineToolbar()

    BEGIN NOTEBOOK VAR ::tbl_Name:noteBook ON PAGE CHANGING {|notebookEvt| ::tbl_Name:OnNotebookPageChanging( notebookEvt ) } ON PAGE CHANGED {|notebookEvt| ::tbl_Name:OnNotebookPageChanged( notebookEvt ) }

        ADD BOOKPAGE "List" FROM
            BEGIN PANEL

                BEGIN BOXSIZER VERTICAL

                    @ BROWSE VAR ::brw DATASOURCE ::tbl_Name CLASS "TBaseBrowse" ;
                        SIZERINFO ALIGN EXPAND STRETCH

                END SIZER

            END PANEL

        ADD BOOKPAGE "Detail" FROM
            ::DefineDetailView()

    END NOTEBOOK

    SHOW WINDOW ::frame FIT CENTRE

RETURN .T.

/*
    DefineDetailView
*/
METHOD PROCEDURE DefineDetailView() CLASS myApp
    
    BEGIN PANEL
        BEGIN FLEXGRIDSIZER COLS 2 GROWABLECOLS 2

            @ SAY ::tbl_Name:Field_RecId:Label SIZERINFO ALIGN RIGHT
                @ GET ::tbl_Name:Field_RecId SIZERINFO ALIGN LEFT

            @ SAY ::tbl_Name:Field_DoB:Label SIZERINFO ALIGN RIGHT
                @ DATEPICKERCTRL ::tbl_Name:Field_DoB SIZERINFO ALIGN LEFT

            @ SAY ::tbl_Name:Field_Genre:Label SIZERINFO ALIGN RIGHT
                @ CHOICE ::tbl_Name:Field_Genre SIZERINFO ALIGN LEFT

            @ SAY ::tbl_Name:Field_FName:Label SIZERINFO ALIGN RIGHT
                @ GET ::tbl_Name:Field_FName SIZERINFO ALIGN EXPAND

            @ SAY ::tbl_Name:Field_LName:Label SIZERINFO ALIGN RIGHT
                @ GET ::tbl_Name:Field_LName SIZERINFO ALIGN EXPAND

        END SIZER
    END PANEL

RETURN

/*
    DefineToolbar
*/
METHOD PROCEDURE DefineToolbar() CLASS myApp
    LOCAL idBase

    idBase := ::tbl_Name:ClassH * 100

    BEGIN FRAME TOOLBAR //STYLE HB_BitOr( wxTB_HORIZONTAL, wxNO_BORDER ) SIZERINFO ALIGN RIGHT BORDER 0

        @ TOOL BUTTON ID idBase + abID_DB_INSERT LABEL "Add" SHORTHELP "Agrega " BITMAP "png/application_add.png" ;
            ACTION {|| ::tbl_Name:TryInsert() } ;
            ENABLED {|| ::tbl_Name:CanInsert() }

        @ TOOL BUTTON ID idBase + abID_DB_EDIT LABEL "Edit" SHORTHELP "Modifica " BITMAP "png/application_edit.png" ;
            ACTION {|| ::tbl_Name:TryEdit() } ;
            ENABLED {|| ::tbl_Name:CanEdit() }

        @ TOOL BUTTON ID idBase + abID_DB_DELETE LABEL "Remove" SHORTHELP "Elimina " BITMAP "png/application_remove.png" ;
            ACTION {|| ::tbl_Name:TryDelete( .T. ) } ;
            ENABLED {|| ::tbl_Name:CanDelete() }

        @ TOOL SEPARATOR

        @ TOOL BUTTON ID idBase + abID_DB_POST LABEL "Post" SHORTHELP "Escribe a base de datos"  BITMAP "png/accept.png" ;
            ACTION {|| ::tbl_Name:TryPost() } ;
            ENABLED {|| ::tbl_Name:CanPost() }

        @ TOOL BUTTON ID idBase + abID_DB_CANCEL LABEL "Cancel" SHORTHELP "Cancela cambios"  BITMAP "png/remove.png" ;
            ACTION {|| ::tbl_Name:Cancel() } ;
            ENABLED {|| ::tbl_Name:CanCancel() }

        @ TOOL SEPARATOR

        @ TOOL BUTTON ID idBase + abID_GOTOP LABEL "Top" SHORTHELP "Mueve hacia primer registro" BITMAP "png/skip_backward.png" ;
            ACTION {|| ::brw:GoTop() } ;
            ENABLED {|| ::tbl_Name:CanMove( abID_UP ) }

        @ TOOL BUTTON ID idBase + abID_GOPGUP LABEL "PgUp" SHORTHELP "Mueve una pagina hacia arriba" BITMAP "png/page_previous.png" ;
            ACTION {|| ::brw:PageUp() } ;
            ENABLED {|| ::tbl_Name:CanMove( abID_UP ) }

        @ TOOL BUTTON ID idBase + abID_GOUP LABEL "Up" SHORTHELP "Mueve un registro hacia arriba" BITMAP "png/back.png" ;
            ACTION {|| ::brw:Up() } ;
            ENABLED {|| ::tbl_Name:CanMove( abID_UP ) }

        @ TOOL BUTTON ID idBase + abID_GODOWN LABEL "Down" SHORTHELP "Mueve un registro hacia abajo" BITMAP "png/next.png" ;
            ACTION {|| ::brw:Down() } ;
            ENABLED {|| ::tbl_Name:CanMove( abID_DOWN ) }

        @ TOOL BUTTON ID idBase + abID_GOPGDOWN LABEL "PgDn" SHORTHELP "Mueve una pagina hacia abajo" BITMAP "png/page_next.png" ;
            ACTION {|| ::brw:PageDown() } ;
            ENABLED {|| ::tbl_Name:CanMove( abID_DOWN ) }

        @ TOOL BUTTON ID idBase + abID_GOBOTTOM LABEL "Bottom" SHORTHELP "Mueve hacia ultimo registro" BITMAP "png/skip_forward.png" ;
            ACTION {|| ::brw:GoBottom() } ;
            ENABLED {|| ::tbl_Name:CanMove( abID_DOWN ) }

        @ TOOL BUTTON ID idBase + abID_REFRESH LABEL "Refresh" SHORTHELP "Refresh List data" BITMAP "png/refresh.png" ;
            ACTION {|| ::brw:RefreshAll() } ;
            ENABLED {|| ::tbl_Name:CanMove( abID_NONE ) }
        
    END TOOLBAR

RETURN
