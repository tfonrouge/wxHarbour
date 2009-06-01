/*
  TIndex
  Teo. Mexico 2007
*/

#ifdef __XHARBOUR__
  #include "wx_hbcompat.ch"
#endif

#include "hbclass.ch"
#include "property.ch"
#include "raddox.ch"
#include "xerror.ch"

/*
  CLASS TIndex
  Teo. Mexico 2006
*/
CLASS TIndex
PRIVATE:
  DATA FAutoIncrementKeyField
  DATA FCaseSensitive INIT .F.
  DATA FCustom INIT .F.
  DATA FDescend INIT .F.
  DATA FForKey
  DATA FKeyField
  DATA FName INIT ""
  DATA FMasterKeyField
  DATA FScopeBottom
  DATA FScopeTop
  DATA FTable
  DATA FUniqueKeyField
  METHOD DbGoBottomTop( n )
  METHOD GetAutoIncrement INLINE ::FAutoIncrementKeyField != NIL
  METHOD GetField
  METHOD GetScope INLINE iif( ::FScopeBottom == NIL .AND. ::FScopeTop == NIL, NIL, { ::FScopeTop, ::FScopeBottom } )
  METHOD GetScopeBottom INLINE iif( !Empty( ::FScopeBottom ), ::FScopeBottom, "" )
  METHOD GetScopeTop INLINE iif( !Empty( ::FScopeTop ), ::FScopeTop, "" )
  METHOD GetUnique INLINE ::FUniqueKeyField != NIL
  METHOD SetCaseSensitive( CaseSensitive ) INLINE ::FCaseSensitive := CaseSensitive
  METHOD SetCustom( Custom )
  METHOD SetDescend( Descend ) INLINE ::FDescend := Descend
  METHOD SetField( nIndex, XField )
  METHOD SetForKey( ForKey ) INLINE ::FForKey := ForKey
  METHOD SetName( Name ) INLINE ::FName := Name
  METHOD SetScope( value )
  METHOD SetScopeBottom( value )
  METHOD SetScopeTop( value )
PROTECTED:
PUBLIC:
  METHOD New( Table ) CONSTRUCTOR
  METHOD AddIndex
  METHOD CustomKeyDel
  METHOD CustomKeyUpdate
  METHOD DbGoBottom INLINE ::DbGoBottomTop( 1 )
  METHOD DbGoTop INLINE ::DbGoBottomTop( 0 )
  METHOD DbSkip( numRecs )
  METHOD ExistKey( keyValue )
  METHOD InsideScope
  METHOD MasterKeyString INLINE iif( ::FMasterKeyField = NIL, ::FTable:PrimaryMasterKeyString, ::FMasterKeyField:AsIndexKeyVal )
  METHOD RawSeek( Value )
  METHOD Seek( keyValue )

  PROPERTY Scope READ GetScope WRITE SetScope
  PROPERTY ScopeBottom READ GetScopeBottom WRITE SetScopeBottom
  PROPERTY ScopeTop READ GetScopeTop WRITE SetScopeTop

PUBLISHED:
  PROPERTY AutoIncrement READ GetAutoIncrement
  PROPERTY AutoIncrementKeyField INDEX 1 READ GetField WRITE SetField
  PROPERTY CaseSensitive READ FCaseSensitive WRITE SetCaseSensitive
  PROPERTY Custom READ FCustom WRITE SetCustom
  PROPERTY Descend READ FDescend WRITE SetDescend
  PROPERTY ForKey READ FForKey WRITE SetForKey
  PROPERTY KeyField INDEX 3 READ GetField WRITE SetField
  PROPERTY UniqueKeyField INDEX 2 READ GetField WRITE SetField
  PROPERTY Name READ FName WRITE SetName
  PROPERTY MasterKeyField INDEX 0 READ GetField WRITE SetField
  PROPERTY Table READ FTable
  PROPERTY Unique READ GetUnique
ENDCLASS

/*
  New
  Teo. Mexico 2006
*/
METHOD New( Table, indexType ) CLASS TIndex

  ::FTable := Table

  IF AScan( ::FTable:IndexList, {|e| e == Self }) = 0

    AAdd( ::FTable:IndexList, Self )

    IF "PRIMARY" = indexType
      ::FTable:PrimaryIndex := Self
    ENDIF

  ENDIF

RETURN Self

/*
  AddIndex
  Teo. Mexico 2008
*/
METHOD AddIndex( cName, cMasterKeyField, ai, un, cKeyField, ForKey, cs, de/*, cu*/ )

  ::Name := cName
  ::MasterKeyField := cMasterKeyField

  /* Check if needs to add the primary index key */
  IF ::FTable:PrimaryIndex == Self
    IF ai == .T.
      ::AutoIncrementKeyField := cKeyField
    ELSE
      ::UniqueKeyField := cKeyField
    ENDIF
  ELSE
    DO CASE
    /* Check if index key is AutoIncrement */
    CASE ai == .T.
      ::AutoIncrementKeyField := cKeyField
    /* Check if index key is Unique */
    CASE un == .T.
      ::UniqueKeyField := cKeyField
    /* Check if index key is a simple index */
    OTHERWISE
      ::KeyField := cKeyField
    ENDCASE
  ENDIF

  ::ForKey := ForKey
  ::CaseSensitive := iif( HB_ISNIL( cs ), .F. , cs )
  ::Descend := iif( HB_ISNIL( de ), .F. , de )
//   ::Custom := iif( HB_ISNIL( cu ), .F. , cu )

RETURN Self

/*
  CustomKeyDel
  Teo. Mexico 2006
*/
METHOD PROCEDURE CustomKeyDel CLASS TIndex
  LOCAL KeyVal

  IF !::FCustom
    RETURN
  ENDIF

  KeyVal := ::FTable:Alias:KeyVal( ::FName )

  WHILE ::FTable:Alias:ordKeyDel( ::FName, , KeyVal )
  ENDDO

RETURN

/*
  CustomKeyUpdate
  Teo. Mexico 2006
*/
METHOD PROCEDURE CustomKeyUpdate CLASS TIndex
  LOCAL KeyVal
  LOCAL Value

  KeyVal := ::FTable:Alias:KeyVal( ::FName )

  ::CustomKeyDel()

  IF !::FCustom .AND. ::UniqueKeyField != NIL
    RETURN
  ENDIF

  Value :=  ::UniqueKeyField:AsString

  IF Empty( Value )
    RETURN
  ENDIF

  IF !::FCaseSensitive
    Value := Upper( Value )
  ENDIF

  IF KeyVal != NIL .AND. ( Len( KeyVal ) != Len( ::FTable:PrimaryMasterKeyString + Value ) )
    ::Error_Custom_Index_Lenght_does_not_match_value()
    RETURN
  ENDIF

  ::FTable:Alias:ordKeyAdd( ::FName, , ::FTable:PrimaryMasterKeyString + Value )

RETURN

/*
  DbGoBottomTop
  Teo. Mexico 2008
*/
METHOD FUNCTION DbGoBottomTop( n ) CLASS TIndex
  LOCAL masterKeyString := ::MasterKeyString

  IF n = 0
    ::FTable:Alias:Seek( masterKeyString + ::GetScopeTop(), ::FName )
  ELSE
    ::FTable:Alias:SeekLast( masterKeyString + ::GetScopeBottom() , ::FName )
  ENDIF

  ::FTable:GetCurrentRecord()

RETURN ::FTable:Found()

/*
  DbSkip
  Teo. Mexico 2007
*/
METHOD PROCEDURE DbSkip( numRecs ) CLASS TIndex

  ::FTable:Alias:DbSkip( numRecs, ::FName )

  IF !::InsideScope()
    ::FTable:DbGoTo( 0 )
  ENDIF

  ::FTable:GetCurrentRecord()

RETURN

/*
  ExistKey
  Teo. Mexico 2007
*/
METHOD FUNCTION ExistKey( keyValue ) CLASS TIndex
RETURN ::FTable:Alias:ExistKey( ::MasterKeyString + ;
                                        iif( ::FCaseSensitive, ;
                                          keyValue, ;
                                          Upper( keyValue ) ), ;
                                        ::FName, ::FTable:RecNo )

/*
  GetField
  Teo. Mexico 2006
*/
METHOD FUNCTION GetField( nIndex ) CLASS TIndex
  LOCAL AField

  SWITCH nIndex
  CASE 0
    AField := ::FMasterKeyField
    EXIT
  CASE 1
    AField := ::FAutoIncrementKeyField
    EXIT
  CASE 2
    AField := ::FUniqueKeyField
    EXIT
  CASE 3
    AField := ::FKeyField
    EXIT
  END

RETURN AField

/*
  InsideScope
  Teo. Mexico 2008
*/
METHOD FUNCTION InsideScope CLASS TIndex
  LOCAL masterKeyString
  LOCAL scopeVal
  LOCAL keyValue

  IF ::FTable:Alias:Eof()
    RETURN .F.
  ENDIF

  masterKeyString := ::MasterKeyString
  keyValue := ::FTable:Alias:KeyVal( ::FName )
  
  IF keyValue == NIL
    RETURN .F.
  ENDIF
  
  scopeVal := ::GetScope()
  
  IF scopeVal = NIL
    RETURN Empty( masterKeyString ) .OR. keyValue = masterKeyString
  ENDIF
  
RETURN keyValue >= ( masterKeyString + ::GetScopeTop() ) .AND. ;
       keyValue <= ( masterKeyString + ::GetScopeBottom() )

/*
  RawSeek
  Teo. Mexico 2008
*/
METHOD FUNCTION RawSeek( Value ) CLASS TIndex

  IF AScan( {dsEdit,dsInsert}, ::FTable:State ) > 0
    ::FTable:Post()
  ENDIF

  ::FTable:Alias:Seek( Value, ::FName )

  ::FTable:GetCurrentRecord()

RETURN ::FTable:Found()

/*
  Seek
  Teo. Mexico 2007
*/
METHOD FUNCTION Seek( keyValue, lSoftSeek ) CLASS TIndex

  IF AScan( {dsEdit,dsInsert}, ::FTable:State ) > 0
    ::FTable:Post()
  ENDIF

  keyValue := ::KeyField:AsIndexKeyVal( keyValue )

  ::FTable:Alias:Seek( ::MasterKeyString + iif( ::FCaseSensitive, keyValue, Upper( keyValue ) ), ::FName, lSoftSeek )

  ::FTable:GetCurrentRecord()

RETURN ::FTable:Found()

/*
  SetCustom
  Teo. Mexico 2006
*/
METHOD PROCEDURE SetCustom( Custom ) CLASS TIndex

  ::FCustom := Custom

  ::FTable:Alias:ordCustom( ::FName, , Custom )

RETURN

/*
  SetField
  Teo. Mexico 2006
*/
METHOD PROCEDURE SetField( nIndex, XField ) CLASS TIndex
  LOCAL AField

  SWITCH ValType( XField )
  CASE 'C'
    IF Empty( XField ) /* A null field (always returns "") */
      AField := TStringField():New( ::FTable )
      AField:FieldMethod := {|| "" }
    ELSE
      AField := ::FTable:FieldByName( XField )
    ENDIF
    IF AField = NIL
      RAISE ERROR "Declared Index Field '" + XField + "' doesn't exist..."
      RETURN
    ENDIF
    EXIT
  CASE 'O'
    IF !XField:IsDerivedFrom("TField")
      ::Error_Not_TField_Type_Object()
      RETURN
    ENDIF
    AField := XField
    EXIT
  CASE 'A'
    /* Array of fields are stored in a TStringField (for the index nature) */
    AField := TStringField():New( ::FTable )
    AField:FieldMethod  := XField
    EXIT
  CASE 'U'
    AField := NIL
    EXIT
#ifdef __XHARBOUR__
  DEFAULT
#else
  OTHERWISE
#endif
    wxhAlert("! : Not a Valid Field Identifier...")
    RETURN
  END

  /* Assign PrimaryKeyComponent value */
  IF ::FTable:PrimaryIndex == Self /* check if index is the Primary index */
    IF !HB_ISNIL( AField )
      AField:PrimaryKeyComponent := .T.
      /* Assign MasterField value to the TTable object field */
      IF nIndex = 0
        AField:IsMasterFieldComponent := .T.
      ENDIF
    ENDIF
  ELSE
    //AField:SecondaryKeyComponent := .T.
  ENDIF

  IF AField = NIL
    RETURN
  ENDIF

  SWITCH nIndex
  CASE 0   /* MasterKeyField */
    ::FMasterKeyField := AField
    EXIT
  CASE 1   /* AutoIncrementKeyField */
    AField:AutoIncrementKeyIndex := Self
    ::FAutoIncrementKeyField := AField
  CASE 2   /* UniqueKeyField */
    IF AField:FieldMethodType = 'A'
      RAISE ERROR "Array of Fields Not Allowed as Unique/AutoIncrement Index Key..."
    ENDIF
    AField:UniqueKeyIndex := Self
    ::FUniqueKeyField := AField
  CASE 3   /* KeyField */
    IF AField:IsDerivedFrom( "TStringField" ) .AND. Len( AField ) = 0
      RAISE ERROR ::FTable:ClassName + ": Master key field <" + AField:Name + ">  needs a size > 0..."
    ENDIF
    AField:KeyIndex := Self
    ::FKeyField := AField
    EXIT
  END

RETURN

/*
  SetScope
  Teo. Mexico 2008
*/
METHOD FUNCTION SetScope( value ) CLASS TIndex
  LOCAL oldValue := { ::FScopeTop, ::FScopeBottom }

  ::FScopeTop := value
  ::FScopeBottom := value

RETURN oldValue

/*
  SetScopeBottom
  Teo. Mexico 2008
*/
METHOD FUNCTION SetScopeBottom( value ) CLASS TIndex
  LOCAL oldValue := ::FScopeBottom

  ::FScopeBottom := value

RETURN oldValue

/*
  SetScopeTop
  Teo. Mexico 2008
*/
METHOD FUNCTION SetScopeTop( value ) CLASS TIndex
  LOCAL oldValue := ::FScopeTop

  ::FScopeTop := value

RETURN oldValue

/*
  End Class TIndex
*/
