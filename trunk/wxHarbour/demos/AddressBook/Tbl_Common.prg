/*
    $Id$
    Tbl_Common : Table to contain names
*/

#include "wxharbour.ch"

#include "AddressBook.ch"

CLASS Tbl_Common FROM TTable
PRIVATE:
PROTECTED:
    METHOD InitDataBase INLINE MyDataBase():New()
PUBLIC:

    DATA noteBook

    PROPERTY AutoCreate DEFAULT .T.

    DEFINE FIELDS

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
BEGIN FIELDS CLASS Tbl_Common

    /* Add here field's common to all descendant tables */

END FIELDS CLASS

/*
	OnDataChange
*/
METHOD PROCEDURE OnDataChange() CLASS Tbl_Common

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
METHOD PROCEDURE OnNotebookPageChanged( notebookEvt ) CLASS Tbl_Common

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
METHOD PROCEDURE OnNotebookPageChanging( notebookEvt ) CLASS Tbl_Common

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
METHOD FUNCTION TryDelete() CLASS Tbl_Common
RETURN ::Delete()

/*
	TryEdit
*/
METHOD FUNCTION TryEdit() CLASS Tbl_Common

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
METHOD FUNCTION TryInsert() CLASS Tbl_Common

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
METHOD FUNCTION TryPost() CLASS Tbl_Common
RETURN ::Post()
