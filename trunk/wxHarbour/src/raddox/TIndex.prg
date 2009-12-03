/*
 * $Id$
 */

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
CLASS TIndex FROM WXHBaseClass
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
	DATA FScopeBottomFields INIT {=>}
	DATA FScopeTop
	DATA FScopeTopFields INIT {=>}
	DATA FTable
	DATA FUniqueKeyField
	METHOD DbGoBottomTop( n )
	METHOD GetAutoIncrement INLINE ::FAutoIncrementKeyField != NIL
	METHOD GetField
	METHOD GetArrayKeyFields INLINE ::KeyField:FieldMethod
	METHOD GetScope INLINE iif( ::FScopeBottom == NIL .AND. ::FScopeTop == NIL, NIL, { ::FScopeTop, ::FScopeBottom } )
	METHOD GetScopeBottom INLINE iif( !Empty( ::FScopeBottom ), ::FScopeBottom, "" )
	METHOD GetScopeTop INLINE iif( !Empty( ::FScopeTop ), ::FScopeTop, "" )
	METHOD GetUnique INLINE ::FUniqueKeyField != NIL
	METHOD ScopeFieldGet( aKeys, cField, value, hScope )
	METHOD SetCaseSensitive( CaseSensitive ) INLINE ::FCaseSensitive := CaseSensitive
	METHOD SetCustom( Custom )
	METHOD SetDescend( Descend ) INLINE ::FDescend := Descend
	METHOD SetField( nIndex, XField )
	METHOD SetForKey( ForKey ) INLINE ::FForKey := ForKey
	METHOD SetKeyValueFromArray( aKeys )
	METHOD SetName( Name ) INLINE ::FName := Name
	METHOD SetScope( value )
	METHOD SetScopeBottom( value )
	METHOD SetScopeTop( value )
PROTECTED:
PUBLIC:

	METHOD New( Table ) CONSTRUCTOR

	METHOD AddIndex
	METHOD BaseSeek( direction, keyValue, lSoftSeek )
	METHOD CustomKeyDel
	METHOD CustomKeyUpdate
	METHOD DbGoBottom INLINE ::DbGoBottomTop( 1 )
	METHOD DbGoTop INLINE ::DbGoBottomTop( 0 )
	METHOD DbSkip( numRecs )
	METHOD ExistKey( keyValue )
	METHOD InsideScope()
	METHOD MasterKeyString()
	METHOD RawSeek( Value )

	METHOD ScopeField( cField, value )
	METHOD ScopeBottomField( cField, value )
	METHOD ScopeTopField( cField, value )

	PROPERTY Scope READ GetScope WRITE SetScope
	PROPERTY ScopeBottom READ GetScopeBottom WRITE SetScopeBottom
	PROPERTY ScopeTop READ GetScopeTop WRITE SetScopeTop
	
	METHOD Seek( keyValue, lSoftSeek ) INLINE ::BaseSeek( 0, keyValue, lSoftSeek )
	METHOD SeekLast( keyValue, lSoftSeek ) INLINE ::BaseSeek( 1, keyValue, lSoftSeek )

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
METHOD New( Table, name, indexType, curClass ) CLASS TIndex
	LOCAL curClassname

	::FTable := Table

	::Name := name

	curClassname := iif( curClass = NIL, ::FTable:ClassName(), curClass:ClassName() )
	
	IF !HB_HHasKey( ::FTable:IndexList, curClassname )
		::FTable:IndexList[ curClassname ] := HB_HSetCaseMatch( {=>}, .F. )
	ENDIF

	::FTable:IndexList[ curClassname, name ] := Self

	IF "PRIMARY" = indexType
		::FTable:PrimaryIndexList[ curClassname ] := name
	ENDIF

RETURN Self

/*
	AddIndex
	Teo. Mexico 2008
*/
METHOD AddIndex( cMasterKeyField, ai, un, cKeyField, ForKey, cs, de/*, cu*/ )

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
//	 ::Custom := iif( HB_ISNIL( cu ), .F. , cu )

RETURN Self

/*
	BaseSeek
	Teo. Mexico 2007
*/
METHOD FUNCTION BaseSeek( direction, keyValue, lSoftSeek ) CLASS TIndex

	IF AScan( {dsEdit,dsInsert}, ::FTable:State ) > 0
		::FTable:Post()
	ENDIF

	keyValue := ::KeyField:AsIndexKeyVal( keyValue )

	IF direction = 0
		::FTable:Alias:Seek( ::MasterKeyString + iif( ::FCaseSensitive, keyValue, Upper( keyValue ) ), ::FName, lSoftSeek )
	ELSE
		::FTable:Alias:SeekLast( ::MasterKeyString + iif( ::FCaseSensitive, keyValue, Upper( keyValue ) ), ::FName, lSoftSeek )
	ENDIF

	::FTable:GetCurrentRecord()

RETURN ::FTable:Found()

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

	Value :=	::UniqueKeyField:AsString

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

	::FTable:GetCurrentRecord()

RETURN

/*
	ExistKey
	Teo. Mexico 2007
*/
METHOD FUNCTION ExistKey( keyValue ) CLASS TIndex
RETURN ::FTable:Alias:ExistKey( ::MasterKeyString + iif( ::FCaseSensitive, ;
	keyValue, Upper( keyValue ) ), ::FName, ::FTable:RecNo )

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
METHOD FUNCTION InsideScope() CLASS TIndex
	LOCAL masterKeyString
	LOCAL scopeVal
	LOCAL keyValue
	
	IF ::FTable:Alias:Eof() .OR. ::FTable:Alias:Bof()
		RETURN .F.
	ENDIF

	keyValue := ::FTable:Alias:KeyVal( ::FName )
	
	IF keyValue == NIL
		RETURN .F.
	ENDIF

	masterKeyString := ::MasterKeyString
	
	scopeVal := ::GetScope()
	
	IF scopeVal == NIL
		RETURN masterKeyString == "" .OR. keyValue = masterKeyString
	ENDIF
	
RETURN keyValue >= ( masterKeyString + ::GetScopeTop() ) .AND. ;
			 keyValue <= ( masterKeyString + ::GetScopeBottom() )

/*
	MasterKeyString
	Teo. Mexico 2009
*/
METHOD FUNCTION MasterKeyString() CLASS TIndex

	IF ::FMasterKeyField == NIL
		RETURN "" //::FTable:PrimaryMasterKeyString
	ENDIF

RETURN::FMasterKeyField:AsIndexKeyVal

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
	ScopeBottomField
	Teo. Mexico 2009
*/
METHOD FUNCTION ScopeBottomField( cField, value ) CLASS TIndex
	LOCAL aKeys := {}
	LOCAL Result := ::ScopeFieldGet( aKeys, cField, value, ::FScopeBottomFields )
	::SetScopeBottom( aKeys )
RETURN Result

/*
	ScopeField
	Teo. Mexico 2009
*/
METHOD FUNCTION ScopeField( cField, value ) CLASS TIndex
RETURN { ::ScopeTopField( cField, value ), ::ScopeBottomField( cField, value ) }

/*
	ScopeFieldGet
	Teo. Mexico 2009
*/
METHOD FUNCTION ScopeFieldGet( aKeys, cField, value, hScope ) CLASS TIndex
	LOCAL Result
	LOCAL AField := ::FTable:FieldByName( cField )
	LOCAL aFields
	LOCAL fld
	
	aFields := ::GetArrayKeyFields()
	
	IF ValType( aFields ) = "A" .AND.	 ValType( AField ) = "O"
		FOR EACH fld IN aFields
			IF !HB_HHasKey( hScope, AField:Name )
				hScope[ AField:Name ] := NIL
			ENDIF
			IF !HB_HHasKey( hScope, fld:Name )
				EXIT
			ENDIF
			IF fld == AField
				Result := hScope[ AField:Name ]
				AAdd( aKeys, value )
			ELSE
				AAdd( aKeys, hScope[ fld:Name ] )
			ENDIF
		NEXT
	ENDIF

RETURN Result

/*
	ScopeTopField
	Teo. Mexico 2009
*/
METHOD FUNCTION ScopeTopField( cField, value ) CLASS TIndex
	LOCAL aKeys := {}
	LOCAL Result := ::ScopeFieldGet( aKeys, cField, value, ::FScopeTopFields )
	::SetScopeTop( aKeys )
RETURN Result

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
		IF AField == NIL
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
		AField:FieldMethod	:= XField
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

	IF AField == NIL
		RETURN
	ENDIF

	SWITCH nIndex
	CASE 0	 /* MasterKeyField */
		::FMasterKeyField := AField
		EXIT
	CASE 1	 /* AutoIncrementKeyField */
		AField:AutoIncrementKeyIndex := Self
		::FAutoIncrementKeyField := AField
	CASE 2	 /* UniqueKeyField */
		IF AField:FieldMethodType = 'A'
			RAISE ERROR "Array of Fields Not Allowed as Unique/AutoIncrement Index Key..."
		ENDIF
		AField:UniqueKeyIndex := Self
		::FUniqueKeyField := AField
	CASE 3	 /* KeyField */
		IF AField:IsDerivedFrom( "TStringField" ) .AND. Len( AField ) = 0
			RAISE ERROR ::FTable:ClassName + ": Master key field <" + AField:Name + ">	needs a size > zero..."
		ENDIF
		AField:KeyIndex := Self
		::FKeyField := AField
		EXIT
	END

RETURN

/*
	SetKeyValueFromArray
	Teo. Mexico 2009
*/
METHOD FUNCTION SetKeyValueFromArray( aKeys, slot ) CLASS TIndex
	LOCAL keyValue := ""
	LOCAL aFields
	LOCAL AField
	LOCAL value
	LOCAL key
	
	aFields := ::GetArrayKeyFields()
	
	IF Valtype( aFields ) = "A"
		FOR EACH AField IN aFields
			key := NIL
			IF AField:__enumIndex() <= Len( aKeys )
				key := aKeys[ AField:__enumIndex() ]
				IF key == NIL
					EXIT
				ENDIF
				value := AField:FieldCodeBlock:Eval( key )
				keyValue += value
			ENDIF
			IF slot $ "T="
				::FScopeTopFields[ AField:Name ] := key
			ENDIF
			IF slot $ "B="
				::FScopeBottomFields[ AField:Name ] := key
			ENDIF
		NEXT
	ENDIF

RETURN keyValue

/*
	SetScope
	Teo. Mexico 2008
*/
METHOD FUNCTION SetScope( value ) CLASS TIndex
	LOCAL oldValue := { ::FScopeTop, ::FScopeBottom }
	
	IF ValType( value ) = "A" // scope by field
		value := ::SetKeyValueFromArray( value, "=" )
	ENDIF

	::FScopeTop := value
	::FScopeBottom := value

RETURN oldValue

/*
	SetScopeBottom
	Teo. Mexico 2008
*/
METHOD FUNCTION SetScopeBottom( value ) CLASS TIndex
	LOCAL oldValue := ::FScopeBottom
	
	IF ValType( value ) = "A" // scope by field
		value := ::SetKeyValueFromArray( value, "B" )
	ENDIF

	::FScopeBottom := value

RETURN oldValue

/*
	SetScopeTop
	Teo. Mexico 2008
*/
METHOD FUNCTION SetScopeTop( value ) CLASS TIndex
	LOCAL oldValue := ::FScopeTop
	
	IF ValType( value ) = "A" // scope by field
		value := ::SetKeyValueFromArray( value, "T" )
	ENDIF

	::FScopeTop := value

RETURN oldValue

/*
	End Class TIndex
*/
