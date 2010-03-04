/*
 * $Id$
 *
 * TField
 *
 */

#include "wxharbour.ch"
#include "xerror.ch"

/*
	TODO: Check for a correct validation for FieldExpression, it can contain any valid
				Harbour statement/formula, and loose checking is done on SetFieldMethod
*/

#xcommand RAISE TFIELD <name> ERROR <cDescription> => ;
					RAISE ERROR E"\nTable: <" + ::FTable:ClassName() + ">, FieldExpression: <" + <name> + ">" + ;
											E"\n" + ;
											<cDescription> + E"\n" ;
								SUBSYSTEM ::ClassName + "<" + ::Name + ">"	;
								OPERATION E"\n" + ProcName(0)+"(" + LTrim(Str(ProcLine(0))) + ")"

/*
	TField
	Teo. Mexico 2009
*/
CLASS TField FROM WXHBaseClass
PRIVATE:

	DATA FActive	INIT .F.
	DATA FAutoIncrementKeyIndex
	DATA FDataOfValidValues
	DATA FDescription INIT ""
	DATA FFieldCodeBlock									// Code Block
	DATA FFieldWriteBlock									// Code Block to do WRITE
	DATA FFieldExpression									// Literal Field expression on the Database
	DATA FPickList											// codeblock to help to pick a value
	DATA FGroup														// A Text label for grouping
	DATA FIsMasterFieldComponent INIT .F. // Field is a MasterField component
	DATA FKeyIndex
	DATA FLabel
	DATA FModStamp	INIT .F.							// Field is automatically mantained (dbf layer)
	DATA FPrimaryKeyComponent INIT .F.		// Field is included in a Array of fields for a Primary Index Key
	DATA FPublished INIT .T.							// Logical: Appears in user field selection
	DATA FReadOnly	INIT .F.
	DATA FRequired INIT .F.
	DATA FUniqueKeyIndex
	DATA FUsingField						// Field used on Calculated Field
	METHOD GetAutoIncrement INLINE ::FAutoIncrementKeyIndex != NIL
	METHOD GetAutoIncrementValue
	METHOD GetFieldMethod
	METHOD GetIsKeyIndex INLINE ::FKeyIndex != NIL
	METHOD GetIsPrimaryKeyField( masterSourceBaseClass ) INLINE ::Table:GetPrimaryKeyField( masterSourceBaseClass ) == Self
	METHOD GetLabel INLINE iif( ::FLabel == NIL, ::FName, ::FLabel )
	METHOD GetReadOnly INLINE ::FReadOnly
	METHOD GetUnique INLINE ::FUniqueKeyIndex != NIL
	METHOD SetAutoIncrementKeyIndex( Index ) INLINE ::FAutoIncrementKeyIndex := Index
	METHOD SetDBS_DEC( dec ) INLINE ::FDBS_DEC := dec
	METHOD SetDBS_LEN( len ) INLINE ::FDBS_LEN := len
	METHOD SetDescription( Description ) INLINE ::FDescription := Description
	METHOD SetFieldMethod( FieldMethod )
	METHOD SetGroup( Group ) INLINE ::FGroup := Group
	METHOD SetIsMasterFieldComponent( IsMasterFieldComponent )
	METHOD SetKeyIndex( Index ) INLINE ::FKeyIndex := Index
	METHOD SetLabel( label ) INLINE ::FLabel := label
	METHOD SetName( name )
	METHOD SetPickList( pickList )
	METHOD SetPrimaryKeyComponent( PrimaryKeyComponent )
	METHOD SetPublished( Published ) INLINE ::FPublished := Published
	METHOD SetReadOnly( ReadOnly ) INLINE ::FReadOnly := ReadOnly
	METHOD SetUniqueKeyIndex( Index ) INLINE ::FUniqueKeyIndex := Index
	METHOD SetUsingField( usingField )

PROTECTED:

	DATA FBuffer
	DATA FCalculated INIT .F.
	DATA FDefaultValue
	DATA FDBS_DEC
	DATA FDBS_LEN
	DATA FDBS_NAME
	DATA FDBS_TYPE
	DATA FEvtOnBeforeChange
	DATA FFieldArrayIndex								// Array of TField's indexes in FieldList
	DATA FFieldMethodType
	DATA FFieldReadBlock								// Code Block to do READ
	DATA FName INIT ""
	DATA FTable
	DATA FTableBaseClass
	DATA FType INIT "TField"
	DATA FValType INIT "U"
	DATA FWrittenValue
	
	METHOD GetChanged()
	METHOD GetDefaultValue
	METHOD GetEmptyValue BLOCK {|| NIL }
	METHOD GetFieldArray()
	METHOD GetUndoValue()
	METHOD SetAsString( string ) INLINE ::SetAsVariant( string )
	METHOD SetBuffer( value )
	METHOD SetDefaultValue( DefaultValue ) INLINE ::FDefaultValue := DefaultValue
	METHOD SetRequired( Required ) INLINE ::FRequired := Required

PUBLIC:

	DATA nameAlias
	DATA Picture

	CONSTRUCTOR New( Table )

	METHOD AddFieldMessage()
	METHOD AsIndexKeyVal( value )
	METHOD Delete
	METHOD GetAsString INLINE "<" + ::ClassName + ">"
	METHOD GetAsVariant( ... )
	METHOD GetBuffer()
	METHOD GetEditText
	METHOD GetData()
	METHOD GetValidValues
	METHOD IsReadOnly() INLINE ::FReadOnly .OR. ::FCalculated .OR. ( ::FTable:State != dsBrowse .AND. ::AutoIncrement )
	METHOD IsValid( showAlert )
	METHOD OnPickList( param )
	METHOD Reset()
	METHOD SetAsVariant( rawValue )
	METHOD SetData( Value )
	METHOD SetEditText( Text )
	METHOD ValidateFieldInfo VIRTUAL

	PROPERTY AsString READ GetAsString WRITE SetAsString
	PROPERTY AsVariant READ GetAsVariant WRITE SetAsVariant
	PROPERTY Calculated READ FCalculated
	PROPERTY DisplayText READ GetEditText
	PROPERTY EmptyValue READ GetEmptyValue
	PROPERTY PickList READ FPickList WRITE SetPickList
	PROPERTY IsKeyIndex READ GetIsKeyIndex
	PROPERTY IsMasterFieldComponent READ FIsMasterFieldComponent WRITE SetIsMasterFieldComponent
	PROPERTY IsPrimaryKeyField READ GetIsPrimaryKeyField
	PROPERTY Text READ GetEditText WRITE SetEditText
	PROPERTY UndoValue READ GetUndoValue
	PROPERTY Value READ GetAsVariant WRITE SetAsVariant
	PROPERTY WrittenValue READ FWrittenValue

PUBLISHED:
	
	DATA IncrementBlock
	DATA OnGetIndexKeyVal
	/*
	 * Event holders
	 */
	DATA OnGetText			// Params: Sender: TField, Text: String
	DATA OnSearch			// Search in indexed field
	DATA OnSetText			// Params: Sender: TField, Text: String
	DATA OnSetValue			// Parama:
	DATA OnAfterChange				// Params: Sender: TField
	DATA OnValidate			// Params: Sender: TField
	
	DATA ValidValues

	PROPERTY AutoIncrement READ GetAutoIncrement
	PROPERTY AutoIncrementKeyIndex READ FAutoIncrementKeyIndex WRITE SetAutoIncrementKeyIndex
	PROPERTY Changed READ GetChanged()
	PROPERTY DBS_DEC READ FDBS_DEC WRITE SetDBS_DEC
	PROPERTY DBS_LEN READ FDBS_LEN WRITE SetDBS_LEN
	PROPERTY DBS_NAME READ FDBS_NAME
	PROPERTY DBS_TYPE READ FDBS_TYPE
	PROPERTY DefaultValue READ GetDefaultValue WRITE SetDefaultValue
	PROPERTY Description READ FDescription WRITE SetDescription
	PROPERTY FieldArray READ GetFieldArray WRITE SetFieldMethod
	PROPERTY FieldCodeBlock READ FFieldCodeBlock WRITE SetFieldMethod
	PROPERTY FieldExpression READ FFieldExpression WRITE SetFieldMethod
	PROPERTY FieldMethod READ GetFieldMethod WRITE SetFieldMethod
	PROPERTY FieldMethodType READ FFieldMethodType
	PROPERTY FieldReadBlock READ FFieldReadBlock
	PROPERTY Group READ FGroup WRITE SetGroup
	PROPERTY KeyIndex READ FKeyIndex WRITE SetKeyIndex
	PROPERTY Label READ GetLabel WRITE SetLabel
	PROPERTY Name READ FName WRITE SetName
	PROPERTY PrimaryKeyComponent READ FPrimaryKeyComponent WRITE SetPrimaryKeyComponent
	PROPERTY Published READ FPublished WRITE SetPublished
	PROPERTY ReadOnly READ GetReadOnly WRITE SetReadOnly
	PROPERTY Required READ FRequired WRITE SetRequired
	PROPERTY Table READ FTable
	PROPERTY TableBaseClass READ FTableBaseClass
	PROPERTY Type READ FType
	PROPERTY Unique READ GetUnique
	PROPERTY UniqueKeyIndex READ FUniqueKeyIndex WRITE SetUniqueKeyIndex
	PROPERTY UsingField READ FUsingField WRITE SetUsingField
	PROPERTY ValType READ FValType

ENDCLASS

/*
	New
	Teo. Mexico 2006
*/
METHOD New( Table ) CLASS TField

	::FTable := Table
	::FTableBaseClass := Table:BaseClass

	/* Set default field name */
	/*

	n := 0
	::FName := ""

	FOR EACH e IN ::FTable:FieldList
		IF e:ClassName == ::ClassName
			n++
		ENDIF
	NEXT

	::FName := SubStr( ::ClassName, 2 ) + LTrim( Str( n ) )
	*/

	::FActive := .T.

RETURN Self

/*
	AddFieldMessage
	Teo. Mexico 2010
*/
METHOD PROCEDURE AddFieldMessage() CLASS TField
	::FTable:AddFieldMessage( ::Name, Self )
RETURN

/*
	AsIndexKeyVal
	Teo. Mexico 2010
*/
METHOD FUNCTION AsIndexKeyVal( value ) CLASS TField
	LOCAL AField
	LOCAL i

	IF value == NIL
		IF ::FFieldMethodType = "A"
			value := ""
			FOR EACH i IN ::FFieldArrayIndex
				AField := ::FTable:FieldList[ i ]
				value += AField:AsIndexKeyVal
			NEXT
		ELSE
			value := ::GetAsVariant()
		ENDIF
	ENDIF
	
	IF ::OnGetIndexKeyVal != NIL
		value := ::OnGetIndexKeyVal:Eval( value )
	ENDIF

	SWITCH ValType( value )
	CASE 'C'
	CASE 'M'
		RETURN value
	CASE 'D'
		RETURN DToS( value )
	OTHERWISE
		value := AsString( value )
	ENDSWITCH

RETURN value

/*
	Delete
	Teo. Mexico 2009
*/
METHOD PROCEDURE Delete CLASS TField
	LOCAL errObj

	IF AScan( { dsEdit, dsInsert }, ::Table:State ) = 0
		::Table:Table_Not_In_Edit_or_Insert_mode()
		RETURN
	ENDIF

	IF !::FFieldMethodType = 'C' .OR. ::FCalculated .OR. ::FFieldWriteBlock == NIL .OR. ::FModStamp
		RETURN
	ENDIF

	BEGIN SEQUENCE WITH {|oErr| Break( oErr ) }

		::Table:Alias:Eval( ::FFieldWriteBlock, ::EmptyValue() )

		::Reset()

	RECOVER USING errObj

		SHOW ERROR errObj

	END

RETURN

/*
	GetAsVariant
	Teo. Mexico 2006
*/
METHOD FUNCTION GetAsVariant( ... ) CLASS TField
	LOCAL AField
	LOCAL i
	LOCAL Result
	LOCAL value

	//::SyncToContainerField()
	
	SWITCH ::FFieldMethodType
	CASE "A"
		/*
		 * This will ONLY work when all the items are of TStringField type
		 */
		Result := ""
		FOR EACH i IN ::FFieldArrayIndex
			AField := ::FTable:FieldList[ i ]
			value := AField:GetAsVariant()
			IF !HB_IsString( value )
				Result += AField:AsString
			ELSE
				Result += value
			ENDIF
		NEXT
		EXIT
	CASE "B"
		IF ::FUsingField == NIL
			Result := ::FTable:Alias:Eval( ::FFieldCodeBlock, ::FTable )
			IF HB_IsObject( Result )
				Result := Result:Value
			ENDIF
		ELSE
			Result := ::FFieldCodeBlock:Eval( ::FUsingField:Value )
		ENDIF
			EXIT
	CASE "C"
		IF ::FCalculated
			IF ::FFieldReadBlock == NIL
				IF __ObjHasMsg( Self:FTable, "CalcField_" + ::FName )
					::FFieldReadBlock := &("{|o,...|" + "o:CalcField_" + ::FName + "( ... ) }")
				ELSE
					IF __ObjHasMsg( Self:FTable:MasterSource, "CalcField_" + ::FName )
						::FFieldReadBlock := &("{|o|" + "o:MasterSource:CalcField_" + ::FName + " }")
					ELSE
						IF __ObjHasMsg( Self:FTable:MasterSource, "Field_" + ::FName )
							::FFieldReadBlock := &("{|o|" + "o:MasterSource:Field_" + ::FName + ":GetAsVariant() }")
						ELSE
							IF Empty( ::FFieldExpression )
								RAISE TFIELD ::Name ERROR "Unable to Solve Undefined Calculated Field: "
							ELSEIF ::IsDerivedFrom("TObjectField")
								::FFieldReadBlock := {|| ::LinkedTable:Value }
							ELSE
								::FFieldReadBlock := &("{|| " + ::FFieldExpression + " }")
							ENDIF
						ENDIF
					ENDIF
				ENDIF
			ENDIF
			//Result := ::FFieldReadBlock:Eval( ::FTable )
			Result := ::FTable:Alias:Eval( ::FFieldReadBlock, ::FTable, ... )
		ELSE
			Result := ::GetBuffer()
		ENDIF
		EXIT
	OTHERWISE
		RAISE TFIELD ::Name ERROR "GetAsVariant(): Field Method Type not supported: " + ::FFieldMethodType
	END

RETURN Result

/*
	GetAutoIncrementValue
	Teo. Mexico 2009
*/
METHOD FUNCTION GetAutoIncrementValue CLASS TField
	LOCAL AIndex
	LOCAL value

	AIndex := ::FAutoIncrementKeyIndex

	value := ::Table:Alias:Get4SeekLast(	{|| ::FieldReadBlock:Eval() }, AIndex:MasterKeyIndexVal, AIndex:TagName )

	IF ::IncrementBlock = NIL
		value := Inc( value )
	ELSE
		value := ::IncrementBlock:Eval( value )
	ENDIF

RETURN value

/*
	GetBuffer
	Teo. Mexico 2009
*/
METHOD FUNCTION GetBuffer() CLASS TField
	LOCAL i

	/* FieldArray's doesn't have a absolute FBuffer */
	IF ::FFieldMethodType = "A"
		IF ::FBuffer = NIL
			::FBuffer := Array( Len( ::FFieldArrayIndex ) )
		ENDIF
		FOR EACH i IN ::FFieldArrayIndex
			::FBuffer[ i:__enumIndex ] := ::FTable:FieldList[ i ]:GetBuffer()
		NEXT
		RETURN ::FBuffer
	ENDIF

	IF ::FBuffer == NIL
		::Reset()
	ENDIF

RETURN ::FBuffer

/*
	GetChanged
	Teo. Mexico 2009
*/
METHOD FUNCTION GetChanged() CLASS TField
	IF ! ::FWrittenValue == NIL
		RETURN .T.
	ENDIF
RETURN .F.

/*
	GetData
	Teo. Mexico 2006
*/
METHOD PROCEDURE GetData() CLASS TField
	LOCAL i

	SWITCH ::FFieldMethodType
	CASE 'B'
		::SetBuffer( ::GetAsVariant() )
		EXIT
	CASE 'C'
		IF ::FCalculated
			::SetBuffer( ::GetAsVariant() )
		ELSE
			::SetBuffer( ::Table:Alias:Eval( ::FFieldReadBlock ) )
		ENDIF
		EXIT
	CASE 'A'
		FOR EACH i IN ::FFieldArrayIndex
			::FTable:FieldList[ i ]:GetData()
		NEXT
		EXIT
	END
	
	::FWrittenValue := NIL

RETURN

/*
	GetDefaultValue
	Teo. Mexico 2009
*/
METHOD FUNCTION GetDefaultValue CLASS TField
	LOCAL i

	IF ::FFieldMethodType = 'A'
		FOR EACH i IN ::FFieldArrayIndex
			::FTable:FieldList[ i ]:GetDefaultValue()
		NEXT
		//RETURN NIL
	ENDIF

	IF ValType( ::FDefaultValue ) = "B"
		RETURN ::FDefaultValue:Eval( Self:FTable )
	ENDIF

RETURN ::FDefaultValue

/*
	GetEditText
	Teo. Mexico 2009
*/
METHOD FUNCTION GetEditText CLASS TField
	LOCAL Result

	IF ::OnGetText != NIL
		Result := ::GetAsVariant()
		::OnGetText:Eval( Self, @Result )
	ELSE
		Result := ::GetAsString()
	ENDIF

RETURN Result

/*
	GetFieldArray
	Teo. Mexico 2010
*/
METHOD FUNCTION GetFieldArray() CLASS TField
	LOCAL a := {}
	LOCAL i
	
	FOR EACH i IN ::FFieldArrayIndex
		AAdd( a, ::FTable:FieldList[ i ] )
	NEXT

RETURN a

/*
	GetFieldMethod
	Teo. Mexico 2006
*/
METHOD FUNCTION GetFieldMethod CLASS TField
	SWITCH ::FFieldMethodType
	CASE 'A'
		RETURN ::FFieldArrayIndex
	CASE 'B'
		RETURN ::FFieldCodeBlock
	CASE 'C'
		RETURN ::FFieldExpression
	END
RETURN NIL

/*
	GetUndoValue
	Teo. Mexico 2009
*/
METHOD FUNCTION GetUndoValue() CLASS TField
	IF !Empty( ::FTable:UndoList ) .AND. HB_HHasKey( ::FTable:UndoList, ::FName )
		RETURN ::FTable:UndoList[ ::FName ]
	ENDIF
RETURN NIL

/*
	GetValidValues
	Teo. Mexico 2009
*/
METHOD FUNCTION GetValidValues() CLASS TField

	IF ValType( ::ValidValues ) = "B"
		IF ::FDataOfValidValues == NIL
			::FDataOfValidValues := ::ValidValues:Eval( Self )
		ENDIF
		RETURN ::FDataOfValidValues
	ELSE
		RETURN ::ValidValues
	ENDIF

RETURN NIL

/*
	IsValid
	Teo. Mexico 2009
*/
METHOD FUNCTION IsValid( showAlert ) CLASS TField
	LOCAL validValues
	LOCAL value
	LOCAL result

	value := ::GetBuffer()
	
	IF ::FRequired .AND. Empty( value )
		IF showAlert == .T.
			wxhAlert( ::FTable:ClassName + ":" + ::FName + " <empty key value>" )
		ENDIF
		RETURN .F.
	ENDIF

	IF ::Unique
	/* IF Empty( value )
		wxhAlert( ::FTable:ClassName + ":" + ::FName + " <empty INDEX key value>" )
		RETURN .F.
	ENDIF
	 */		 
		IF ::FUniqueKeyIndex:ExistKey( ::AsIndexKeyVal( value ) )
			IF showAlert == .T.
				wxhAlert( ::FTable:ClassName + ":" + ::FName + " <key value already exists> '" + AsString( value ) + "'")
			ENDIF
			RETURN .F.
		ENDIF
	ENDIF

	IF ::ValidValues != NIL
	
		validValues := ::GetValidValues()
			
		SWITCH ValType( validValues )
		CASE 'A'
			result := AScan( validValues, {|e| e == value } ) > 0
			EXIT
		CASE 'H'
			result := AScan( HB_HKeys( validValues ), {|e| e == value } ) > 0
			EXIT
		OTHERWISE
			wxhAlert( ::FTable:ClassName + ":" + ::FName + " <Illegal value in 'ValidValues'> " )
			RETURN .F.
		ENDSWITCH
		
		IF !result
			IF showAlert == .T.
				wxhAlert( ::FTable:ClassName + ":" + ::FName + " < value given not in 'ValidValues'> : '" + AsString( value ) + "'" )
			ENDIF
			RETURN .F.
		ENDIF

	ENDIF

	IF ::OnValidate == NIL
		RETURN .T.
	ENDIF

RETURN ::OnValidate:Eval( Self )

/*
	OnPickList
	Teo. Mexico 2009
*/
METHOD FUNCTION OnPickList( param ) CLASS TField

	IF ::FPickList == NIL
		RETURN NIL
	ENDIF
	
	SWITCH ValType( ::FPickList )
	CASE 'B'
		RETURN ::FPickList:Eval( param )
	CASE 'L'
		RETURN ::FTable:OnPickList( param )
	END

RETURN NIL

/*
	Reset
	Teo. Mexico 2009
*/
METHOD FUNCTION Reset() CLASS TField
	LOCAL AField
	LOCAL i
	LOCAL value
	LOCAL result
	
	/* if is a masterfield component, then *must* resolve it in the MasterSource(s) */
	IF ( result := ::IsMasterFieldComponent )
	
		result := ( AField := ::FTable:FindMasterSourceField( ::Name ) ) != NIL
		
		IF result
			
			value := AField:GetBuffer()
			/*
			 * if there is a DefaultValue this is ignored (may be a warning is needed)
			 */
		ENDIF

	ENDIF
	
	/* reset was not succesfull yet */
	IF !result
		/* resolve each field on a array of fields */
		IF ::FFieldMethodType = 'A'
		
			result := .T.

			FOR EACH i IN ::FFieldArrayIndex
				IF result
					result := ::FTable:FieldList[ i ]:Reset()
				ENDIF
			NEXT

			RETURN result

		ELSE
		
			IF ::IsDerivedFrom("TObjectField") .AND. ::IsMasterFieldComponent
				IF ::FTable:MasterSource = NIL
					RAISE ERROR "MasterField component '" + ::Table:ClassName + ":" + ::Name + "' needs a MasterSource Table."
				ELSE
					RAISE ERROR "MasterField component '" + ::Table:ClassName + ":" + ::Name + "' cannot be resolved in MasterSource Table (" + ::FTable:MasterSource:ClassName() + ") ."
				ENDIF
			ENDIF

			IF ::FDefaultValue != NIL

				value := ::GetDefaultValue()

			ELSE

				IF ::IsDerivedFrom( "TObjectField" )
					IF ::LinkedTable:GetPrimaryKeyField() != NIL
						value := ::LinkedTable:GetPrimaryKeyField():GetDefaultValue()
						IF value == NIL
							value := ::LinkedTable:GetPrimaryKeyField():GetEmptyValue()
						ENDIF
					ENDIF
				ELSE
					value := ::GetEmptyValue()
				ENDIF

			ENDIF
			
			result := .T.

		ENDIF
	ENDIF

	::SetBuffer( value )

	::FWrittenValue := NIL

RETURN result

/*
	SetAsVariant
	Teo. Mexico 2006
*/
METHOD PROCEDURE SetAsVariant( rawValue ) CLASS TField
	LOCAL Value

	IF ::FTable:ReadOnly .OR. ::Table:State = dsInactive
		RETURN
	ENDIF
	
	/* if Browsing then do a SeekKey() with the rawValue */
	IF ::FTable:State = dsBrowse
	
		IF ::IsKeyIndex
		
			IF ::OnSearch != NIL
				::OnSearch:Eval( Self )
			ENDIF

			IF !Empty( rawValue )
				::KeyIndex:Seek( rawValue )
			ELSE
				::FTable:DbGoTo( 0 )
			ENDIF

			IF ::FTable:LinkedObjField != NIL

				IF AScan( { dsEdit, dsInsert }, ::FTable:LinkedObjField:Table:State ) > 0
					::FTable:LinkedObjField:SetAsVariant( ::FTable:GetPrimaryKeyField():GetBuffer() )
				ENDIF

				IF ! ::FTable:LinkedObjField:GetAsVariant == ::FTable:GetPrimaryKeyField():GetBuffer()
					::FTable:Seek( ::FTable:LinkedObjField:GetAsVariant, "" )
				ENDIF
				
			ENDIF

		ELSE
	
			//RAISE TFIELD ::Name ERROR "Field has no Index in the Table..."
			//wxhAlert( "Field '" + ::FName + "' has no Index in the Table..." )
			//Beep()

		ENDIF

		RETURN

	ENDIF

	IF AScan( { dsEdit, dsInsert, dsReading }, ::FTable:State ) = 0
		RAISE TFIELD ::Name ERROR "Table not in Edit or Insert or Reading mode"
		RETURN
	ENDIF

	Value := rawValue

	SWITCH ::FFieldMethodType
	CASE "A"

		RAISE TFIELD ::Name ERROR "Trying to assign a value to a compound TField."

		EXIT

	CASE "C"

		IF ::ReadOnly
			RETURN
		ENDIF

		IF ::FTable:State = dsReading .OR. ::AutoIncrement
			::SetBuffer( Value )
			RETURN
		ENDIF

		/* Check if we are really changing values here */
		IF value == ::GetBuffer()
			RETURN
		ENDIF

		::SetData( Value )

		RETURN

	OTHERWISE

	END

RETURN

/*
	SetBuffer
	Teo. Mexico 2009
*/
METHOD PROCEDURE SetBuffer( value ) CLASS TField
	LOCAL itm

	/* FieldArray's doesn't have a absolute FBuffer */
	IF ::FFieldMethodType = "A"
		SWITCH ValType( value )
		CASE 'A'
			FOR EACH itm IN value
				::FTable:FieldList[ ::FFieldArrayIndex[ itm:__enumIndex ] ]:SetBuffer( itm )
			NEXT
			EXIT
		ENDSWITCH
		RETURN
	ENDIF

	IF !( hb_IsNIL( value ) .OR. ValType( value ) = ::FValType ) .AND. ;
		 ( ::IsDerivedFrom("TStringField") .AND. AScan( {"C","M"}, ValType( value ) ) = 0 )
		RAISE TFIELD ::Name ERROR "Wrong Type Assign: [" + value:ClassName + "] to <" + ::ClassName + ">"
	ENDIF

	::FBuffer := value

	IF ::OnSetValue != NIL
		::OnSetValue:Eval( Self, @::FBuffer )
	ENDIF

RETURN

/*
	SetData
	Teo. Mexico 2006
*/
METHOD PROCEDURE SetData( Value ) CLASS TField
	LOCAL i
	LOCAL nTries
	LOCAL errObj
	LOCAL buffer

	/* SetData is only for the physical fields on the database */
	SWITCH ::FFieldMethodType
	CASE 'A'

		IF Value != NIL
			RAISE TFIELD ::Name ERROR "SetData: Not allowed custom value with a compund TField..."
		ENDIF

		FOR EACH i IN ::FFieldArrayIndex
			::FTable:FieldList[ i ]:SetData()
		NEXT
		
		RETURN

	CASE 'C'

		EXIT

	OTHERWISE

		RETURN

	END

	IF AScan( { dsEdit, dsInsert }, ::Table:State ) = 0
		RAISE TFIELD ::Name ERROR "SetData(): Table not in Edit or Insert mode..."
		RETURN
	ENDIF

	IF ::FCalculated .OR. ::FModStamp
		RETURN
	ENDIF

	IF ::AutoIncrement

		IF Value != NIL
			RAISE TFIELD ::Name ERROR "Not allowed custom value in AutoIncrement Field..."
		ENDIF

		/*
		 *AutoIncrement field writting allowed only in Adding
		 */
		IF !( ::FTable:SubState = dssAdding )
			RETURN
		ENDIF
		
		/* Try to obtain a unique key */
		nTries := 1000
		WHILE .T.
			Value := ::GetAutoIncrementValue()
			IF !::FAutoIncrementKeyIndex:ExistKey( ::AsIndexKeyVal( Value ) )
				EXIT
			ENDIF
			IF	(--nTries = 0)
				RAISE TFIELD ::Name ERROR "Can't create AutoIncrement Value..."
				RETURN
			ENDIF
		ENDDO

	ELSE

		IF Value == NIL
			Value := ::GetBuffer()
		ENDIF

	ENDIF

	/* Don't bother... */
	IF Value == ::FWrittenValue
		RETURN
	ENDIF

	/* Check if field is a masterkey in child tables */
	IF ::FTable:PrimaryIndex != NIL .AND. ::FTable:PrimaryIndex:UniqueKeyField == Self .AND. ::FWrittenValue != NIL
		IF ::FTable:HasChilds()
			wxhAlert( "Can't modify key <"+::FName+"> with "+Value+";Has dependant child tables.")
			RETURN
		ENDIF
	ENDIF

	IF ::FEvtOnBeforeChange = NIL
		::FEvtOnBeforeChange := __ObjHasMsgAssigned( ::FTable, "OnBeforeChange_Field_" + ::Name )
	ENDIF

	IF ::FEvtOnBeforeChange .AND. !__ObjSendMsg( ::FTable, "OnBeforeChange_Field_" + ::Name, Self, Value )
		RETURN
	ENDIF

	buffer := ::GetBuffer()

	::SetBuffer( Value )

	/* Validate before the physical writting */
	IF !::IsValid( .T. )
		::SetBuffer( buffer )  // revert the change
		RETURN
	ENDIF

	BEGIN SEQUENCE WITH {|oErr| Break( oErr ) }

		/*
		 * Check for a key violation
		 */
		IF ::IsPrimaryKeyField .AND. ::FUniqueKeyIndex:ExistKey( ::AsIndexKeyVal() )
			RAISE TFIELD ::Name ERROR "Key violation."
		ENDIF
	
		/* The physical write to the field */
		::FTable:Alias:Eval( ::FFieldWriteBlock, Value )
		
		::FWrittenValue := ::GetBuffer() // If TFieldString then we make sure that size values are equal
		
		/* fill undolist */
		IF ::FTable:State = dsEdit .AND. ! HB_HHasKey( ::FTable:UndoList, ::FName )
			::FTable:UndoList[ ::FName ] := buffer
		ENDIF

		/*
		 * Check if has to propagate change to child sources
		 */
		IF ::FTable:PrimaryIndex != NIL .AND. ::FTable:PrimaryIndex:UniqueKeyField == Self
			::FTable:SyncDetailSources()
		ENDIF

		IF ::OnAfterChange != NIL
			::OnAfterChange:Eval( Self, buffer )
		ENDIF
		
	RECOVER USING errObj

		SHOW ERROR errObj

	END

	/* masterkey field's aren't changed here */
	IF ::IsMasterFieldComponent
		::Reset()  /* retrieve the masterfield value */
	ENDIF

RETURN

/*
	SetEditText
	Teo. Mexico 2009
*/
METHOD PROCEDURE SetEditText( Text ) CLASS TField

	IF ::OnSetText != NIL
		::OnSetText:Eval( Self, Text )
	ELSE
		::SetAsString( Text )
	ENDIF

RETURN

/*
	SetFieldMethod
	Teo. Mexico 2006
*/
METHOD PROCEDURE SetFieldMethod( FieldMethod ) CLASS TField
	LOCAL itm,fieldName
	LOCAL AField
	LOCAL i
	LOCAL n

	SWITCH (::FFieldMethodType := ValType( FieldMethod ))
	CASE "A"
		//::FReadOnly := .T.
		IF ::IsDerivedFrom("TStringField")
			::FSize := 0
		ENDIF
		::FFieldArrayIndex := {}
		fieldName := ""
		FOR EACH itm IN FieldMethod
			AField := ::FTable:FieldByName( itm, @i )
			IF AField != NIL
				AAdd( ::FFieldArrayIndex, i )
				fieldName += itm + ";"
			ELSE
				RAISE TFIELD itm ERROR "Field is not defined yet..."
			ENDIF
			IF ::IsDerivedFrom("TStringField")
				::FSize += AField:Size
			ENDIF
		NEXT
		::Name := Left( fieldName, Len( fieldName ) - 1 )
		::FFieldCodeBlock	 := NIL
		::FFieldReadBlock	 := NIL
		::FFieldWriteBlock := NIL
		::FFieldExpression := NIL
		EXIT
	CASE "B"
		::FReadOnly := .T.
		::FFieldArrayIndex := NIL
		::FFieldCodeBlock	 := FieldMethod
		::FFieldReadBlock	 := NIL
		::FFieldWriteBlock := NIL
		::FFieldExpression := NIL
		EXIT
	CASE "C"

		::FFieldArrayIndex := NIL
		::FFieldCodeBlock := NIL

		FieldMethod := LTrim( RTrim( FieldMethod ) )

		/* Check if the same FieldExpression is declared redeclared in the same table baseclass */
		FOR EACH AField IN ::FTable:FieldList
			IF !Empty( AField:FieldExpression ) .AND. ;
				 Upper( AField:FieldExpression ) == Upper( FieldMethod ) .AND. ;
				 AField:TableBaseClass == ::FTableBaseClass
				RAISE TFIELD ::Name ERROR "Atempt to Re-Use FieldExpression (same field on db) <" + ::ClassName + ":" + FieldMethod + ">"
			ENDIF
		NEXT

		::FDBS_NAME := FieldMethod

		IF ::FTable:Alias != NIL .AND. ::FTable:Alias:FieldPos( FieldMethod ) > 0
			::FFieldReadBlock	 := FieldBlock( FieldMethod )
			::FFieldWriteBlock := FieldBlock( FieldMethod )
			n := AScan( ::Table:DbStruct, {|e| Upper( FieldMethod ) == e[1] } )
			/*!
			 * Check if TField and database field are compatible
			 * except for TObjectField's here
			 */
			IF !::IsDerivedFrom("TObjectField") .AND. !::IsDerivedFrom( ::FTable:FieldTypes[ ::Table:DbStruct[n][2] ] )
				//RAISE TFIELD ::Name ERROR "Invalid type on TField Class '" + ::FTable:FieldTypes[ ::Table:DbStruct[n][2] ] + "' : <" + FieldMethod + ">"
			ENDIF
			::FModStamp	:= ::Table:DbStruct[n][2] $ "=^+"
			
			::FDBS_LEN := ::Table:DbStruct[n][3]
			::FDBS_DEC := ::Table:DbStruct[n][4]

			::FCalculated := .F.
		ELSE
			::FFieldReadBlock	 := NIL
			::FFieldWriteBlock := NIL
			::FCalculated := .T.
		ENDIF

		fieldName := iif( Empty( ::FName ), FieldMethod, ::FName )

		IF Empty( fieldName )
			RAISE TFIELD "<Empty>" ERROR "Empty field name and field method."
		ENDIF

		// Check if FieldExpression is re-declared in parent class
		IF AScan( ::FTable:FieldList, {|AField| !Empty(AField:FieldExpression) .AND. Upper( AField:FieldExpression ) == Upper( fieldName ) /*.AND. ::IsDerivedFrom( AField:ClassName )*/ }) > 0
			n := AScan( ::FTable:FieldList, {|AField| AField == Self } )
			IF n > 0
				ADel( ::FTable:FieldList, n )
				ASize( ::FTable:FieldList, Len( ::FTable:FieldList ) - 1 )
			ENDIF
			wxhAlert( "Field '" + FieldMethod + "' on table '" + ::FTable:ClassName + "' ignored, because fieldExpression is previously declared in subclass.") //with same TField type." )
			RETURN /* ok, we don't need this now repeated parent field */
		ENDIF

		::FFieldExpression := FieldMethod
		::Name := FieldMethod

		EXIT

	END

RETURN

/*
	SetIsMasterFieldComponent
	Teo. Mexico 2009
*/
METHOD PROCEDURE SetIsMasterFieldComponent( IsMasterFieldComponent ) CLASS TField
	LOCAL i

	SWITCH ::FFieldMethodType
	CASE 'A'
		FOR EACH i IN ::FFieldArrayIndex
			::FTable:FieldList[ i ]:IsMasterFieldComponent := IsMasterFieldComponent
		NEXT
	CASE 'C'
		::FIsMasterFieldComponent := IsMasterFieldComponent
	END
	
	IF ::IsDerivedFrom("TObjectField") .AND. Empty( ::FTable:GetMasterSourceClassName() )
		RAISE TFIELD ::Name ERROR "ObjectField's needs a valid MasterSource table."
	ENDIF

RETURN

/*
	SetName
	Teo. Mexico 2006
*/
METHOD PROCEDURE SetName( name ) CLASS TField

	IF Empty( name ) .OR. !Empty( ::FName )
		RETURN
	ENDIF

	::FName := name

RETURN

/*
	SetPickList<
	Teo. Mexico 2009
*/
METHOD PROCEDURE SetPickList( pickList ) CLASS TField
	SWITCH ValType( pickList )
	CASE 'B'
		::FPickList := pickList
		EXIT
	CASE 'L'
		IF pickList
			::FPickList := .T.
		ENDIF
		EXIT
	END
RETURN

/*
	SetPrimaryKeyComponent
	Teo. Mexico 2009
*/
METHOD PROCEDURE SetPrimaryKeyComponent( PrimaryKeyComponent ) CLASS TField
	LOCAL i

	SWITCH ::FFieldMethodType
	CASE 'A'
		FOR EACH i IN ::FFieldArrayIndex
			::FTable:FieldList[ i ]:PrimaryKeyComponent := PrimaryKeyComponent
		NEXT
		EXIT
	CASE 'C'
		::FPrimaryKeyComponent := PrimaryKeyComponent
	END

RETURN

/*
	SetUsingField
	Teo. Mexico 2009
*/
METHOD PROCEDURE SetUsingField( usingField ) CLASS TField
	LOCAL AField := ::FTable:FieldByName( usingField )
	IF AField != NIL
		::FUsingField := AField
		::FCalculated := .T.
	ENDIF
RETURN

/*
	ENDCLASS TField
*/

/*
	TStringField
	Teo. Mexico 2006
*/
CLASS TStringField FROM TField
PRIVATE:
PROTECTED:
	DATA FDBS_LEN INIT 0
	DATA FDBS_DEC INIT 0
	DATA FDBS_TYPE INIT "C"
	DATA FSize
	DATA FType INIT "String"
	DATA FValType INIT "C"
	METHOD GetEmptyValue INLINE iif( ::FSize == NIL, "", Space( ::FSize ) )
	METHOD SetBuffer( buffer )
	METHOD SetDefaultValue( DefaultValue )
	METHOD SetSize( size )
PUBLIC:
	METHOD GetAsString
PUBLISHED:
	PROPERTY Size READ FSize WRITE SetSize
ENDCLASS

/*
	GetAsString
	Teo. Mexico 2009
*/
METHOD FUNCTION GetAsString CLASS TStringField
	LOCAL Result := ""
	LOCAL i

	SWITCH ::FFieldMethodType
	CASE 'A'
		FOR EACH i IN ::FFieldArrayIndex
			Result += ::FTable:FieldList[ i ]:AsString()
		NEXT
		EXIT
	OTHERWISE
		Result := ::GetAsVariant()
	END

RETURN Result

/*
	SetBuffer
	Teo. Mexico 2009
*/
METHOD PROCEDURE SetBuffer( buffer ) CLASS TStringField
	IF ::IsDerivedFrom("TMemoField")
		Super:SetBuffer( buffer )
	ELSE
		IF !HB_IsNIL( buffer ) .AND. HB_IsNIL( ::FSize ) .AND. !buffer == ""
			::FSize := Len( buffer )
		ENDIF
		IF HB_IsString( buffer ) .AND. Len( buffer ) != ::FSize
			Super:SetBuffer( PadR( buffer, ::FSize ) )
		ELSE
			Super:SetBuffer( buffer )
		ENDIF
	ENDIF
RETURN

/*
	SetDefaultValue
	Teo. Mexico 2006
*/
METHOD PROCEDURE SetDefaultValue( DefaultValue ) CLASS TStringField

	IF DefaultValue == NIL
		::FDefaultValue := NIL
		RETURN
	ENDIF

	::FDefaultValue := DefaultValue

	IF ValType( DefaultValue ) = "B" .AND. ::FTable:State = dsInactive
		RETURN
	ENDIF

	::SetBuffer( ::GetDefaultValue() )
	::FSize := Len( ::GetBuffer() )

RETURN

/*
	SetSize
	Teo. Mexico 2010
*/
METHOD PROCEDURE SetSize( size ) CLASS TStringField
	::FSize := size
	::DBS_LEN := size
RETURN

/*
	ENDCLASS TStringField
*/

/*
	TMemoField
	Teo. Mexico 2006
*/
CLASS TMemoField FROM TStringField
PRIVATE:
PROTECTED:
	DATA FDBS_LEN INIT 4
	DATA FDBS_DEC INIT 0
	DATA FDBS_TYPE INIT "M"
	DATA FType INIT "Memo"
PUBLIC:
PUBLISHED:
ENDCLASS

/*
	ENDCLASS TMemoField
*/

/*
	TNumericField
	Teo. Mexico 2006
*/
CLASS TNumericField FROM TField
PRIVATE:
PROTECTED:
	DATA FDBS_LEN INIT 0
	DATA FDBS_DEC INIT 0
	DATA FDBS_TYPE INIT "N"
	DATA FType INIT "Numeric"
	DATA FValType INIT "N"
	METHOD GetEmptyValue BLOCK {|| 0 }
	METHOD SetAsVariant( variant )
PUBLIC:

	METHOD GetAsString

	PROPERTY AsNumeric READ GetAsVariant WRITE SetAsVariant

PUBLISHED:
ENDCLASS

/*
	GetAsString
	Teo. Mexico 2009
*/
METHOD FUNCTION GetAsString( Value ) CLASS TNumericField
	LOCAL Result

	IF Value == NIL
		Value := ::GetAsVariant()
	ENDIF

	IF ::OnGetText != NIL
		Result := Value
		::OnGetText:Eval( Self, @Result )
	ELSE
		Result := Str( Value )
	ENDIF

RETURN Result

/*
	SetAsVariant
	Teo. Mexico 2009
*/
METHOD PROCEDURE SetAsVariant( variant ) CLASS TNumericField

	SWITCH ValType( variant )
	CASE 'C'
		Super:SetAsVariant( Val( variant ) )
		EXIT
	CASE 'N'
		Super:SetAsVariant( variant )
		EXIT
	END

RETURN

/*
	ENDCLASS TNumericField
*/

/*
	TIntegerField
	Teo. Mexico 2009
*/
CLASS TIntegerField FROM TNumericField
PRIVATE:
PROTECTED:
	DATA FDBS_LEN INIT 4
	DATA FDBS_DEC INIT 0
	DATA FDBS_TYPE INIT "I"
	DATA FType INIT "Integer"
	METHOD SetAsVariant( variant )
PUBLIC:

	PROPERTY AsInteger READ GetAsVariant WRITE SetAsVariant

PUBLISHED:
ENDCLASS

/*
	SetAsVariant
	Teo. Mexico 2009
*/
METHOD PROCEDURE SetAsVariant( variant ) CLASS TIntegerField

	SWITCH ValType( variant )
	CASE 'C'
		Super:SetAsVariant( Int( Val( variant ) ) )
		EXIT
	CASE 'N'
		Super:SetAsVariant( Int( variant ) )
		EXIT
	END

RETURN

/*
	ENDCLASS TIntegerField
*/

/*
	TFloatField
	Teo. Mexico 2010
*/
CLASS TFloatField FROM TNumericField
PRIVATE:
PROTECTED:
	DATA FDBS_LEN INIT 8
	DATA FDBS_DEC INIT 2
	DATA FDBS_TYPE INIT "B"
	DATA FType INIT "Float"
PUBLIC:
PUBLISHED:
ENDCLASS

/*
	ENDCLASS TFloatField
*/

/*
	TLogicalField
	Teo. Mexico 2006
*/
CLASS TLogicalField FROM TField
PRIVATE:
PROTECTED:
	DATA FDBS_LEN INIT 1
	DATA FDBS_DEC INIT 0
	DATA FDBS_TYPE INIT "L"
	DATA FType INIT "Logical"
	DATA FValType INIT "L"
	METHOD GetEmptyValue BLOCK {|| .F. }
PUBLIC:

	PROPERTY AsBoolean READ GetAsVariant WRITE SetAsVariant

PUBLISHED:
ENDCLASS

/*
	ENDCLASS TLogicalField
*/

/*
	TDateField
	Teo. Mexico 2006
*/
CLASS TDateField FROM TField
PRIVATE:
PROTECTED:
	DATA FDBS_LEN INIT 4
	DATA FDBS_DEC INIT 0
	DATA FDBS_TYPE INIT "D"
	DATA FSize INIT 8					// Size on index is 8 = len of DToS()
	DATA FType INIT "Date"
	DATA FValType INIT "D"
	METHOD GetDefaultValue BLOCK {|| Date() }
	METHOD GetEmptyValue BLOCK {|| CtoD("") }
	METHOD SetAsVariant( variant )
PUBLIC:
	METHOD GetAsString INLINE FDateS( ::GetAsVariant() )
	PROPERTY Size READ FSize
PUBLISHED:
ENDCLASS

/*
	SetAsVariant
	Teo. Mexico 2009
*/
METHOD PROCEDURE SetAsVariant( variant ) CLASS TDateField

	SWITCH ValType( variant )
	CASE 'C'
		Super:SetAsVariant( AsDate( variant ) )
		EXIT
	CASE 'D'
		Super:SetAsVariant( variant )
		EXIT
	END

RETURN

/*
	ENDCLASS TDateField
*/

/*
	TDayTimeField
	Teo. Mexico 2009
*/
CLASS TDayTimeField FROM TField
PRIVATE:
PROTECTED:
	DATA FSize INIT 23
	DATA FDBS_LEN INIT 8
	DATA FDBS_DEC INIT 0
	DATA FDBS_TYPE INIT "@"
	DATA FType INIT "DayTime"
	DATA FValType INIT "C"
	METHOD GetDefaultValue BLOCK {|| HB_DateTime( Date() ) }
	METHOD GetEmptyValue BLOCK {|| HB_DateTime( CToD("") ) }
PUBLIC:
	PROPERTY Size READ FSize
PUBLISHED:
ENDCLASS

/*
	EndClass TDayTimeField
*/


/*
	TModTimeField
	Teo. Mexico 2009
*/
CLASS TModTimeField FROM TDayTimeField
PRIVATE:
PROTECTED:
	DATA FDBS_LEN INIT 8
	DATA FDBS_DEC INIT 0
	DATA FDBS_TYPE INIT "="
	DATA FType INIT "ModTime"
PUBLIC:
PUBLISHED:
ENDCLASS

/*
	EndClass TModTimeField
*/

/*
	TObjectField
	Teo. Mexico 2009
*/
CLASS TObjectField FROM TField
PRIVATE:
	DATA FObjValue
	DATA FLinkedTable									 /* holds the Table object */
	DATA FLinkedTableMasterSource
	METHOD GetSize INLINE ::GetReferenceField():Size
	METHOD SetLinkedTableMasterSource( linkedTableMasterSource ) INLINE ::FLinkedTableMasterSource := linkedTableMasterSource
	METHOD SetObjValue( objValue ) INLINE ::FObjValue := objValue
PROTECTED:
	DATA FCalcMethod
	DATA FHasCalculatedMethod INIT .F.
	DATA FType INIT "ObjectField"
	DATA FValType INIT "O"
	METHOD GetLinkedTable
	METHOD GetEmptyValue() INLINE ::LinkedTable:GetPrimaryKeyField():EmptyValue
PUBLIC:
	METHOD DataObj
	METHOD AsIndexKeyVal( value )
	METHOD GetAsString							//INLINE ::LinkedTable:GetPrimaryKeyField():AsString()
	METHOD GetAsVariant( ... )
	METHOD GetReferenceField()	// Returns the non-TObjectField associated to this obj
	PROPERTY LinkedTable READ GetLinkedTable
	PROPERTY LinkedTableMasterSource READ FLinkedTableMasterSource WRITE SetLinkedTableMasterSource
	PROPERTY ObjValue READ FObjValue WRITE SetObjValue
	PROPERTY Size READ GetSize
PUBLISHED:
ENDCLASS

/*
	AsIndexKeyVal
	Teo. Mexico 2009
*/
METHOD FUNCTION AsIndexKeyVal( value ) CLASS TObjectField
	LOCAL pkField
	
	value := Super:AsIndexKeyVal( value )

	pkField := ::GetReferenceField()
	
	IF pkField = NIL
		RETURN value
	ENDIF

RETURN pkField:AsIndexKeyVal( value )

/*
	DataObj
	Syncs the Table with the key in buffer
	Teo. Mexico 2009
*/
METHOD FUNCTION DataObj CLASS TObjectField
	LOCAL linkedTable
	LOCAL linkedObjField

	IF ::FHasCalculatedMethod
		RETURN ::FFieldReadBlock:Eval( ::FTable )
	ENDIF

	linkedTable := ::LinkedTable
	
	IF ::FHasCalculatedMethod
		RETURN linkedTable
	ENDIF

	IF ::IsMasterFieldComponent .AND. ::FTable:FUnderReset
	
	ELSE
		/* Syncs with the current value */
		//? ::LinkedTable:Value, "==", ::Value
		IF !::FTable:MasterSource == linkedTable .AND. !linkedTable:Value == ::Value
			linkedObjField := linkedTable:LinkedObjField
			linkedTable:LinkedObjField := NIL
			linkedTable:Value := ::Value
			linkedTable:LinkedObjField := linkedObjField
		ENDIF
	ENDIF

RETURN linkedTable

/*
	GetAsString
	Teo. Mexico 2009
*/
METHOD FUNCTION GetAsString CLASS TObjectField
	LOCAL Result

	Result := ::GetBuffer()

RETURN Result

/*
	GetAsVariant
	Teo. Mexico 2010
*/
METHOD FUNCTION GetAsVariant( ... ) CLASS TObjectField
RETURN Super:GetAsVariant( ... )

/*
	GetLinkedTable
	Teo. Mexico 2009
*/
METHOD FUNCTION GetLinkedTable CLASS TObjectField
	LOCAL linkedTableMasterSource

	IF ::FLinkedTable == NIL

		IF Empty( ::FObjValue )
			RAISE TFIELD ::Name ERROR "TObjectField has not a ObjValue value."
		ENDIF

		/*
		 * Solve using the default ObjValue
		 */
		SWITCH ValType( ::FObjValue )
		CASE 'C'
			IF ::FTable:MasterSource != NIL .AND. ::FTable:MasterSource:IsDerivedFrom( ::FObjValue )
				IF ! ::IsMasterFieldComponent
					//RAISE TFIELD ::Name ERROR "MasterSource table has to be assigned to a master field component."
				ENDIF
				::FLinkedTable := ::FTable:MasterSource
			ELSE
				IF ::FLinkedTableMasterSource != NIL
					linkedTableMasterSource := ::FLinkedTableMasterSource:Eval( ::FTable )
				ELSEIF ::FTable:IsDerivedFrom( ::Table:GetMasterSourceClassName( ::FObjValue ) )
					linkedTableMasterSource := ::FTable
				ENDIF
				IF __ObjHasMsgAssigned( ::FTable, "CalcField_" + ::Name )
					::FFieldReadBlock := &("{|o,...|" + "o:CalcField_" + ::FName + "( ... ) }")
					::FHasCalculatedMethod := .T.
					RETURN ::FFieldReadBlock:Eval( ::FTable )
				ELSE
				ENDIF
				::FLinkedTable := __ClsInstFromName( ::FObjValue ):New( linkedTableMasterSource )
			ENDIF
			EXIT
		CASE 'B'
			::FLinkedTable := ::FObjValue:Eval( ::FTable )
			EXIT
		CASE 'O'
			::FLinkedTable := ::FObjValue
			EXIT
		ENDSWITCH

		IF !HB_IsObject( ::FLinkedTable ) .OR. ! ::FLinkedTable:IsDerivedFrom( "TTable" )
			RAISE TFIELD ::Name ERROR "Default value is not a TTable object."
		ENDIF
		
		/*
		 * Attach the current DataObj to the one in table to sync when table changes
		 * MasterFieldComponents are ignored, a child cannot change his parent :)
		 */
		IF !::IsMasterFieldComponent .AND. ::FLinkedTable:LinkedObjField == NIL
			/*
			 * LinkedObjField is linked to the FIRST TObjectField were it is referenced
			 * this has to be the most top level MasterSource table
			 */
			::FLinkedTable:LinkedObjField := Self
		ELSE
			/*
			 * We need to set this field as READONLY, because their LinkedTable
			 * belongs to a some TObjectField in some MasterSource table
			 * so this TObjectField cannot modify the physical database here
			 */
			//::ReadOnly := .T.
		ENDIF

	ENDIF

RETURN ::FLinkedTable

/*
	GetReferenceField
	Teo. Mexico 2010
*/
METHOD FUNCTION GetReferenceField() CLASS TObjectField
	LOCAL pkField
	LOCAL masterSourceClassName := ::FTable:GetMasterSourceClassName()

	IF ::IsMasterFieldComponent .AND. !Empty( masterSourceClassName ) .AND. ::DataObj:IsDerivedFrom( masterSourceClassName )
		pkField := ::DataObj:GetPrimaryKeyField( masterSourceClassName )
	ELSE
		pkField := ::DataObj:GetPrimaryKeyField( ::DataObj:GetMasterSourceClassName() )
	ENDIF

RETURN pkField

/*
	ENDCLASS TObjectField
*/
