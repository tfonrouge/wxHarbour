/*
    $Id$
*/

#include "wxharbour.ch"

#include "AddressBook.ch"

/*
	TBasicBrowse : a browse with basic features
*/
CLASS TBaseBrowse FROM wxhBrowse
PRIVATE:
PROTECTED:
PUBLIC:

    METHOD CanCancel() INLINE AScan( { dsEdit, dsInsert }, ::DataSource:State ) > 0
    METHOD CanDelete() INLINE ! ::DataSource:Eof() .AND. ::DataSource:State = dsBrowse
    METHOD CanEdit() INLINE ! ::DataSource:Eof() .AND. ::DataSource:State = dsBrowse
    METHOD CanInsert() INLINE ::DataSource:State = dsBrowse
    METHOD CanMove( direction )
    METHOD CanPost() INLINE AScan( { dsEdit, dsInsert }, ::DataSource:State ) > 0

	METHOD OnCreate()

PUBLISHED:
ENDCLASS

/*
	CanMove
*/
METHOD FUNCTION CanMove( direction ) CLASS TBaseBrowse
	LOCAL Result := .F.
	
	SWITCH direction
	CASE abID_UP
		Result := !::DataSource:Bof()
		EXIT
	CASE abID_DOWN
		Result := !::DataSource:Eof()
		EXIT
	CASE abID_NONE
		Result := .T.
		EXIT
	ENDSWITCH

RETURN Result .AND. ::DataSource:State = dsBrowse

/*
	OnCreate
*/
METHOD PROCEDURE OnCreate() CLASS TBaseBrowse

	Super:OnCreate()
	
	::ConnectGridEvt( ::GetId(), wxEVT_GRID_LABEL_LEFT_DCLICK, {|gridEvent| gridEvent:GetEventObject():AutoSizeColumns( .F. )  } )

RETURN
