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
                                SUBSYSTEM ::ClassName + "<'" + ::GetLabel() + "'>"	;
                                OPERATION E"\n" + ProcName(0)+"(" + LTrim(Str(ProcLine(0))) + ")"

/*
    TField
    Teo. Mexico 2009
*/
CLASS TField FROM WXHBaseClass
PRIVATE:

    DATA FEnabled	INIT .F.
    DATA FAutoIncrementKeyIndex
    DATA FDataOfValidValues
    DATA FDescription INIT ""
    DATA FFieldCodeBlock									// Code Block
    DATA FFieldWriteBlock									// Code Block to do WRITE
    DATA FHasCalcFieldMethod INIT .F.
    DATA FPickList											// codeblock to help to pick a value
    DATA FGroup														// A Text label for grouping
    DATA FIsMasterFieldComponent INIT .F. // Field is a MasterField component
    DATA FPrimaryKeyComponent INIT .F.		// Field is included in a Array of fields for a Primary Index Key
    DATA FPublished INIT .T.							// Logical: Appears in user field selection
    DATA FReadOnly	INIT .F.
    DATA FRequired INIT .F.
    /* TODO: remove or fix validations, i.e. when reusing a primary index field */
    DATA FReUseField INIT .F.
    DATA FUniqueKeyIndex
    DATA FUsingField						// Field used on Calculated Field

    METHOD GetAutoIncrement INLINE ::FAutoIncrementKeyIndex != NIL
    METHOD GetAutoIncrementValue
    METHOD GetFieldMethod
    METHOD GetIsPrimaryKeyField INLINE ::Table:KeyField == Self
    METHOD GetReadOnly INLINE ::FReadOnly
    METHOD GetUnique INLINE ::FUniqueKeyIndex != NIL
    METHOD SetAutoIncrementKeyIndex( Index ) INLINE ::FAutoIncrementKeyIndex := Index
    METHOD SetDescription( Description ) INLINE ::FDescription := Description
    METHOD SetGroup( Group ) INLINE ::FGroup := Group
    METHOD SetIsMasterFieldComponent( IsMasterFieldComponent )
    METHOD SetKeyIndex( Index ) INLINE ::FKeyIndex := Index
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
    DATA FChanged INIT .F.
    DATA FDefaultValue
    DATA FDBS_DEC INIT 0
    DATA FDBS_LEN
    DATA FDBS_NAME
    DATA FDBS_TYPE
    DATA FEvtOnBeforeChange
    DATA FFieldArrayIndex								// Array of TField's indexes in FieldList
    DATA FFieldExpression									// Literal Field expression on the Database
    DATA FFieldMethodType
    DATA FFieldReadBlock								// Code Block to do READ
    DATA FFieldType     INIT ftBase
    DATA FKeyIndex
    DATA FLabel
    DATA FModStamp	INIT .F.							// Field is automatically mantained (dbf layer)
    DATA FName INIT ""
    DATA FOnReset INIT .F.
    DATA FTable
    DATA FTableBaseClass
    DATA FType INIT "TField"
    DATA FValType INIT "U"
    DATA FWrittenValue
    
    METHOD GetAsExpression INLINE HB_StrToExp( ::GetAsString )
    METHOD GetCloneData( cloneData )
    METHOD GetDefaultValue( defaultValue )
    METHOD GetDBS_LEN INLINE ::FDBS_LEN
    METHOD GetDBS_TYPE INLINE ::FDBS_TYPE
    METHOD GetEnabled()
    METHOD GetEmptyValue BLOCK {|| NIL }
    METHOD GetFieldArray()
    METHOD GetFieldReadBlock()
    METHOD GetIsKeyIndex INLINE ::FKeyIndex != NIL
    METHOD GetLabel INLINE iif( ::FLabel == NIL, ::FName, ::FLabel )
    METHOD GetLinkedTable() INLINE NIL
    METHOD GetUndoValue()
    METHOD SetAsString( string ) INLINE ::SetAsVariant( string )
    METHOD SetBuffer( value )
    METHOD SetDBS_DEC( dec ) INLINE ::FDBS_DEC := dec
    METHOD SetDBS_LEN( dbs_Len ) INLINE ::FDBS_LEN := dbs_Len
    METHOD SetCloneData( cloneData )
    METHOD SetDefaultValue( DefaultValue ) INLINE ::FDefaultValue := DefaultValue
    METHOD SetEnabled( enabled )
    METHOD SetLabel( label ) INLINE ::FLabel := label
    METHOD SetRequired( Required ) INLINE ::FRequired := Required
    METHOD SetReUseField( reUseField ) INLINE ::FReUseField := reUseField
    METHOD WriteToTable( value, buffer )

PUBLIC:

    DATA nameAlias
    DATA Picture

    CONSTRUCTOR New( Table, curBaseClass )

    METHOD AddFieldMessage()
    METHOD Delete()
    METHOD GetAsString INLINE "<" + ::ClassName + ">"
    METHOD GetAsVariant( ... )
    METHOD GetBuffer()
    METHOD GetEditText
    METHOD GetData()
    METHOD GetKeyVal( keyVal )
    METHOD GetValidValues
    METHOD IndexExpression VIRTUAL
    METHOD IsReadOnly() INLINE ::FTable:ReadOnly .OR. ::FReadOnly .OR. ( ::FTable:State != dsBrowse .AND. ::AutoIncrement )
    METHOD IsTableField()
    METHOD OnPickList( param )
    METHOD Reset()
    METHOD RevertValue()
    METHOD SetAsVariant( value )
    METHOD SetData( Value )
    METHOD SetDbStruct( aStruct )
    METHOD SetEditText( Text )
    METHOD SetFieldMethod( FieldMethod, calculated )
    METHOD SetKeyVal( keyVal )
    METHOD SetValidValues( validValues )
    METHOD Validate( showAlert )
    METHOD ValidateFieldInfo VIRTUAL

    PROPERTY AsExpression READ GetAsExpression
    PROPERTY AsString READ GetAsString WRITE SetAsString
    PROPERTY AsVariant READ GetAsVariant WRITE SetAsVariant
    PROPERTY Calculated READ FCalculated
    PROPERTY CloneData READ GetCloneData WRITE SetCloneData
    PROPERTY DisplayText READ GetEditText
    PROPERTY EmptyValue READ GetEmptyValue
    PROPERTY KeyVal READ GetKeyVal WRITE SetKeyVal
    PROPERTY LinkedTable READ GetLinkedTable
    PROPERTY PickList READ FPickList WRITE SetPickList
    PROPERTY ReUseField READ FReUseField WRITE SetReUseField
    PROPERTY IsKeyIndex READ GetIsKeyIndex
    PROPERTY IsMasterFieldComponent READ FIsMasterFieldComponent WRITE SetIsMasterFieldComponent
    PROPERTY IsPrimaryKeyField READ GetIsPrimaryKeyField
    PROPERTY RawDefaultValue READ FDefaultValue
    PROPERTY Text READ GetEditText WRITE SetEditText
    PROPERTY UndoValue READ GetUndoValue
    PROPERTY Value READ GetAsVariant WRITE SetAsVariant
    PROPERTY WrittenValue READ FWrittenValue

PUBLISHED:
    
    DATA IncrementBlock
    /*
     * Event holders
     */
    DATA OnGetText			// Params: Sender: TField, Text: String
    DATA OnSearch			// Search in indexed field
    DATA OnSetText			// Params: Sender: TField, Text: String
    DATA OnSetValue			// Parama:
    DATA OnAfterChange		// Params: Sender: Table
    DATA OnAfterPostChange  // executes after Table post and only if field has been changed
    DATA OnValidate			// Params: Sender: TField
    DATA OnValidateWarn     // message if OnValidate == FALSE
    
    DATA ValidValues

    PROPERTY AutoIncrement READ GetAutoIncrement
    PROPERTY AutoIncrementKeyIndex READ FAutoIncrementKeyIndex WRITE SetAutoIncrementKeyIndex
    PROPERTY Changed READ FChanged
    PROPERTY DBS_DEC READ FDBS_DEC WRITE SetDBS_DEC
    PROPERTY DBS_LEN READ GetDBS_LEN WRITE SetDBS_LEN
    PROPERTY DBS_NAME READ FDBS_NAME
    PROPERTY DBS_TYPE READ GetDBS_TYPE
    PROPERTY DefaultValue READ GetDefaultValue WRITE SetDefaultValue
    PROPERTY Description READ FDescription WRITE SetDescription
    PROPERTY Enabled READ GetEnabled WRITE SetEnabled
    PROPERTY FieldArray READ GetFieldArray WRITE SetFieldMethod
    PROPERTY FieldCodeBlock READ FFieldCodeBlock WRITE SetFieldMethod
    PROPERTY FieldExpression READ FFieldExpression WRITE SetFieldMethod
    PROPERTY FieldMethod READ GetFieldMethod WRITE SetFieldMethod
    PROPERTY FieldMethodType READ FFieldMethodType
    PROPERTY FieldReadBlock READ GetFieldReadBlock
    PROPERTY FieldType READ FFieldType
    PROPERTY FieldWriteBlock READ FFieldWriteBlock
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
METHOD New( Table, curBaseClass ) CLASS TField

    ::FTable := Table
    ::FTableBaseClass := curBaseClass

    ::FEnabled := .T.

RETURN Self

/*
    AddFieldMessage
    Teo. Mexico 2010
*/
METHOD PROCEDURE AddFieldMessage() CLASS TField
    ::FTable:AddFieldMessage( ::Name, Self )
RETURN

/*
    Delete
    Teo. Mexico 2009
*/
METHOD PROCEDURE Delete() CLASS TField
    LOCAL errObj

    IF AScan( { dsEdit, dsInsert }, ::Table:State ) = 0
        ::Table:Table_Not_In_Edit_or_Insert_mode()
        RETURN
    ENDIF

    IF !::FFieldMethodType = 'C' .OR. ::FCalculated .OR. ::FFieldWriteBlock == NIL .OR. ::FModStamp .OR. ::FUsingField != NIL
        RETURN
    ENDIF

    BEGIN SEQUENCE WITH {|oErr| Break( oErr ) }

        ::WriteToTable( ::EmptyValue() )

        ::Reset()

    RECOVER USING errObj

        SHOW ERROR errObj

    END SEQUENCE

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

    IF ::FUsingField != NIL
        RETURN ::FUsingField:GetAsVariant( ... )
    ENDIF

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
        Result := ::FTable:Alias:Eval( ::FFieldCodeBlock, Self )
        IF HB_IsObject( Result )
            Result := Result:Value
        ENDIF
        EXIT
    CASE "C"
        IF ::FCalculated
            Result := ::FTable:Alias:Eval( ::FieldReadBlock, ::FTable, ... )
        ELSE
            Result := ::GetBuffer()
        ENDIF
        EXIT
    OTHERWISE
        RAISE TFIELD ::Name ERROR "GetAsVariant(): Field Method Type not supported: " + ::FFieldMethodType
    ENDSWITCH

RETURN Result

/*
    GetAutoIncrementValue
    Teo. Mexico 2009
*/
METHOD FUNCTION GetAutoIncrementValue CLASS TField
    LOCAL AIndex
    LOCAL value

    AIndex := ::FAutoIncrementKeyIndex

    value := ::Table:Alias:Get4SeekLast(	{|| ::FieldReadBlock:Eval() }, AIndex:MasterKeyVal, AIndex:TagName )

    IF HB_IsChar( value ) .AND. Len( value ) > ::Size
        value := Left( value, ::Size )
    ENDIF

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

    IF !::FCalculated
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
    ENDIF

RETURN ::FBuffer

/*
    GetCloneData
    Teo. Mexico 2010
*/
METHOD FUNCTION GetCloneData( cloneData ) CLASS TField

    IF cloneData = NIL
        cloneData := {=>}
    ENDIF
    
    cloneData["Buffer"] := ::FBuffer
    cloneData["Changed"] := ::FChanged
    cloneData["DefaultValue"] := ::FDefaultValue
    cloneData["WrittenValue"] := ::FWrittenValue

RETURN cloneData

/*
    GetData
    Teo. Mexico 2006
*/
METHOD PROCEDURE GetData() CLASS TField
    LOCAL i

    /* this is called for Table:GetCurrentRecord, used field has been read */
    IF ::FUsingField != NIL
        RETURN
    ENDIF

    SWITCH ::FFieldMethodType
    CASE 'B'
        ::SetBuffer( ::GetAsVariant() )
        EXIT
    CASE 'C'
        IF ::FCalculated
            ::SetBuffer( ::GetAsVariant() )
        ELSE
            ::SetBuffer( ::Table:Alias:Eval( ::FieldReadBlock ) )
            ::FChanged := .F.
        ENDIF
        EXIT
    CASE 'A'
        FOR EACH i IN ::FFieldArrayIndex
            ::FTable:FieldList[ i ]:GetData()
        NEXT
        EXIT
    ENDSWITCH
    
    ::FWrittenValue := NIL

RETURN

/*
    GetDefaultValue
    Teo. Mexico 2009
*/
METHOD FUNCTION GetDefaultValue( defaultValue ) CLASS TField
    LOCAL i
    LOCAL validValues

    IF ::FFieldMethodType = 'A'
        FOR EACH i IN ::FFieldArrayIndex
            ::FTable:FieldList[ i ]:GetDefaultValue()
        NEXT
        //RETURN NIL
    ENDIF

    IF defaultValue = NIL
        IF ValType( ::FDefaultValue ) = "B"
            defaultValue := ::FDefaultValue:Eval( Self:FTable )
        ELSE
            defaultValue := ::FDefaultValue
        ENDIF
    ENDIF
    
    validValues := ::GetValidValues()
    
    IF ! Empty( validValues )
        SWITCH ValType( validValues )
        CASE 'A'
            IF defaultValue = NIL
                defaultValue := validValues[ 1 ]
            ELSEIF AScan( validValues, {|e| e == defaultValue } ) = 0
                RAISE ERROR "On field <" + ::Table:ClassName() + ":" + ::Name + ">, default value '" + defaultValue + "' is not in valid values array list"
            ENDIF
            EXIT
        CASE 'H'
            IF defaultValue = NIL
                defaultValue := HB_HKeys( validValues )[ 1 ]
            ELSE
                IF !HB_HHasKey( validValues, defaultValue )
                    RAISE ERROR "On field <" + ::Table:ClassName() + ":" + ::Name + ">, default value '" + defaultValue + "' is not in valid values hash list"
                ENDIF
            ENDIF
            EXIT
        ENDSWITCH
    ENDIF

RETURN defaultValue

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
    GetEnabled
    Teo. Mexico 2011
*/
METHOD FUNCTION GetEnabled() CLASS TField
    IF HB_IsLogical( ::FEnabled )
        RETURN ::FEnabled
    ENDIF
    IF HB_IsBlock( ::FEnabled )
        RETURN ::FEnabled:Eval( ::FTable )
    ENDIF
RETURN .F.

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
    ENDSWITCH
RETURN NIL

/*
    GetFieldReadBlock
    Teo. Mexico 2010
*/
METHOD FUNCTION GetFieldReadBlock() CLASS TField
    IF ::FFieldReadBlock == NIL .AND. ::FCalculated
        IF __ObjHasMsgAssigned( ::FTable, "CalcField_" + ::FName )
            ::FFieldReadBlock := &("{|o,...|" + "o:CalcField_" + ::FName + "( ... ) }")
        ELSE
            IF __ObjHasMsgAssigned( ::FTable:MasterSource, "CalcField_" + ::FName )
                ::FFieldReadBlock := &("{|o,...|" + "o:MasterSource:CalcField_" + ::FName + "( ... ) }")
            ELSE
                IF !::IsDerivedFrom("TObjectField")
                    RAISE TFIELD ::Name ERROR "Unable to Solve Undefined Calculated Field: "
                ENDIF
            ENDIF
        ENDIF
    ENDIF
RETURN ::FFieldReadBlock

/*
    GetKeyVal
    Teo. Mexico 2010
*/
METHOD FUNCTION GetKeyVal( keyVal ) CLASS TField
    LOCAL AField
    LOCAL i,start,size,value

    IF ::FFieldMethodType = "A"
        IF keyVal = NIL
            keyVal := ""
            FOR EACH i IN ::FFieldArrayIndex
                keyVal += ::FTable:FieldList[ i ]:GetKeyVal()
            NEXT
        ELSE
            keyVal := PadR( keyVal, Min( Len( keyVal ), ::Size ) )
            start := 1
            FOR EACH i IN ::FFieldArrayIndex
                AField := ::FTable:FieldList[ i ]
                size := AField:Size
                value := SubStr( keyVal, start, size )
                value := AField:GetKeyVal( value )
                keyVal := Stuff( keyVal, start, size, value )
                start += Len( value )
            NEXT
        ENDIF
    ELSE
        IF keyVal = NIL
            keyVal := ::GetAsVariant()
        ENDIF
        IF HB_IsChar( keyVal )
            IF ::IsKeyIndex .AND. !::FKeyIndex:CaseSensitive
                keyVal := Upper( keyVal )
            ENDIF
            IF Len( keyVal ) < ::DBS_LEN
                keyVal := PadR( keyVal, ::DBS_LEN )
            ENDIF
        ENDIF
    ENDIF

RETURN keyVal

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

    SWITCH ValType( ::ValidValues )
    CASE "A"
    CASE "H"
        RETURN ::ValidValues
    CASE "B"
        ::FDataOfValidValues := ::ValidValues:Eval( Self:FTable )
        IF HB_IsObject( ::FDataOfValidValues )
            ::FDataOfValidValues := ::FDataOfValidValues:GetValidValues()
        ENDIF
        RETURN ::FDataOfValidValues
    CASE "O"
        IF ::ValidValues:IsDerivedFrom( "TObjectField" )
            RETURN ::ValidValues:GetValidValues()
        ENDIF
        EXIT
    ENDSWITCH

RETURN NIL

/*
    IsTableField
    Teo. Mexico 2010
*/
METHOD FUNCTION IsTableField() CLASS TField
RETURN ::FFieldMethodType = "C" .AND. !::FCalculated .AND. ::FUsingField = NIL

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
    ENDSWITCH

RETURN NIL

/*
    Reset
    Teo. Mexico 2009
*/
METHOD FUNCTION Reset() CLASS TField
    LOCAL AField
    LOCAL i
    LOCAL value
    LOCAL result := .F.
    
    IF ::FOnReset
        RETURN .F. /* ::Value of field can be NIL */
    ENDIF

    ::FOnReset := .T.
    
    IF !::FCalculated

        IF ::FDefaultValue = NIL

            /* if is a masterfield component, then *must* resolve it in the MasterSource(s) */
            IF ( result := ::IsMasterFieldComponent )

                result := ( AField := ::FTable:FindMasterSourceField( ::Name ) ) != NIL

                IF !result .AND. ::FFieldType == ftObject .AND. ::FTable:MasterSource:ClassName == Upper( ::ObjClass )
                    result := ( AField := ::FTable:MasterSource:KeyField ) != NIL
                ENDIF

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
                    
                    ::FOnReset := .F.

                    RETURN result

                ELSE

                    IF ::IsDerivedFrom("TObjectField") .AND. ::IsMasterFieldComponent
                        IF ::FTable:MasterSource = NIL
                            RAISE ERROR "MasterField component '" + ::Table:ClassName + ":" + ::Name + "' needs a MasterSource Table."
                        ELSE
    //						RAISE ERROR "MasterField component '" + ::Table:ClassName + ":" + ::Name + "' cannot be resolved in MasterSource Table (" + ::FTable:MasterSource:ClassName() + ") ."
                        ENDIF
                    ENDIF

                    IF ::IsDerivedFrom( "TObjectField" )
                        IF ::LinkedTable:KeyField != NIL
                            value := ::LinkedTable:BaseKeyField:GetDefaultValue()
                            IF value == NIL
                                value := ::LinkedTable:BaseKeyField:GetEmptyValue()
                            ENDIF
                        ENDIF
                    ELSE
                        value := ::GetDefaultValue()
                        IF value = NIL
                            value := ::GetEmptyValue()
                        ENDIF
                    ENDIF

                    result := .T.

                ENDIF
            ENDIF

        ELSE

            value := ::GetDefaultValue()

            result := .T.

        ENDIF

        ::SetBuffer( value )

        ::FChanged := .F.
        ::FWrittenValue := NIL

    ENDIF
    
    ::FOnReset := .F.

RETURN result

/*
    RevertValue
    Teo. Mexico 2010
*/
METHOD PROCEDURE RevertValue() CLASS TField
    ::WriteToTable( ::GetUndoValue() )
RETURN

/*
    SetAsVariant
    Teo. Mexico 2010
*/
METHOD PROCEDURE SetAsVariant( value ) CLASS TField
    LOCAL oldState

    IF ::IsReadOnly .OR. ::FTable:State = dsInactive .OR. !::Enabled
        RETURN
    ENDIF

    IF ::FCalculated
        ::SetData( value )
        RETURN
    ENDIF

    IF (::FTable:LinkedObjField = NIL .OR. ::FTable:LinkedObjField:Table:State = dsBrowse) .AND. ::FTable:State = dsBrowse .AND. ::FTable:autoEdit
    //IF ::FTable:State = dsBrowse .AND. ::FTable:autoEdit
        oldState := ::FTable:State
        ::FTable:Edit()
    ENDIF

    SWITCH ::FTable:State
    CASE dsBrowse

        ::SetKeyVal( value )
        
        EXIT

    CASE dsEdit
    CASE dsInsert

        SWITCH ::FFieldMethodType
        CASE "A"

            RAISE TFIELD ::Name ERROR "Trying to assign a value to a compound TField."

            EXIT

        CASE "C"

            /* Check if we are really changing values here */
            IF !value == ::GetBuffer()
                ::SetData( value )
            ENDIF

        ENDSWITCH
        
        EXIT

    OTHERWISE

        RAISE TFIELD ::Name ERROR "Table not in Edit or Insert or Reading mode"

    ENDSWITCH
    
    IF oldState != NIL
        ::FTable:Post()
    ENDIF

RETURN

/*
    SetBuffer
    Teo. Mexico 2009
*/
METHOD PROCEDURE SetBuffer( value ) CLASS TField
    LOCAL itm

    IF !::FCalculated
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
    ENDIF

RETURN

/*
    SetCloneData
    Teo. Mexico 2010
*/
METHOD PROCEDURE SetCloneData( cloneData ) CLASS TField

    ::FBuffer := cloneData["Buffer"]
    ::FChanged := cloneData["Changed"]
    ::FDefaultValue := cloneData["DefaultValue"]
    ::FWrittenValue := cloneData["WrittenValue"]

RETURN

/*
    SetData
    Teo. Mexico 2006
*/
METHOD PROCEDURE SetData( value ) CLASS TField
    LOCAL i
    LOCAL nTries
    LOCAL errObj
    LOCAL buffer

    IF ::FUsingField != NIL
        ::FUsingField:SetData( value )
        RETURN
    ENDIF

    /* SetData is only for the physical fields on the database */
    SWITCH ::FFieldMethodType
    CASE 'A'

        IF value != NIL
            RAISE TFIELD ::Name ERROR "SetData: Not allowed custom value in a compound TField..."
        ENDIF

        FOR EACH i IN ::FFieldArrayIndex
            ::FTable:FieldList[ i ]:SetData()
        NEXT
        
        RETURN

    CASE 'B'

        ::FTable:Alias:Eval( ::FFieldCodeBlock, Self, value )

        RETURN

    CASE 'C'

        EXIT

    OTHERWISE

        RETURN

    ENDSWITCH

    IF !::FCalculated .AND. AScan( { dsEdit, dsInsert }, ::Table:State ) = 0
        RAISE TFIELD ::Name ERROR "SetData(): Table not in Edit or Insert mode..."
        RETURN
    ENDIF

    IF ( ::FCalculated .AND. !::FHasCalcFieldMethod ) .OR. ::FReadOnly .OR. ::FModStamp
        RETURN
    ENDIF

    IF ::AutoIncrement

        IF value != NIL
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
            value := ::GetAutoIncrementValue()
            IF !::FAutoIncrementKeyIndex:ExistKey( ::GetKeyVal( value ) )
                EXIT
            ENDIF
            IF	(--nTries = 0)
                RAISE TFIELD ::Name ERROR "Can't create AutoIncrement Value..."
                RETURN
            ENDIF
        ENDDO

    ELSE

        IF value == NIL
            value := ::GetBuffer()
        ENDIF

    ENDIF

    /* Don't bother... */
    IF !::FCalculated .AND. ( value == ::FWrittenValue )
        RETURN
    ENDIF

    /* Check if field is a masterkey in child tables */
    /* TODO: Check childs for KeyField
    IF ::FTable:PrimaryIndex != NIL .AND. ::FTable:PrimaryIndex:UniqueKeyField == Self .AND. ::FWrittenValue != NIL
        IF !Empty( ::FTable:Childs() )
            wxhAlert( "Can't modify key <'"+::GetLabel()+"'> with " + AsString( Value ) + ";Has dependant child tables.")
            RETURN
        ENDIF
    ENDIF
    */

    IF ::FEvtOnBeforeChange = NIL
        ::FEvtOnBeforeChange := __ObjHasMsgAssigned( ::FTable, "OnBeforeChange_Field_" + ::Name )
    ENDIF

    IF ::FEvtOnBeforeChange .AND. !__ObjSendMsg( ::FTable, "OnBeforeChange_Field_" + ::Name, Self, value )
        RETURN
    ENDIF

    buffer := ::GetBuffer()

    ::SetBuffer( value )

    /* Validate before the physical writting */
    IF !::Validate( .T. )
        ::SetBuffer( buffer )  // revert the change
        RETURN
    ENDIF

    BEGIN SEQUENCE WITH {|oErr| Break( oErr ) }

        /*
         * Check for a key violation
         */
        IF ::IsPrimaryKeyField .AND. ::FUniqueKeyIndex:ExistKey( ::GetKeyVal() )
            RAISE TFIELD ::Name ERROR "Key violation."
        ENDIF
        
        ::WriteToTable( value, buffer )

        IF ::OnAfterChange != NIL
            ::OnAfterChange:Eval( ::FTable, buffer )
        ENDIF

    RECOVER USING errObj

        SHOW ERROR errObj

    END SEQUENCE

    /* masterkey field's aren't changed here */
    IF ::IsMasterFieldComponent
        ::Reset()  /* retrieve the masterfield value */
    ENDIF

RETURN

/*
    SetDbStruct
    Teo. Mexico 2010
*/
METHOD PROCEDURE SetDbStruct( aStruct ) CLASS TField
    ::FModStamp	:= aStruct[ 2 ] $ "=^+"
    ::SetDBS_LEN( aStruct[ 3 ] )
    ::SetDBS_DEC( aStruct[ 4 ] )
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
    SetEnabled
    Teo. Mexico 2011
*/
METHOD PROCEDURE SetEnabled( enabled ) CLASS TField
    IF ::FIsMasterFieldComponent .OR. ::FPrimaryKeyComponent
        RAISE TFIELD ::FName ERROR "Cannot disable a Master/Primary key component..."
    ENDIF
    ::FEnabled := enabled
RETURN

/*
    SetFieldMethod
    Teo. Mexico 2006
*/
METHOD PROCEDURE SetFieldMethod( FieldMethod, calculated ) CLASS TField
    LOCAL itm,fieldName
    LOCAL AField
    LOCAL i
    LOCAL calcMethod

    SWITCH (::FFieldMethodType := ValType( FieldMethod ))
    CASE "A"

        //::FReadOnly := .T.
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
        NEXT
        ::Name := Left( fieldName, Len( fieldName ) - 1 )
        ::FFieldCodeBlock	 := NIL
        ::FFieldReadBlock	 := NIL
        ::FFieldWriteBlock := NIL
        ::FFieldExpression := NIL

        EXIT

    CASE "B"
        //::FReadOnly := .T.
        ::FFieldArrayIndex := NIL
        ::FFieldCodeBlock	 := FieldMethod
        ::FFieldReadBlock	 := NIL
        ::FFieldWriteBlock := NIL
        ::FFieldExpression := NIL

        ::FCalculated := .T.

        EXIT

    CASE "C"

        ::FFieldArrayIndex := NIL
        ::FFieldCodeBlock := NIL

        FieldMethod := LTrim( RTrim( FieldMethod ) )
        
        calcMethod := __ObjHasMsgAssigned( ::FTable, "CalcField_" + FieldMethod )

        ::FCalculated := ( calculated == .T. ) .OR. calcMethod

        IF ! ::FCalculated

            ::FDBS_NAME := FieldMethod

            /* Check if the same FieldExpression is declared redeclared in the same table baseclass */
            FOR EACH AField IN ::FTable:FieldList
                IF !Empty( AField:FieldExpression ) .AND. ;
                     Upper( AField:FieldExpression ) == Upper( FieldMethod ) .AND. ;
                     AField:TableBaseClass == ::FTableBaseClass .AND. !::FReUseField
                    RAISE TFIELD ::Name ERROR "Atempt to Re-Use FieldExpression (same field on db) <" + ::ClassName + ":" + FieldMethod + ">"
                ENDIF
            NEXT

            ::FFieldReadBlock := FieldBlock( FieldMethod )
            ::FFieldWriteBlock := FieldBlock( FieldMethod )

        ELSE
        
            IF calcMethod
                
                ::FHasCalcFieldMethod := .T.
                ::FFieldWriteBlock := {|value| __ObjSendMsg( ::FTable, "CalcField_" + FieldMethod, value ) }
            ENDIF

        ENDIF

        fieldName := iif( Empty( ::FName ), FieldMethod, ::FName )

        IF Empty( fieldName )
            RAISE TFIELD "<Empty>" ERROR "Empty field name and field method."
        ENDIF

        ::FFieldExpression := FieldMethod
        ::Name := FieldMethod

        EXIT

    ENDSWITCH

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
        ::FEnabled := .T.
    ENDSWITCH
    
    IF ::IsDerivedFrom("TObjectField") .AND. Empty( ::FTable:GetMasterSourceClassName() )
        RAISE TFIELD ::Name ERROR "ObjectField's needs a valid MasterSource table."
    ENDIF

RETURN

/*
    SetKeyVal
    Teo. Mexico 2010
*/
METHOD FUNCTION SetKeyVal( keyVal ) CLASS TField

    IF !::FTable:OnActiveSetKeyVal()

        ::FTable:OnActiveSetKeyVal( .T. )

        IF ::IsKeyIndex

            IF ::OnSearch != NIL
                ::OnSearch:Eval( Self )
            ENDIF

            IF !Empty( keyVal )
                keyVal := ::GetKeyVal( keyVal )
                IF !::KeyIndex:KeyVal == keyVal
                    ::KeyIndex:Seek( keyVal )
                ENDIF
            ELSE
                ::FTable:DbGoTo( 0 )
            ENDIF

            IF ::FTable:LinkedObjField != NIL

                ::FTable:LinkedObjField:SetAsVariant( ::FTable:BaseKeyField:GetAsVariant() )

            ENDIF

        ELSE

            wxhAlert( "Field '" + ::GetLabel() + "' has no Index in the '" + ::FTable:ClassName() + "' Table..." )

        ENDIF

        ::FTable:OnActiveSetKeyVal( .F. )

    ENDIF

RETURN Self

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
    SetPickList
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
    ENDSWITCH
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
        ::FEnabled := .T.
    ENDSWITCH

RETURN

/*
    SetUsingField
    Teo. Mexico 2009
*/
METHOD PROCEDURE SetUsingField( usingField ) CLASS TField
    LOCAL AField := ::FTable:FieldByName( usingField )
    IF AField != NIL
        ::FUsingField := AField
    ENDIF
RETURN

/*
    SetValidValues
    Teo. Mexico 2011
*/
METHOD PROCEDURE SetValidValues( validValues ) CLASS TField
    ::ValidValues := validValues
RETURN

/*
    WriteToTable
    Teo. Mexico 2010
*/
METHOD PROCEDURE WriteToTable( value, buffer ) CLASS TField

    //IF !( ::FTable:MasterKeyField = NIL .AND. ::IsPrimaryKeyField .AND. Empty( value ) )

        /* The physical write to the field */
        ::FTable:Alias:Eval( ::FFieldWriteBlock, value )

        ::FWrittenValue := ::GetBuffer() // If TFieldString then we make sure that size values are equal

        /* fill undolist */
        IF ::FTable:State = dsEdit
            IF !HB_HHasKey( ::FTable:UndoList, ::FName ) .AND. PCount() > 1
                ::FTable:UndoList[ ::FName ] := buffer
                ::FChanged := ! value == ::FTable:UndoList[ ::FName ]
            ENDIF
        ENDIF

        /*
         * Check if has to propagate change to child sources
         */
        IF ::FTable:PrimaryIndex != NIL .AND. ::FTable:PrimaryIndex:UniqueKeyField == Self
            ::FTable:SyncDetailSources()
        ENDIF

    //ENDIF

RETURN

/*
    Validate
    Teo. Mexico 2011
*/
METHOD FUNCTION Validate( showAlert ) CLASS TField
    LOCAL validValues
    LOCAL value
    LOCAL result := .T.

    IF ::Enabled

        value := ::GetAsVariant()
        
        IF ::FRequired .AND. Empty( value )
            IF showAlert == .T.
                wxhAlert( ::FTable:ClassName + ": '" + ::GetLabel() + "' <empty field required value>" )
            ENDIF
            RETURN .F.
        ENDIF

        IF ::Unique
            IF Empty( value )
                IF showAlert == .T.
                    wxhAlert( ::FTable:ClassName + ": '" + ::GetLabel() + "' <empty UNIQUE INDEX key value>" )
                ENDIF
                RETURN .F.
            ENDIF
            IF ::FUniqueKeyIndex:ExistKey( ::GetKeyVal( value ) )
                IF showAlert == .T.
                    wxhAlert( ::FTable:ClassName + ": '" + ::GetLabel() + "' <key value already exists> '" + AsString( value ) + "'")
                ENDIF
                RETURN .F.
            ENDIF
        ENDIF

        IF ::ValidValues != NIL

            validValues := ::GetValidValues()

            IF !Empty( validValues )
                SWITCH ValType( validValues )
                CASE 'A'
                    result := AScan( validValues, {|e| e == value } ) > 0
                    EXIT
                CASE 'H'
                    result := AScan( HB_HKeys( validValues ), {|e| e == value } ) > 0
                    EXIT
                OTHERWISE
                    wxhAlert( ::FTable:ClassName + ": '" + ::GetLabel() + "' <Illegal value in 'ValidValues'> " )
                    RETURN .F.
                ENDSWITCH

                IF !result
                    IF showAlert == .T.
                        wxhAlert( ::FTable:ClassName + ": '" + ::GetLabel() + "' <value given not in 'ValidValues'> : '" + AsString( value ) + "'" )
                    ENDIF
                    RETURN .F.
                ENDIF
            ENDIF

        ENDIF

        IF ::OnValidate != NIL
            result := ::OnValidate:Eval( Self )
            IF !result .AND. ::OnValidateWarn != NIL
                wxhAlert( ::FTable:ClassName + ": '" + ::GetLabel() + E"' OnValidate:\n<" + ::OnValidateWarn + "> " )
            ENDIF
        ENDIF

    ENDIF

RETURN result

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
    METHOD GetEmptyValue INLINE Space( ::Size )
    METHOD GetAsNumeric INLINE Val( ::GetAsVariant() )
    METHOD GetSize()
    METHOD SetAsNumeric( n ) INLINE ::SetAsVariant( LTrim( Str( n ) ) )
    METHOD SetBuffer( buffer )
    METHOD SetDBS_LEN( dbs_Len )
    METHOD SetDefaultValue( DefaultValue )
    METHOD SetSize( size )
PUBLIC:
    METHOD GetAsString
    METHOD IndexExpression()
    PROPERTY AsNumeric READ GetAsNumeric WRITE SetAsNumeric
PUBLISHED:
    PROPERTY Size READ GetSize WRITE SetSize
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
    ENDSWITCH

RETURN Result

/*
    GetSize
    Teo. Mexico 2010
*/
METHOD FUNCTION GetSize() CLASS TStringField
    LOCAL i

    IF ::FSize = NIL
        IF ::FFieldMethodType = "A"
            ::FSize := 0
            FOR EACH i IN ::FFieldArrayIndex
                ::FSize += ::FTable:FieldList[ i ]:Size
            NEXT
        ENDIF
    ENDIF

RETURN ::FSize

/*
    IndexExpression
    Teo. Mexico 2010
*/
METHOD FUNCTION IndexExpression() CLASS TStringField
    LOCAL exp
    LOCAL i
    
    IF ::FFieldMethodType = "A"
        exp := ""
        FOR EACH i IN ::FFieldArrayIndex
            exp += iif( Len( exp ) = 0, "", "+" ) + ::FTable:FieldList[ i ]:IndexExpression
        NEXT
    ELSE
        IF ::IsMasterFieldComponent .OR. ( ::IsKeyIndex .AND. ::FKeyIndex:CaseSensitive )
            exp := ::FFieldExpression
        ELSE
            IF ::FFieldExpression = NIL
                exp := "<error: IndexExpression on '" + ::Name + "'>"
            ELSE
                exp := "Upper(" + ::FFieldExpression + ")"
            ENDIF
        ENDIF
    ENDIF

RETURN exp

/*
    SetBuffer
    Teo. Mexico 2009
*/
METHOD PROCEDURE SetBuffer( buffer ) CLASS TStringField
    IF ::IsDerivedFrom("TMemoField")
        Super:SetBuffer( buffer )
    ELSE
        Super:SetBuffer( PadR( buffer, ::Size ) )
    ENDIF
RETURN

/*
    SetDBS_LEN
    Teo. Mexico 2010
*/
METHOD PROCEDURE SetDBS_LEN( dbs_Len ) CLASS TStringField
    ::FDBS_LEN := dbs_Len
    IF ::FSize = NIL
        ::FSize := dbs_Len
    ENDIF
RETURN

/*
    SetDefaultValue
    Teo. Mexico 2006
*/
METHOD PROCEDURE SetDefaultValue( DefaultValue ) CLASS TStringField

    ::FDefaultValue := DefaultValue
    
    ::FBuffer := NIL /* to force ::Reset on next read */

RETURN

/*
    SetSize
    Teo. Mexico 2010
*/
METHOD PROCEDURE SetSize( size ) CLASS TStringField
    ::FSize := size
    ::FDBS_LEN := size
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
    DATA FSize INIT 0
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
    DATA FDBS_LEN INIT 15   // 000000000000.00
    DATA FDBS_DEC INIT 2
    DATA FDBS_TYPE INIT "N"
    DATA FType INIT "Numeric"
    DATA FValType INIT "N"
    METHOD GetEmptyValue BLOCK {|| 0 }
    METHOD StrFormat( value ) INLINE Str( value )
PUBLIC:

    METHOD GetAsString
    METHOD GetKeyVal( keyVal )
    METHOD IndexExpression()
    METHOD SetAsVariant( variant )

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
        Result := ::StrFormat( Value )
    ENDIF

RETURN Result

/*
    GetKeyVal
    Teo. Mexico 2010
*/
METHOD FUNCTION GetKeyVal( keyVal ) CLASS TNumericField
    SWITCH ValType( keyVal )
    CASE 'C'
        RETURN keyVal
    CASE 'N'
        RETURN Str( keyVal, ::FDBS_LEN )
    CASE 'U'
        RETURN Str( ::GetAsVariant(), ::FDBS_LEN )
    ENDSWITCH

    RAISE TFIELD ::GetLabel() ERROR "Don't know how to convert to key value..."

RETURN NIL

/*
    IndexExpression
    Teo. Mexico 2010
*/
METHOD FUNCTION IndexExpression() CLASS TNumericField
RETURN "Str(" + ::FieldExpression + ")"

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
    ENDSWITCH

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
    DATA FSize INIT 4
    DATA FType INIT "Integer"
    METHOD StrFormat( value ) INLINE HB_StrFormat( "%d", value )
PUBLIC:

    METHOD GetKeyVal( keyVal )
    METHOD IndexExpression()
    METHOD SetAsVariant( variant )

    PROPERTY AsInteger READ GetAsVariant WRITE SetAsVariant
    PROPERTY Size READ FSize

PUBLISHED:
ENDCLASS

/*
    GetKeyVal
    Teo. Mexico 2010
*/
METHOD FUNCTION GetKeyVal( keyVal ) CLASS TIntegerField

    SWITCH ValType( keyVal )
    CASE 'C'
        RETURN keyVal
    CASE 'N'
        RETURN HB_NumToHex( keyVal, 8 )
    CASE 'U'
        RETURN HB_NumToHex( ::GetAsVariant(), 8 )
    ENDSWITCH

    RAISE TFIELD ::GetLabel() ERROR "Don't know how to convert to key value..."

RETURN NIL

/*
    IndexExpression
    Teo. Mexico 2010
*/
METHOD FUNCTION IndexExpression() CLASS TIntegerField
RETURN "HB_NumToHex(" + ::FFieldExpression + ",8)"

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
    ENDSWITCH

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
    METHOD StrFormat( value ) INLINE HB_StrFormat( "%10."+Chr( 48 + ::FDBS_DEC )+"f", value )
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
    DATA FSize INIT 1
    DATA FType INIT "Logical"
    DATA FValType INIT "L"
    METHOD GetEmptyValue BLOCK {|| .F. }
PUBLIC:

    METHOD GetKeyVal( keyVal )
    METHOD IndexExpression()

    PROPERTY AsBoolean READ GetAsVariant WRITE SetAsVariant
    PROPERTY Size READ FSize

PUBLISHED:
ENDCLASS

/*
    GetKeyVal
    Teo. Mexico 2010
*/
METHOD FUNCTION GetKeyVal( keyVal ) CLASS TLogicalField

    SWITCH ValType( keyVal )
    CASE 'C'
        RETURN keyVal
    CASE 'L'
        RETURN iif( keyVal, "T", "F" )
    CASE 'U'
        RETURN iif( ::GetAsVariant(), "T", "F" )
    ENDSWITCH

    RAISE TFIELD ::GetLabel() ERROR "Don't know how to convert to key value..."

RETURN NIL

/*
    IndexExpression
    Teo. Mexico 2010
*/
METHOD FUNCTION IndexExpression() CLASS TLogicalField
RETURN "iif(" + ::FFieldExpression + ",'T','F')"

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
    DATA FDefaultValue INIT {|| Date() }
    DATA FSize INIT 8					// Size on index is 8 = len of DToS()
    DATA FType INIT "Date"
    DATA FValType INIT "D"
    METHOD GetEmptyValue BLOCK {|| CtoD("") }
PUBLIC:

    METHOD GetAsString INLINE FDateS( ::GetAsVariant() )
    METHOD GetKeyVal( keyVal )
    METHOD IndexExpression()
    METHOD SetAsVariant( variant )

    PROPERTY Size READ FSize

PUBLISHED:
ENDCLASS

/*
    GetKeyVal
    Teo. Mexico 2010
*/
METHOD FUNCTION GetKeyVal( keyVal ) CLASS TDateField

    SWITCH ValType( keyVal )
    CASE 'C'
        RETURN keyVal
    CASE 'D'
        RETURN DToS( keyVal )
    CASE 'U'
        RETURN DToS( ::GetAsVariant() )
    ENDSWITCH

    RAISE TFIELD ::GetLabel() ERROR "Don't know how to convert to key value..."

RETURN NIL

/*
    IndexExpression
    Teo. Mexico 2010
*/
METHOD FUNCTION IndexExpression() CLASS TDateField
RETURN "DToS(" + ::FFieldExpression + ")"

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
    ENDSWITCH

RETURN

/*
    ENDCLASS TDateField
*/

/*
    TDateTimeField
    Teo. Mexico 2009
*/
CLASS TDateTimeField FROM TField
PRIVATE:
PROTECTED:
    DATA FSize INIT 23
    DATA FDBS_LEN INIT 8
    DATA FDBS_DEC INIT 0
    DATA FDBS_TYPE INIT "@"
    DATA FDefaultValue INIT {|| HB_DateTime() }
    DATA FType INIT "DateTime"
    DATA FValType INIT "C"
    METHOD GetAsDate() INLINE HB_TToD( ::Value )
    METHOD GetAsString() INLINE HB_TSToStr( ::Value )
    METHOD GetEmptyValue BLOCK {|| HB_CToT("") }
    METHOD GetTime
    METHOD SetTime( cTime )
PUBLIC:

    CLASSDATA fmtDate INIT "YYYY-MM-DD"
    CLASSDATA fmtTime

    METHOD GetKeyVal( keyVal )
    METHOD IndexExpression()
    METHOD SetAsVariant( variant )

    PROPERTY AsDate READ GetAsDate
    PROPERTY Size READ FSize
    PROPERTY Time READ GetTime WRITE SetTime

PUBLISHED:
ENDCLASS

/*
    GetKeyVal
    Teo. Mexico 2010
*/
METHOD FUNCTION GetKeyVal( keyVal ) CLASS TDateTimeField

    SWITCH ValType( keyVal )
    CASE 'C'
        RETURN keyVal
    CASE 'T'
        RETURN HB_TToS( keyVal )
    CASE 'U'
        RETURN HB_TToS( ::GetAsVariant() )
    ENDSWITCH

    RAISE TFIELD ::GetLabel() ERROR "Don't know how to convert to key value..."

RETURN HB_TToS( keyVal )

/*
    GetTime
    Teo. Mexico 2011
*/
METHOD GetTime CLASS TDateTimeField
    LOCAL cTime := "00:00:00"
    LOCAL time
    
    time := ::GetAsVariant()
    
    IF !Empty( time )
        cTime := SubStr( HB_TToS( time ), 9, 6 )
        cTime := Left( cTime, 2 ) + ":" + SubStr( cTime, 3, 2 ) + ":" + SubStr( cTime, 5, 2 )
    ENDIF

RETURN cTime

/*
    IndexExpression
    Teo. Mexico 2010
*/
METHOD FUNCTION IndexExpression() CLASS TDateTimeField
RETURN "HB_TToS(" + ::FFieldExpression + ")"

/*
    SetAsVariant
    Teo. Mexico 2009
*/
METHOD PROCEDURE SetAsVariant( variant ) CLASS TDateTimeField
    LOCAL cTime

    SWITCH ValType( variant )
    CASE 'T'
        Super:SetAsVariant( variant )
        EXIT
    CASE 'C'
        variant := RTrim( variant )
        IF NumToken( variant ) > 1
            variant := HB_CToT( variant, ::fmtDate, ::fmtTime )
        ELSE
            variant := HB_SToT( variant )
        ENDIF
        Super:SetAsVariant( variant )
        EXIT
    CASE 'D'
        cTime := ::GetTime()
        Super:SetAsVariant( HB_DToT( variant, cTime ) )
        EXIT
    CASE 'N'
        Super:SetAsVariant( HB_NToT( variant ) )
        EXIT
    ENDSWITCH

RETURN

/*
    SetTime
    Teo. Mexico 2011
*/
METHOD PROCEDURE SetTime( cTime ) CLASS TDateTimeField
    ::SetAsVariant( HB_DToT( ::Value, cTime ) )
RETURN

/*
    EndClass TDateTimeField
*/

/*
    TModTimeField
    Teo. Mexico 2009
*/
CLASS TModTimeField FROM TDateTimeField
PRIVATE:
PROTECTED:
    DATA FDBS_LEN INIT 8
    DATA FDBS_DEC INIT 0
    DATA FDBS_TYPE INIT "="
    DATA FModStamp	INIT .T.        // Field is automatically mantained (dbf layer)
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
    DATA FObjClass
    DATA FLinkedTable									 /* holds the Table object */
    DATA FLinkedTableMasterSource
    METHOD SetLinkedTableMasterSource( linkedTableMasterSource )
    METHOD SetObjClass( objValue ) INLINE ::FObjClass := objValue
PROTECTED:
    DATA FCalcMethod
    DATA FFieldType INIT ftObject
    DATA FType INIT "ObjectField"
    DATA FValidValuesLabelField
    DATA FValType INIT "O"
    METHOD GetDBS_LEN INLINE ::BaseKeyField():DBS_LEN
    METHOD GetDBS_TYPE INLINE ::BaseKeyField():DBS_TYPE
    METHOD GetLinkedTable
    METHOD GetEmptyValue() INLINE ::BaseKeyField():EmptyValue
    METHOD GetFieldReadBlock()
PUBLIC:
    METHOD BaseKeyField()	// Returns the non-TObjectField associated to this obj
    METHOD DataObj
    METHOD GetKeyVal( keyVal )
    METHOD GetAsString							//INLINE ::LinkedTable:KeyField:AsString()
    METHOD GetAsVariant( ... )
    METHOD GetValidValues()
    METHOD IndexExpression()
    METHOD SetValidValues( validValues, labelField )
    PROPERTY LinkedTable READ GetLinkedTable
    PROPERTY LinkedTableAssigned READ FLinkedTableMasterSource != NIL
    PROPERTY LinkedTableMasterSource READ FLinkedTableMasterSource WRITE SetLinkedTableMasterSource
    PROPERTY ObjClass READ FObjClass WRITE SetObjClass
    PROPERTY Size READ BaseKeyField():Size
    PROPERTY ValidValuesLabelField READ FValidValuesLabelField
PUBLISHED:
ENDCLASS

/*
    BaseKeyField
    Teo. Mexico 2011
*/
METHOD FUNCTION BaseKeyField() CLASS TObjectField

    SWITCH ValType( ::ObjClass )
    CASE "B"
        RETURN ::ObjClass:Eval( ::FTable ):KeyField
    CASE "O"
        RETURN ::ObjClass:KeyField
    CASE "C"
        RETURN ::GetLinkedTable:BaseKeyField
    ENDSWITCH

RETURN NIL

/*
    DataObj
    Syncs the Table with the key in buffer
    Teo. Mexico 2009
*/
METHOD FUNCTION DataObj CLASS TObjectField
    LOCAL linkedTable
    LOCAL linkedObjField
    LOCAL keyVal

    IF ::FCalculated
        linkedTable := ::FieldReadBlock:Eval( ::FTable )
    ELSE
        linkedTable := ::GetLinkedTable()
    ENDIF

    IF ::IsMasterFieldComponent .AND. ::FTable:FUnderReset

    ELSE
        /* 
            to sure a resync with linkedTable mastersource table
            on TObjectField's that have a mastersource field (another TObjectField)
            in the same table
        */
        IF !Empty( linkedTable:MasterSource ) .AND. !Empty( linkedTable:MasterSource:LinkedObjField ) .AND. linkedTable:MasterSource:LinkedObjField:Table == ::FTable
            linkedTable:MasterSource:LinkedObjField:DataObj()
        ENDIF
        keyVal := ::GetKeyVal()
        /* Syncs with the current value */
        IF !::FTable:MasterSource == linkedTable .AND. !linkedTable:BaseKeyField:KeyVal == keyVal
            linkedObjField := linkedTable:LinkedObjField
            linkedTable:LinkedObjField := NIL
            linkedTable:BaseKeyField:SetKeyVal( keyVal )
            linkedTable:LinkedObjField := linkedObjField
        ENDIF
    ENDIF

RETURN linkedTable

/*
    GetAsVariant
    Teo. Mexico 2010
*/
METHOD FUNCTION GetAsVariant( ... ) CLASS TObjectField
    LOCAL variant

    variant := Super:GetAsVariant( ... )

    IF HB_IsObject( variant )

        IF variant:IsDerivedFrom("TObjectField")
            RETURN variant:DataObj:GetAsVariant()
        ELSEIF variant:IsDerivedFrom("TTable")
            RETURN variant:BaseKeyField:GetAsVariant()
        ENDIF

    ENDIF

RETURN variant

/*
    GetKeyVal
    Teo. Mexico 2009
*/
METHOD FUNCTION GetKeyVal( keyVal ) CLASS TObjectField

    IF keyVal = NIL
        keyVal := ::GetAsVariant()
    ENDIF

RETURN ::BaseKeyField:GetKeyVal( keyVal )

/*
    GetAsString
    Teo. Mexico 2009
*/
METHOD FUNCTION GetAsString CLASS TObjectField
RETURN ::DataObj:GetAsString()

/*
    GetFieldReadBlock
    Teo. Mexico 2010
*/
METHOD FUNCTION GetFieldReadBlock() CLASS TObjectField
    
    IF ::FFieldReadBlock = NIL .AND. Super:GetFieldReadBlock() = NIL
        ::FFieldReadBlock := {|| ::LinkedTable }
    ENDIF

RETURN ::FFieldReadBlock

/*
    GetLinkedTable
    Teo. Mexico 2009
*/
METHOD FUNCTION GetLinkedTable CLASS TObjectField
    LOCAL linkedTableMasterSource
    LOCAL className
    LOCAL fld

    IF ::FLinkedTable == NIL

        IF Empty( ::FObjClass )
            RAISE TFIELD ::Name ERROR "TObjectField has not a ObjClass value."
        ENDIF

        /*
         * Solve using the default ObjClass
         */
        SWITCH ValType( ::FObjClass )
        CASE 'C'

            IF ::FTable:MasterSource != NIL .AND. ::FTable:MasterSource:IsDerivedFrom( ::FObjClass ) .AND. ::IsMasterFieldComponent
                ::FLinkedTable := ::FTable:MasterSource
            ELSE
                IF ::FLinkedTableMasterSource != NIL
                    linkedTableMasterSource := ::FLinkedTableMasterSource
                ELSEIF ::FTable:IsDerivedFrom( ::Table:GetMasterSourceClassName() ) //( ::FObjClass ) )
                    linkedTableMasterSource := ::FTable
                ENDIF

                ::FLinkedTable := __ClsInstFromName( ::FObjClass )

                IF ::FLinkedTable:IsDerivedFrom( ::FTable:ClassName() )
                    RAISE TFIELD ::Name ERROR "Denied: To create TObjectField's linked table derived from the same field's table class."
                ENDIF

                /* check if we still need a mastersource and it exists in TObjectField's Table */
                IF Empty( linkedTableMasterSource )
                    className := ::FLinkedTable:GetMasterSourceClassName()
                    IF ::FTable:IsDerivedFrom( className )
                        linkedTableMasterSource := ::FTable
                    ELSEIF !Empty( className ) .AND. ! Empty( fld := ::FTable:FieldByObjClass( className, .T. ) )
                        linkedTableMasterSource := fld
                    ENDIF
                ENDIF
                ::FLinkedTable:New( linkedTableMasterSource )
            ENDIF
            EXIT
        CASE 'B'
            ::FLinkedTable := ::FObjClass:Eval( ::FTable )
            EXIT
        CASE 'O'
            ::FLinkedTable := ::FObjClass
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
    GetValidValues
    Teo. Mexico 2009
*/
METHOD FUNCTION GetValidValues() CLASS TObjectField
    LOCAL hValues
    LOCAL fld

    IF ::FValidValuesLabelField == .T.
        hValues := {=>}
        fld := ::LinkedTable:FieldByName( ::ValidValues )
        ::LinkedTable:StatePush()
        ::LinkedTable:DbGoTop()
        WHILE !::LinkedTable:Eof()
            hValues[ ::LinkedTable:KeyVal ] := fld:Value
            ::LinkedTable:DbSkip()
        ENDDO
        ::LinkedTable:StatePop()
        RETURN hValues
    ENDIF
    
RETURN Super:GetValidValues()

/*
    IndexExpression
    Teo. Mexico 2010
*/
METHOD FUNCTION IndexExpression() CLASS TObjectField
RETURN ::FFieldExpression

/*
    SetLinkedTableMasterSource
    Teo. Mexico 2011
*/
METHOD PROCEDURE SetLinkedTableMasterSource( linkedTableMasterSource ) CLASS TObjectField

    SWITCH ValType( linkedTableMasterSource )
    CASE "C"
        linkedTableMasterSource := ::Table:FieldByName( linkedTableMasterSource )
    CASE "O"
        IF linkedTableMasterSource:IsDerivedFrom( "TObjectField" ) .OR. linkedTableMasterSource:IsDerivedFrom( "TTable" )
            EXIT
        ENDIF
    OTHERWISE
        RAISE ERROR "Invalid master source value..."
    ENDSWITCH

    ::FLinkedTableMasterSource := linkedTableMasterSource

RETURN

/*
    SetValidValues
    Teo. Mexico 2011
*/
METHOD PROCEDURE SetValidValues( validValues, labelField ) CLASS TObjectField
    ::ValidValues := validValues
    ::FValidValuesLabelField := labelField
RETURN

/*
    ENDCLASS TObjectField
*/

/*
    TVariantField
    Teo. Mexico 2010
*/
CLASS TVariantField FROM TField
PRIVATE:
PROTECTED:
    DATA FType INIT "Variant"
PUBLIC:
PUBLISHED:
ENDCLASS

/*
    ENDCLASS TFloatField
*/
