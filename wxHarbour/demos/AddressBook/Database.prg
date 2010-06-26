/*
    $Id$
    MyDataBase
*/

#include "wxharbour.ch"

CLASS MyDataBase FROM TDataBase
PRIVATE:
PROTECTED:
    METHOD DefineRelations()
PUBLIC:
    CONSTRUCTOR New()
    PROPERTY Directory DEFAULT "data"
PUBLISHED:
ENDCLASS

/*
    New
*/
METHOD New() CLASS MyDataBase

    IF !HB_DirExists( ::Directory )
        MakeDir( ::Directory )
    ENDIF

RETURN Self

/*
    DefineRelations
*/
METHOD PROCEDURE DefineRelations() CLASS MyDataBase
RETURN
