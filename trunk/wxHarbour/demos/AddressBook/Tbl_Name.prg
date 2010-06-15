/*
    $Id$
    Tbl_Name : Table to contain names
*/

#include "wxharbour.ch"

CLASS Tbl_Name FROM TTable
PRIVATE:
PROTECTED:
    METHOD InitDataBase INLINE MyDataBase():New()
PUBLIC:

    PROPERTY AutoCreate DEFAULT .T.
	PROPERTY TableFileName DEFAULT "names"
    
    CALCFIELD FullName()

    DEFINE FIELDS
    DEFINE INDEXES

PUBLISHED:
ENDCLASS

/*
	FIELDS
*/
BEGIN FIELDS CLASS Tbl_Name

    ADD INTEGER FIELD "RecId" ;
        PRIVATE

    ADD STRING FIELD "FName" SIZE 40 ;
        LABEL "First Name"

    ADD STRING FIELD "LName" SIZE 40 ;
        LABEL "Last Name"
    
    ADD STRING FIELD "Genre" SIZE 1 ;
        VALIDVALUES {"F"=>"Female","M"=>"Male"}

    ADD DATETIME FIELD "DoB" ;
        LABEL "Day of birth"
        
    /* Calculated Field's */
    ADD CALCULATED STRING FIELD "FullName" SIZE 81 ;
        LABEL "Full Name"

END FIELDS CLASS

/*
	INDEXES
*/
BEGIN INDEXES CLASS Tbl_Name
	DEFINE PRIMARY INDEX "Primary" KEYFIELD "RecId" AUTOINCREMENT
    DEFINE SECONDARY INDEX "Name" KEYFIELD {"FName","LName"}
END INDEXES CLASS

/*
    CalcField_FullName
*/
CALCFIELD FullName() CLASS Tbl_Name
RETURN RTrim( ::Field_FName:Value ) + " " + RTrim( ::Field_LName:Value )
