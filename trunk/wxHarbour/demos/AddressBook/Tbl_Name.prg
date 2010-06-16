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
    
    CALCFIELD FullName()

    DEFINE FIELDS
    DEFINE INDEXES
    
    METHOD CanCancel() INLINE AScan( { dsEdit, dsInsert }, ::State ) > 0
    METHOD CanDelete() INLINE ! ::Eof() .AND. ::State = dsBrowse
    METHOD CanEdit() INLINE ! ::Eof() .AND. ::State = dsBrowse
    METHOD CanInsert() INLINE ::State = dsBrowse
    METHOD CanMove( direction )
    METHOD CanPost() INLINE AScan( { dsEdit, dsInsert }, ::State ) > 0
    
    METHOD OnDataChange()
    METHOD OnNotebookPageChanging( notebookEvt )
    
    METHOD TryDelete() INLINE ::Delete()
    METHOD TryEdit()
    METHOD TryInsert()
    METHOD TryPost() INLINE ::Post()

PUBLISHED:
ENDCLASS

/*
	FIELDS
*/
BEGIN FIELDS CLASS Tbl_Name

    ADD INTEGER FIELD "RecId" ;
        PRIVATE

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
	OnNotebookPageChanging
*/
METHOD PROCEDURE OnNotebookPageChanging( notebookEvt ) CLASS Tbl_Name
	LOCAL oldSelection
	LOCAL selecting
	
	IF notebookEvt:IsAllowed()
	
		oldSelection := notebookEvt:GetOldSelection()
		
		SWITCH oldSelection
		CASE 2

			IF AScan( { dsEdit, dsInsert }, ::State ) > 0
				IF !::Validate( .T. )
					notebookEvt:Veto()
					RETURN
				ENDIF
				::Post()
			ENDIF
			EXIT
		ENDSWITCH

		selecting := notebookEvt:GetSelection()
		
		SWITCH selecting
		CASE 1
			IF oldSelection = 2
				wxGetApp():brw:RefreshAll()
			ENDIF
			EXIT
		CASE 2
			::noteBook:GetPage( 2 ):TransferDataToWindow()
			EXIT
		ENDSWITCH

	ENDIF

RETURN

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
