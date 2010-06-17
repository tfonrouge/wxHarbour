/*
    $Id$
    Tbl_Name : Table to contain names
*/

#include "wxharbour.ch"

#include "AddressBook.ch"

CLASS Tbl_Name FROM TTable
PRIVATE:
PROTECTED:
    METHOD InitDataBase INLINE MyDataBase():New()
PUBLIC:

    DATA noteBook

    PROPERTY AutoCreate DEFAULT .T.
	PROPERTY TableFileName DEFAULT "names"
    
    CALCFIELD Age()
    CALCFIELD FullName()

    DEFINE FIELDS
    DEFINE INDEXES
    
    METHOD CanCancel() INLINE AScan( { dsEdit, dsInsert }, ::State ) > 0
    METHOD CanDelete() INLINE ! ::Eof() .AND. ::State = dsBrowse
    METHOD CanEdit() INLINE ! ::Eof() .AND. ::State = dsBrowse
    METHOD CanInsert() INLINE ::State = dsBrowse
    METHOD CanMove( direction )
    METHOD CanPost() INLINE AScan( { dsEdit, dsInsert }, ::State ) > 0
    
    METHOD OnAfterOpen()
    METHOD OnDataChange()
    METHOD OnNotebookPageChanged( notebookEvt )
    METHOD OnNotebookPageChanging( notebookEvt )
    
    METHOD TryDelete()
    METHOD TryEdit()
    METHOD TryInsert()
    METHOD TryPost()

PUBLISHED:
ENDCLASS

/*
	FIELDS
*/
BEGIN FIELDS CLASS Tbl_Name

    ADD INTEGER FIELD "RecId" ;
        //PRIVATE

    ADD STRING FIELD "FName" SIZE 40 ;
        REQUIRED ;
        LABEL "First Name" 

    ADD STRING FIELD "LName" SIZE 40 ;
        REQUIRED ;
        LABEL "Last Name"
    
    ADD STRING FIELD "Genre" SIZE 1 ;
        VALIDVALUES {"F"=>"Female","M"=>"Male"}

    ADD DATETIME FIELD "DoB" ;
        REQUIRED ;
        LABEL "Day of birth"
        
    ADD MEMO FIELD "Memo"
        
    /* Calculated Field's */
    ADD CALCULATED STRING FIELD "FullName" SIZE 81 ;
        LABEL "Full Name"
        
    ADD CALCULATED FLOAT FIELD "Age"

END FIELDS CLASS

/*
	INDEXES
*/
BEGIN INDEXES CLASS Tbl_Name
	DEFINE PRIMARY INDEX "Primary" KEYFIELD "RecId" AUTOINCREMENT
    DEFINE SECONDARY INDEX "Name" KEYFIELD {"FName","LName"} UNIQUE
    DEFINE SECONDARY INDEX "DoB" KEYFIELD "DoB"
END INDEXES CLASS

/*
    CalcField_Age
*/
CALCFIELD Age() CLASS Tbl_Name
RETURN ( Date() - ::Field_DoB:Value ) / 365.25

/*
    CalcField_FullName
*/
CALCFIELD FullName() CLASS Tbl_Name
RETURN RTrim( ::Field_FName:Value ) + " " + RTrim( ::Field_LName:Value )

/*
	CanMove
*/
METHOD FUNCTION CanMove( direction ) CLASS Tbl_Name
	LOCAL Result := .F.
	
	SWITCH direction
	CASE abID_UP
		Result := !::Bof()
		EXIT
	CASE abID_DOWN
		Result := !::Eof()
		EXIT
	CASE abID_NONE
		Result := .T.
		EXIT
	ENDSWITCH

RETURN Result .AND. ::State = dsBrowse

/*
    OnAfterOpen
*/
METHOD PROCEDURE OnAfterOpen() CLASS Tbl_Name
    ::IndexName := "Name"
RETURN

/*
	OnDataChange
*/
METHOD PROCEDURE OnDataChange() CLASS Tbl_Name

	IF ::noteBook != NIL
		IF ::noteBook:GetSelection() = 2
			::noteBook:GetCurrentPage():TransferDataToWindow()
		ENDIF
	ENDIF
	
	Super:OnDataChange()

RETURN

/*
	OnNotebookPageChanged
*/
METHOD PROCEDURE OnNotebookPageChanged( notebookEvt ) CLASS Tbl_Name

    IF notebookEvt:IsAllowed()

        SWITCH notebookEvt:GetSelection()
        CASE 1
            IF wxGetApp():brw != NIL
                wxGetApp():brw:RefreshAll()
            END
            EXIT
        CASE 2
            ::noteBook:GetPage( 2 ):TransferDataToWindow()
            EXIT
        ENDSWITCH

    ENDIF

    notebookEvt:Skip()

RETURN

/*
	OnNotebookPageChanging
*/
METHOD PROCEDURE OnNotebookPageChanging( notebookEvt ) CLASS Tbl_Name

	IF notebookEvt:IsAllowed()

		SWITCH notebookEvt:GetOldSelection()
		CASE 2

			IF AScan( { dsEdit, dsInsert }, ::State ) > 0
				IF !::Validate( .T. )
					notebookEvt:Veto()
					RETURN
				ENDIF
				::TryPost()
			ENDIF
			EXIT
		ENDSWITCH

	ENDIF
    
    notebookEvt:Skip()

RETURN

/*
    TryDelete
*/
METHOD FUNCTION TryDelete() CLASS Tbl_Name
RETURN ::Delete()

/*
	TryEdit
*/
METHOD FUNCTION TryEdit() CLASS Tbl_Name

	IF ::Edit()
		IF ::noteBook != NIL
			::noteBook:SetSelection( 2 )
			::noteBook:GetPage( 2 ):TransferDataToWindow()
		ENDIF
		RETURN .T.
	ENDIF

RETURN .F.

/*
	TryInsert
*/
METHOD FUNCTION TryInsert() CLASS Tbl_Name

	IF ::Insert()
		IF ::noteBook != NIL
			::noteBook:SetSelection( 2 )
			::noteBook:GetPage( 2 ):TransferDataToWindow()
		ENDIF
		RETURN .T.
	ENDIF

RETURN .F.

/*
    TryPost
*/
METHOD FUNCTION TryPost() CLASS Tbl_Name
RETURN ::Post()
