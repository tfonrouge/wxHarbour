/*
 * $Id$
 */

/*
	TIndex
	Teo. Mexico 2007
*/

#include "hbclass.ch"
#include "dbinfo.ch"

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
	DATA FScopeTop
	DATA FTable
	DATA FUniqueKeyField
	METHOD DbGoBottomTop( n )
	METHOD GetArrayKeyFields INLINE ::KeyField:FieldMethod
	METHOD GetAutoIncrement INLINE ::FAutoIncrementKeyField != NIL
	METHOD GetField
	METHOD GetIdxAlias()
	METHOD GetKeyIndexVal()
	METHOD GetMasterKeyIndexVal()
	METHOD GetScope INLINE iif( ::FScopeBottom == NIL .AND. ::FScopeTop == NIL, NIL, { ::FScopeTop, ::FScopeBottom } )
	METHOD GetScopeBottom INLINE iif( !Empty( ::FScopeBottom ), ::FScopeBottom, "" )
	METHOD GetScopeTop INLINE iif( !Empty( ::FScopeTop ), ::FScopeTop, "" )
	METHOD GetUnique INLINE ::FUniqueKeyField != NIL
	METHOD SetCaseSensitive( CaseSensitive ) INLINE ::FCaseSensitive := CaseSensitive
	METHOD SetCustom( Custom )
	METHOD SetDescend( Descend ) INLINE ::FDescend := Descend
	METHOD SetField( nIndex, XField )
	METHOD SetForKey( ForKey ) INLINE ::FForKey := ForKey
	METHOD SetIdxAlias( alias )
	METHOD SetName( Name ) INLINE ::FName := Name
	METHOD SetScope( value )
	METHOD SetScopeBottom( value )
	METHOD SetScopeTop( value )
PROTECTED:
	METHOD GetAlias()
PUBLIC:

	DATA FIdxAlias INIT .F.
	DATA useIndex
	DATA temporary INIT .F.

	METHOD New( Table, name, indexType, curClass ) CONSTRUCTOR

	METHOD AddIndex
	METHOD BaseSeek( direction, keyValue, lSoftSeek )
	METHOD CustomKeyDel
	METHOD CustomKeyUpdate
	METHOD DbGoBottom INLINE ::DbGoBottomTop( 1 )
	METHOD DbGoTop INLINE ::DbGoBottomTop( 0 )
	METHOD DbSkip( numRecs )
	METHOD ExistKey( keyValue )
	METHOD Get4Seek( blk, keyVal, softSeek )
	METHOD Get4SeekLast( blk, keyVal, softSeek )
	METHOD InsideScope()
	
	METHOD OrdCondSet( ... ) INLINE ::FTable:OrdCondSet( ... )
	METHOD OrdCreate( ... ) INLINE ::FTable:OrdCreate( ... )
	METHOD OrdKeyNo() INLINE ::GetAlias():OrdKeyNo()
	
	METHOD RawGet4Seek( direction, blk, keyVal, softSeek )
	METHOD RawSeek( Value )

	PROPERTY IdxAlias READ GetIdxAlias WRITE SetIdxAlias
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
	PROPERTY KeyIndexVal READ GetKeyIndexVal
	PROPERTY UniqueKeyField INDEX 2 READ GetField WRITE SetField
	PROPERTY Name READ FName WRITE SetName
	PROPERTY MasterKeyField INDEX 0 READ GetField WRITE SetField
	PROPERTY MasterKeyIndexVal READ GetMasterKeyIndexVal
	PROPERTY Table READ FTable
	PROPERTY Unique READ GetUnique
ENDCLASS

/*
	New
	Teo. Mexico 2006
*/
METHOD New( Table, name, indexType, curClass ) CLASS TIndex

	::FTable := Table

	::Name := name

	IF curClass = NIL
		curClass := ::FTable:ClassName()
	ENDIF
	
	IF !HB_HHasKey( ::FTable:IndexList, curClass )
		::FTable:IndexList[ curClass ] := HB_HSetCaseMatch( {=>}, .F. )
	ENDIF

	::FTable:IndexList[ curClass, name ] := Self

	IF "PRIMARY" = indexType
		::FTable:PrimaryIndexList[ curClass ] := name
	ENDIF

RETURN Self

/*
	AddIndex
	Teo. Mexico 2008
*/
METHOD AddIndex( cMasterKeyField, ai, un, cKeyField, ForKey, cs, de, useIndex, temporary /*, cu*/ )

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
	::useIndex := useIndex
	::temporary := temporary == .T.
//	 ::Custom := iif( HB_ISNIL( cu ), .F. , cu )

	/* check for a valid index  order */
	IF ::FTable:Alias:OrdNumber( ::Name ) = 0
		//RAISE ERROR "Order Name not valid '" + ::Name + "'"
		IF ! ::FTable:CreateIndex( Self )
			RAISE ERROR "Failure to create Index '" + ::Name + "'"
		ENDIF
	ENDIF

RETURN Self

/*
	BaseSeek
	Teo. Mexico 2007
*/
METHOD FUNCTION BaseSeek( direction, keyValue, lSoftSeek ) CLASS TIndex
	LOCAL alias

	alias := ::GetAlias()

	IF AScan( {dsEdit,dsInsert}, ::FTable:State ) > 0
		::FTable:Post()
	ENDIF

	keyValue := ::KeyField:AsIndexKeyVal( keyValue )

	IF direction = 0
		alias:Seek( ::MasterKeyIndexVal + iif( ::FCaseSensitive, keyValue, Upper( keyValue ) ), ::FName, lSoftSeek )
	ELSE
		alias:SeekLast( ::MasterKeyIndexVal + iif( ::FCaseSensitive, keyValue, Upper( keyValue ) ), ::FName, lSoftSeek )
	ENDIF

	::FTable:GetCurrentRecord( ::IdxAlias )

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
	LOCAL masterKeyIndexVal := ::MasterKeyIndexVal
	LOCAL alias
	
	alias := ::GetAlias()
	
	IF n = 0
		IF ::GetScopeTop() == ::GetScopeBottom()
			alias:Seek( masterKeyIndexVal + ::GetScopeTop(), ::FName )
		ELSE
			alias:Seek( masterKeyIndexVal + ::GetScopeTop(), ::FName, .T. )
		ENDIF
	ELSE
		IF ::GetScopeTop() == ::GetScopeBottom()
			alias:SeekLast( masterKeyIndexVal + ::GetScopeBottom() , ::FName )
		ELSE
			alias:SeekLast( masterKeyIndexVal + ::GetScopeBottom() , ::FName, .T. )
		ENDIF
	ENDIF
	
	::FTable:GetCurrentRecord( ::IdxAlias )

RETURN ::FTable:Found()

/*
	DbSkip
	Teo. Mexico 2007
*/
METHOD PROCEDURE DbSkip( numRecs ) CLASS TIndex

	::GetAlias():DbSkip( numRecs, ::FName )

	::FTable:GetCurrentRecord( ::IdxAlias )

RETURN

/*
	ExistKey
	Teo. Mexico 2007
*/
METHOD FUNCTION ExistKey( keyValue ) CLASS TIndex
RETURN ::GetAlias():ExistKey( ::MasterKeyIndexVal + iif( ::FCaseSensitive, ;
	keyValue, Upper( keyValue ) ), ::FName, ;
		{||
			IF ::IdxAlias = NIL
				RETURN ::FTable:RecNo 
			ENDIF
			RETURN ( ::IdxAlias:workArea )->RecNo
		} )
	
/*
	Get4Seek
	Teo. Mexico 2009
*/
METHOD FUNCTION Get4Seek( blk, keyVal, softSeek ) CLASS TIndex
RETURN ::RawGet4Seek( 1, blk, keyVal, softSeek )

/*
	Get4SeekLast
	Teo. Mexico 2009
*/
METHOD FUNCTION Get4SeekLast( blk, keyVal, softSeek ) CLASS TIndex
RETURN ::RawGet4Seek( 0, blk, keyVal, softSeek )

/*
	GetAlias
	Teo. Mexico 2010
*/
METHOD FUNCTION GetAlias() CLASS TIndex
	IF ::IdxAlias = NIL
		RETURN ::FTable:Alias
	ENDIF
RETURN ::IdxAlias

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
	GetIdxAlias
	Teo. Mexico 2010
*/
METHOD FUNCTION GetIdxAlias() CLASS TIndex
	IF ::temporary
		RETURN ::FTable:aliasTmp
	ENDIF
RETURN ::FTable:aliasIdx

/*
	GetKeyIndexVal
	Teo. Mexico 2009
*/
METHOD FUNCTION GetKeyIndexVal() CLASS TIndex

	IF ::FKeyField == NIL
		RETURN "" //::FTable:PrimaryMasterKeyString
	ENDIF

RETURN iif( ::FCaseSensitive, ::FKeyField:AsIndexKeyVal, Upper( ::FKeyField:AsIndexKeyVal ) )

/*
	GetMasterKeyIndexVal
	Teo. Mexico 2009
*/
METHOD FUNCTION GetMasterKeyIndexVal() CLASS TIndex

	IF ::FMasterKeyField == NIL
		RETURN "" //::FTable:PrimaryMasterKeyString
	ENDIF

RETURN ::FMasterKeyField:AsIndexKeyVal

/*
	InsideScope
	Teo. Mexico 2008
*/
METHOD FUNCTION InsideScope() CLASS TIndex
	LOCAL masterKeyIndexVal
	LOCAL scopeVal
	LOCAL keyValue
	
	IF ::FTable:Alias:Eof() .OR. ::FTable:Alias:Bof()
		RETURN .F.
	ENDIF
	
	keyValue := ::GetAlias():KeyVal( ::FName )
	
	IF keyValue == NIL
		RETURN .F.
	ENDIF

	masterKeyIndexVal := ::MasterKeyIndexVal
	
	scopeVal := ::GetScope()
	
	IF scopeVal == NIL
		RETURN masterKeyIndexVal == "" .OR. keyValue = masterKeyIndexVal
	ENDIF
	
RETURN keyValue >= ( masterKeyIndexVal + ::GetScopeTop() ) .AND. ;
			 keyValue <= ( masterKeyIndexVal + ::GetScopeBottom() )

/*
	RawGet4Seek
	Teo. Mexico 2009
*/
METHOD FUNCTION RawGet4Seek( direction, blk, keyVal, softSeek ) CLASS TIndex

	IF keyVal = NIL
		keyVal := ::MasterKeyIndexVal
	ELSE
		keyVal := ::MasterKeyIndexVal + keyVal
	ENDIF

RETURN ::GetAlias():RawGet4Seek( direction, blk, keyVal, ::FName, softSeek )

/*
	RawSeek
	Teo. Mexico 2008
*/
METHOD FUNCTION RawSeek( Value ) CLASS TIndex

	IF AScan( {dsEdit,dsInsert}, ::FTable:State ) > 0
		::FTable:Post()
	ENDIF

	::GetAlias():Seek( Value, ::FName )

	::FTable:GetCurrentRecord( ::IdxAlias )

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
	OTHERWISE
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
		IF AField:FieldMethodType = 'A'
			RAISE ERROR "Array of Fields Not Allowed as AutoIncrement Index Key..."
		ENDIF
		AField:AutoIncrementKeyIndex := Self
		::FAutoIncrementKeyField := AField
	CASE 2	 /* UniqueKeyField */
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
	SetIdxAlias
	Teo. Mexico 2010
*/
METHOD PROCEDURE SetIdxAlias( alias ) CLASS TIndex
	IF ::temporary
		::FTable:aliasTmp := alias
	ELSE
		::FTable:aliasIdx := alias
	ENDIF
RETURN

/*
	SetScope
	Teo. Mexico 2008
*/
METHOD FUNCTION SetScope( value ) CLASS TIndex
	LOCAL oldValue := { ::FScopeTop, ::FScopeBottom }
	
	IF ValType( value ) = "A" // scope by field
		::FScopeTop := value[ 1 ]
		::FScopeBottom := value[ 2 ]
	ELSE
		::FScopeTop := value
		::FScopeBottom := value
	ENDIF

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
