/*
 * $Id$
 */

/*
	TAlias
	Teo. Mexico 2007
*/

#include "hbclass.ch"
#include "property.ch"
#include "raddox.ch"
#include "xerror.ch"

CLASS TAlias
PRIVATE:
	DATA FBof				 INIT .T.
	DATA FEof				 INIT .T.
	DATA FFound			 INIT .F.
	DATA FName			 INIT ""
	DATA FnWorkArea	 INIT 0
	DATA FRecNo			 INIT 0
	DATA FStack			 INIT {}
	DATA FStackLen	 INIT 0
	DATA FTable
	METHOD GetRecNo INLINE ::SyncFromRecNo(),::FRecNo
	METHOD SetRecNo( RecNo ) INLINE ::DbGoTo( RecNo )
PROTECTED:
PUBLIC:
	CONSTRUCTOR New( Name )
	METHOD AddRec( index )
	METHOD DbDelete()
	METHOD DbGoBottom( indexName )
	METHOD DbGoTo( RecNo )
	METHOD DbGoTop( indexName )
	METHOD DbSkip( nRecords, indexName )
	METHOD DbStruct INLINE (::FnWorkArea)->(DbStruct())
	METHOD DbOpen
	METHOD DbRecall()
	METHOD Deleted()
	METHOD Eval( codeBlock )
	METHOD ExistKey( KeyValue, IndexName, RecNo )
	METHOD FCount INLINE (::FnWorkArea)->(FCount())
	METHOD FieldPos( FieldName ) INLINE (::FnWorkArea)->( FieldPos( FieldName ) )
	METHOD FieldValue( fieldName )
	METHOD Get4Seek( xField, cKey, indexName, softSeek )
	METHOD Get4SeekLast( xField, cKey, indexName, softSeek )
	METHOD IsLocked( RecNo )
	METHOD KeyVal( indexName )
	METHOD LastRec INLINE (::FnWorkArea)->( LastRec() )
	METHOD OrdCustom( Name, cBag, KeyVal )
	METHOD OrdKeyAdd( Name, cBag, KeyVal )
	METHOD OrdKeyDel( Name, cBag, KeyVal )
	METHOD OrdNumber( ordName, ordBagName )
	METHOD OrdSetFocus( Name, cBag )
	METHOD Pop()
	METHOD Push()
	METHOD RecCount INLINE (::FnWorkArea)->( RecCount() )
	METHOD RecLock( RecNo )
	METHOD RecUnLock( RecNo )
	METHOD Seek( cKey, indexName, softSeek )
	METHOD SeekLast( cKey, indexName, softSeek )
	METHOD SyncFromAlias
	METHOD SyncFromRecNo

	/*!
	 * needed for tdbrowse.prg (oDBE:Alias)
	 */
	PROPERTY Alias READ FName

	PROPERTY nWorkArea READ FnWorkArea

PUBLISHED:
	PROPERTY Bof READ FBof
	PROPERTY Eof READ FEof
	PROPERTY Found READ FFound
	PROPERTY Name READ FName
	PROPERTY RecNo READ GetRecNo WRITE SetRecNo
	PROPERTY Table READ FTable
ENDCLASS

/*
	New
	Teo. Mexico 2007
*/
METHOD New( table ) CLASS TAlias

	IF Empty( table )
		RAISE ERROR "TAlias: Empty Table parameter."
	ENDIF

	/* Check if this is a remote request */
	IF table:RDOClient != NIL
		RETURN table:Alias
	ENDIF

	::FTable := table

	::FRecNo := 0

	IF Empty( table:TableFileName )
		RAISE ERROR "TAlias: Empty Table Name..."
	ENDIF

	IF !::DbOpen()
		//RAISE ERROR "TAlias: Cannot Open Table '" + table:TableFileName + "'"
		BREAK( "TAlias: Cannot Open Table '" + table:TableFileName + "'" )
	ENDIF

	::SyncFromRecNo()

RETURN Self

/*
	AddRec
	Teo. Mexico 2007
*/
METHOD FUNCTION AddRec( index ) CLASS TAlias
	LOCAL Result
	Result := (::FnWorkArea)->( AddRec(,index) )
	::SyncFromAlias()
RETURN Result

/*
	DbDelete
	Teo. Mexico 2009
*/
METHOD PROCEDURE DbDelete() CLASS TAlias
	::SyncFromRecNo()
	(::FnWorkArea)->( DbDelete() )
RETURN

/*
	DbGoBottom
	Teo. Mexico 2007
*/
METHOD FUNCTION DbGoBottom( indexName ) CLASS TAlias
	LOCAL Result
	IF Empty( indexName )
		Result := (::FnWorkArea)->( DbGoBottom() )
	ELSE
		Result := (::FnWorkArea)->( DbGoBottomX( indexName ) )
	ENDIF
	::SyncFromAlias()
RETURN Result

/*
	DbGoTo
	Teo. Mexico 2007
*/
METHOD FUNCTION DbGoTo( RecNo ) CLASS TAlias
	LOCAL Result
	Result := (::FnWorkArea)->( DbGoTo( RecNo ) )
	::SyncFromAlias()
RETURN Result

/*
	DbGoTop
	Teo. Mexico 2007
*/
METHOD FUNCTION DbGoTop( indexName ) CLASS TAlias
	LOCAL Result
	IF Empty( indexName )
		Result := (::FnWorkArea)->( DbGoTop() )
	ELSE
		Result := (::FnWorkArea)->( DbGoTopX( indexName ) )
	ENDIF
	::SyncFromAlias()
RETURN Result

/*
	DbOpen
	Teo. Mexico 2008
*/
METHOD DbOpen CLASS TAlias
	LOCAL n

	/* Check for a previously open workarea */
	n := Select( ::FTable:TableFileName )
	IF n > 0
		::FName := ::FTable:TableFileName
		::FnWorkArea := n
		RETURN .T.
	ENDIF

	IF ::FTable:DataBase:OpenBlock != NIL
		IF !::FTable:DataBase:OpenBlock:Eval( ::FTable:TableFileName )
			::FName := ""
			::FnWorkArea := 0
			RETURN .F.
		ENDIF
		::FName := ::FTable:TableFileName
		::FnWorkArea := Select( ::FTable:TableFileName )
		RETURN .T.
	ENDIF

	USE ( ::FTable:FullFileName ) NEW SHARED

	::FName := Alias()
	::FnWorkArea := Select()

RETURN !NetErr()

/*
	DbRecall
	Teo. Mexico 2009
*/
METHOD PROCEDURE DbRecall() CLASS TAlias
	::SyncFromRecNo()
	(::FnWorkArea)->( DbRecall() )
RETURN

/*
	DbSkip
	Teo. Mexico 2007
*/
METHOD FUNCTION DbSkip( nRecords, indexName ) CLASS TAlias
	LOCAL Result

	::SyncFromRecNo()

	IF Empty( indexName )
		Result := (::FnWorkArea)->( DbSkip( nRecords ) )
	ELSE
		Result := (::FnWorkArea)->( DbSkipX( nRecords, indexName ) )
	ENDIF

	::SyncFromAlias()

RETURN Result

/*
	Deleted
	Teo. Mexico 2009
*/
METHOD FUNCTION Deleted() CLASS TAlias
	::SyncFromRecNo()
RETURN (::FnWorkArea)->( Deleted() )

/*
	Eval
	Teo. Mexico 2007
*/
METHOD FUNCTION Eval( codeBlock, p1, p2, p3 ) CLASS TAlias
	::SyncFromRecNo()
RETURN (::FnWorkArea)->(codeBlock:Eval( p1, p2, p3 ) )

/*
	ExistKey
	Teo. Mexico 2007
*/
METHOD FUNCTION ExistKey( KeyValue, IndexName, RecNo ) CLASS TAlias
RETURN (::FnWorkArea)->( ExistKey( KeyValue, IndexName, RecNo ) )

/*
	FieldValue
	Teo. Mexico 2007
*/
METHOD FUNCTION FieldValue( fieldName ) CLASS TAlias
	::SyncFromRecNo()
RETURN (::FnWorkArea)->( FieldGet( FieldPos( fieldName ) ) )

/*
	Get4Seek
	Teo. Mexico 2008
*/
METHOD FUNCTION Get4Seek( xField, cKey, indexName, softSeek ) CLASS TAlias
RETURN (::FnWorkArea)->( Get4Seek( xField, cKey, indexName, softSeek ) )

/*
	Get4SeekLast
	Teo. Mexico 2007
*/
METHOD FUNCTION Get4SeekLast( xField, cKey, indexName, softSeek ) CLASS TAlias
RETURN (::FnWorkArea)->( Get4SeekLast( xField, cKey, indexName, softSeek ) )

/*
	IsLocked
	Teo. Mexico 2007
*/
METHOD FUNCTION IsLocked( RecNo ) CLASS TAlias
RETURN (::FnWorkArea)->( IsLocked( iif( RecNo == NIL, ::FRecNo, RecNo ) ) )

/*
	KeyVal
	Teo. Mexico 2007
*/
METHOD FUNCTION KeyVal( indexName ) CLASS TAlias
	::SyncFromRecNo()
RETURN (::FnWorkArea)->( KeyVal( indexName ) )

/*
	OrdCustom
	Teo. Mexico 2007
*/
METHOD FUNCTION OrdCustom( Name, cBag, KeyVal ) CLASS TAlias
	::SyncFromRecNo()
RETURN (::FnWorkArea)->( OrdCustom( Name, cBag, KeyVal ) )

/*
	OrdKeyAdd
	Teo. Mexico 2007
*/
METHOD FUNCTION OrdKeyAdd( Name, cBag, KeyVal ) CLASS TAlias
	::SyncFromRecNo()
RETURN (::FnWorkArea)->( OrdKeyAdd( Name, cBag, KeyVal ) )

/*
	OrdKeyDel
	Teo. Mexico 2007
*/
METHOD FUNCTION OrdKeyDel( Name, cBag, KeyVal ) CLASS TAlias
	::SyncFromRecNo()
RETURN (::FnWorkArea)->( OrdKeyDel( Name, cBag, KeyVal ) )

/*
	OrdNumber
	Teo. Mexico 2009
*/
METHOD FUNCTION OrdNumber( ordName, ordBagName ) CLASS TAlias
	::SyncFromRecNo()
RETURN (::FnWorkArea)->( OrdNumber( ordName, ordBagName ) )

/*
	OrdSetFocus
	Teo. Mexico 2007
*/
METHOD FUNCTION OrdSetFocus( Name, cBag ) CLASS TAlias
	::SyncFromRecNo()
RETURN (::FnWorkArea)->( OrdSetFocus( Name, cBag ) )

/*
	Pop
	Teo. Mexico 2009
*/
METHOD PROCEDURE Pop() CLASS TAlias
	IF ::FStackLen > 0
		::FBof	 := ::FStack[ ::FStackLen, 1 ]
		::FEof	 := ::FStack[ ::FStackLen, 2 ]
		::FFound := ::FStack[ ::FStackLen, 3 ]
		::FRecNo := ::FStack[ ::FStackLen, 4 ]
		--::FStackLen
	ENDIF
RETURN

/*
	Push
	Teo. Mexico 2009
*/
METHOD PROCEDURE Push() CLASS TAlias
	IF Len( ::FStack ) < ++::FStackLen
		AAdd( ::FStack, { NIL, NIL, NIL, NIL } )
	ENDIF
	::FStack[ ::FStackLen, 1 ] := ::FBof
	::FStack[ ::FStackLen, 2 ] := ::FEof
	::FStack[ ::FStackLen, 3 ] := ::FFound
	::FStack[ ::FStackLen, 4 ] := ::FRecNo
RETURN

/*
	RecLock
	Teo. Mexico 2007
*/
METHOD FUNCTION RecLock( RecNo ) CLASS TAlias
	::SyncFromRecNo()
RETURN (::FnWorkArea)->( RecLock( RecNo ) )

/*
	RecUnLock
	Teo. Mexico 2007
*/
METHOD FUNCTION RecUnLock( RecNo ) CLASS TAlias
	::SyncFromRecNo()
RETURN (::FnWorkArea)->( RecUnLock( RecNo ) )

/*
	Seek
	Teo. Mexico 2007
*/
METHOD FUNCTION Seek( cKey, indexName, softSeek ) CLASS TAlias
	LOCAL Result
	Result := (::FnWorkArea)->( Seek( cKey, indexName, softSeek ) )
	::SyncFromAlias()
RETURN Result

/*
	SeekLast
	Teo. Mexico 2007
*/
METHOD FUNCTION SeekLast( cKey, indexName, softSeek ) CLASS TAlias
	LOCAL Result
	Result := (::FnWorkArea)->( SeekLast( cKey, indexName, softSeek ) )
	::SyncFromAlias()
RETURN Result

/*
	SyncFromAlias
	Teo. Mexico 2007
*/
METHOD PROCEDURE SyncFromAlias CLASS TAlias
	::FBof	 := (::FnWorkArea)->( Bof() )
	::FEof	 := (::FnWorkArea)->( Eof() )
	::FFound := (::FnWorkArea)->( Found() )
	::FRecNo := iif( ::FEof .OR. ::FBof, 0 , (::FnWorkArea)->( RecNo() ) ) /* sure Eof even if dbf grows */
RETURN

/*
	SyncFromRecNo
	Teo. Mexico 2007
*/
METHOD PROCEDURE SyncFromRecNo CLASS TAlias
	IF (::FnWorkArea)->(RecNo()) != ::FRecNo
		(::FnWorkArea)->(DbGoTo( ::FRecNo ) )
		::FBof	 := (::FnWorkArea)->( Bof() )
		::FEof	 := (::FnWorkArea)->( Eof() )
		::FFound := (::FnWorkArea)->( Found() )
	ENDIF
RETURN

/*
	ENDCLASS TAlias
*/
