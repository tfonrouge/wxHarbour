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

    BEGIN PANEL

        BEGIN BOXSIZER VERTICAL

            @ BROWSE VAR ::brw DATASOURCE ::tbl_Name ;
                SIZERINFO ALIGN EXPAND STRETCH

        END SIZER

    END PANEL

//    ::brw:FillColumns()
//    ::brw:AutoSizeColumns( .F. )

    SHOW WINDOW ::frame FIT CENTRE

RETURN .T.
