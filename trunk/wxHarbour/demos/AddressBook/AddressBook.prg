/*
    $Id$
    Address book; test for RADO
*/

#include "wxharbour.ch"

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

    DATA brw
    DATA frame
    DATA tbl_Name

    METHOD DefineDetailView()
    METHOD Version() INLINE "v0.1"

PUBLIC:
    METHOD OnInit()
PUBLISHED:
ENDCLASS

/*
    OnInit
*/
METHOD FUNCTION OnInit() CLASS myApp

    ::tbl_Name := Tbl_Name():New()

    CREATE FRAME ::frame ;
        TITLE "Address Book " + ::Version()

    BEGIN NOTEBOOK

        ADD BOOKPAGE "List" FROM
            BEGIN PANEL

                BEGIN BOXSIZER VERTICAL

                    @ BROWSE VAR ::brw DATASOURCE ::tbl_Name ;
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
