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
  DATA FBof       INIT .T.
  DATA FEof       INIT .T.
  DATA FFound     INIT .F.
  DATA FName      INIT ""
  DATA FRecNo     INIT 0
  DATA FTable
  METHOD GetName INLINE ::FName
  METHOD GetRecNo INLINE ::SyncFromRecNo(),::FRecNo
  METHOD SetRecNo( RecNo ) INLINE ::DbGoTo( RecNo )
PROTECTED:
PUBLIC:
  CONSTRUCTOR New( Name )
  METHOD AddRec
  METHOD DbGoTo( RecNo )
  METHOD DbSkip( n )
  METHOD DbStruct INLINE (::FName)->(DbStruct())
  METHOD DbOpen
  METHOD Eval( codeBlock )
  METHOD ExistKey( KeyValue, IndexName, RecNo )
  METHOD FCount INLINE (::FName)->(FCount())
  METHOD FieldPos( FieldName ) INLINE (::FName)->( FieldPos( FieldName ) )
  METHOD FieldValue( fieldName )
  METHOD Get4Seek( xField, cKey, indexName, softSeek )
  METHOD Get4SeekLast( xField, cKey, indexName, softSeek )
  METHOD GoBottom( indexName )
  METHOD GoTop( indexName )
  METHOD IsLocked( RecNo )
  METHOD KeyVal( indexName )
  METHOD LastRec INLINE (::FName)->( LastRec() )
  METHOD OrdCustom( Name, cBag, KeyVal )
  METHOD OrdKeyAdd( Name, cBag, KeyVal )
  METHOD OrdKeyDel( Name, cBag, KeyVal )
  METHOD OrdSetFocus( Name, cBag )
  METHOD PopWS INLINE (::FName)->(PopWS())
  METHOD PushWS INLINE (::FName)->(PushWS())
  METHOD RecCount INLINE (::FName)->( RecCount() )
  METHOD RecLock( RecNo )
  METHOD RecUnLock( RecNo )
  METHOD Seek( cKey, indexName, softSeek )
  METHOD SeekLast( cKey, indexName, softSeek )
  METHOD Skip( nRecords, indexName )
  METHOD SyncFromAlias
  METHOD SyncFromRecNo

  /*!
   * needed for tdbrowse.prg (oDBE:Alias)
   */
  PROPERTY Alias READ FName

PUBLISHED:
  PROPERTY Bof READ FBof
  PROPERTY Eof READ FEof
  PROPERTY Found READ FFound
  PROPERTY Name READ GetName
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

  ::FTable := table

  ::FRecNo := 0

  IF Empty( table:TableName )
    RAISE ERROR "TAlias: Empty Table Name..."
  ENDIF

  IF !::DbOpen()
    RAISE ERROR "TAlias: Cannot Open Table '" + table:TableName + "'"
  ENDIF

  ::SyncFromRecNo()

RETURN Self

/*
  AddRec
  Teo. Mexico 2007
*/
METHOD FUNCTION AddRec( index ) CLASS TAlias
  LOCAL Result
  Result := (::FName)->( AddRec(,index) )
  ::SyncFromAlias()
RETURN Result

/*
  DbGoTo
  Teo. Mexico 2007
*/
METHOD FUNCTION DbGoTo( RecNo ) CLASS TAlias
  LOCAL Result
  Result := (::FName)->( DbGoTo( RecNo ) )
  ::SyncFromAlias()
RETURN Result

/*
  DbOpen
  Teo. Mexico 2008
*/
METHOD DbOpen CLASS TAlias

  /* Check for a previously open database */
  IF !Empty( ::FName ) .AND. Select( ::FName ) > 0
    RETURN .T.
  ENDIF

  IF ::FTable:DataBase:OpenBlock != NIL
    RETURN ::FTable:DataBase:OpenBlock:Eval( ::FTable:TableName )
  ENDIF

  USE ( ::FTable:FullFileName ) NEW SHARED

  ::FName := Alias()

RETURN !NetErr()

/*
  DbSkip
  Teo. Mexico 2007
*/
METHOD FUNCTION DbSkip( n ) CLASS TAlias
  LOCAL Result
  ::SyncFromRecNo()
  Result := (::FName)->( DbSkip( n ) )
  ::SyncFromAlias()
RETURN Result

/*
  Eval
  Teo. Mexico 2007
*/
METHOD FUNCTION Eval( codeBlock, p1, p2, p3 ) CLASS TAlias
  ::SyncFromRecNo()
RETURN (::FName)->(codeBlock:Eval( p1, p2, p3 ) )

/*
  ExistKey
  Teo. Mexico 2007
*/
METHOD FUNCTION ExistKey( KeyValue, IndexName, RecNo ) CLASS TAlias
RETURN (::FName) -> ( ExistKey( KeyValue, IndexName, RecNo ) )

/*
  FieldValue
  Teo. Mexico 2007
*/
METHOD FUNCTION FieldValue( fieldName ) CLASS TAlias
  ::SyncFromRecNo()
RETURN (::FName)->( FieldGet( FieldPos( fieldName ) ) )

/*
  Get4Seek
  Teo. Mexico 2008
*/
METHOD FUNCTION Get4Seek( xField, cKey, indexName, softSeek ) CLASS TAlias
RETURN (::FName) -> ( Get4Seek( xField, cKey, indexName, softSeek ) )

/*
  Get4SeekLast
  Teo. Mexico 2007
*/
METHOD FUNCTION Get4SeekLast( xField, cKey, indexName, softSeek ) CLASS TAlias
RETURN (::FName) -> ( Get4SeekLast( xField, cKey, indexName, softSeek ) )

/*
  GoBottom
  Teo. Mexico 2007
*/
METHOD FUNCTION GoBottom( indexName ) CLASS TAlias
  LOCAL Result
  Result := (::FName)->( GoBottom( indexName ) )
  ::SyncFromAlias()
RETURN Result

/*
  GoTop
  Teo. Mexico 2007
*/
METHOD FUNCTION GoTop( indexName ) CLASS TAlias
  LOCAL Result
  Result := (::FName)->( GoTop( indexName ) )
  ::SyncFromAlias()
RETURN Result

/*
  IsLocked
  Teo. Mexico 2007
*/
METHOD FUNCTION IsLocked( RecNo ) CLASS TAlias
RETURN (::FName) -> ( IsLocked( iif( RecNo = NIL, ::FRecNo, RecNo ) ) )

/*
  KeyVal
  Teo. Mexico 2007
*/
METHOD FUNCTION KeyVal( indexName ) CLASS TAlias
  ::SyncFromRecNo()
RETURN (::FName) -> ( KeyVal( indexName ) )

/*
  OrdCustom
  Teo. Mexico 2007
*/
METHOD FUNCTION OrdCustom( Name, cBag, KeyVal ) CLASS TAlias
  ::SyncFromRecNo()
RETURN (::FName)->( OrdCustom( Name, cBag, KeyVal ) )

/*
  OrdKeyAdd
  Teo. Mexico 2007
*/
METHOD FUNCTION OrdKeyAdd( Name, cBag, KeyVal ) CLASS TAlias
  ::SyncFromRecNo()
RETURN (::FName)->( OrdKeyAdd( Name, cBag, KeyVal ) )

/*
  OrdKeyDel
  Teo. Mexico 2007
*/
METHOD FUNCTION OrdKeyDel( Name, cBag, KeyVal ) CLASS TAlias
  ::SyncFromRecNo()
RETURN (::FName)->( OrdKeyDel( Name, cBag, KeyVal ) )

/*
  OrdSetFocus
  Teo. Mexico 2007
*/
METHOD FUNCTION OrdSetFocus( Name, cBag ) CLASS TAlias
  ::SyncFromRecNo()
RETURN (::FName)->( OrdSetFocus( Name, cBag ) )

/*
  RecLock
  Teo. Mexico 2007
*/
METHOD FUNCTION RecLock( RecNo ) CLASS TAlias
  ::SyncFromRecNo()
RETURN (::FName)->( RecLock( RecNo ) )

/*
  RecUnLock
  Teo. Mexico 2007
*/
METHOD FUNCTION RecUnLock( RecNo ) CLASS TAlias
  ::SyncFromRecNo()
RETURN (::FName)->( RecUnLock( RecNo ) )

/*
  Seek
  Teo. Mexico 2007
*/
METHOD FUNCTION Seek( cKey, indexName, softSeek ) CLASS TAlias
  LOCAL Result
  Result := (::FName) -> ( Seek( cKey, indexName, softSeek ) )
  ::SyncFromAlias()
RETURN Result

/*
  SeekLast
  Teo. Mexico 2007
*/
METHOD FUNCTION SeekLast( cKey, indexName, softSeek ) CLASS TAlias
  LOCAL Result
  Result := (::FName) -> ( SeekLast( cKey, indexName, softSeek ) )
  ::SyncFromAlias()
RETURN Result

/*
  Skip
  Teo. Mexico 2007
*/
METHOD FUNCTION Skip( nRecords, indexName ) CLASS TAlias
  LOCAL Result
  ::SyncFromRecNo()
  Result := (::FName) -> ( Skip( nRecords, indexName ) )
  ::SyncFromAlias()
RETURN Result

/*
  SyncFromAlias
  Teo. Mexico 2007
*/
METHOD PROCEDURE SyncFromAlias CLASS TAlias
/*  IF !DbIsOpen(::FName) .AND. !DBF_OPEN(::FName)
    RAISE ERROR "Cannot open [" + ::FName + "] database..."
  ENDIF*/
  ::FBof   := (::FName)->( Bof() )
  ::FEof   := (::FName)->( Eof() )
  ::FFound := (::FName)->( Found() )
  ::FRecNo := iif( ::FEof, 0 , (::FName)->( RecNo() ) ) /* sure Eof even if dbf grows */
RETURN

/*
  SyncFromRecNo
  Teo. Mexico 2007
*/
METHOD PROCEDURE SyncFromRecNo CLASS TAlias
/*  IF !DbIsOpen(::FName) .AND. !DBF_OPEN(::FName)
    RAISE ERROR "Cannot open [" + ::FName + "] database..."
  ENDIF*/
  IF (::FName)->(RecNo()) != ::FRecNo
    (::FName)->(DbGoTo( ::FRecNo ) )
    ::FBof   := (::FName)->( Bof() )
    ::FEof   := (::FName)->( Eof() )
    ::FFound := (::FName)->( Found() )
  ENDIF
RETURN

/*
  ENDCLASS TAlias
*/
