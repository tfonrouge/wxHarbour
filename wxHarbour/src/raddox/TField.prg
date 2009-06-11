/*
  TField
  Teo. Mexico 2009
*/

#ifdef __XHARBOUR__
  #include "wx_hbcompat.ch"
#endif

#include "hbclass.ch"
#include "property.ch"
#include "raddox.ch"
#include "xerror.ch"

/*
  TODO: Check for a correct validation for FieldExpression, it can contain any valid
        Harbour statement/formula, and loose checking is done on SetFieldMethod
*/

#xcommand RAISE TFIELD <name> ERROR <cDescription> => ;
          RAISE ERROR E"\nTable: <" + ::FTable:TableName + ">, FieldExpression: <" + <name> + ">" + ;
                      E"\n" + ;
                      <cDescription> + E"\n" ;
                SUBSYSTEM ::ClassName + "<" + ::Name + ">"  ;
                OPERATION E"\n" + ProcName(0)+"(" + LTrim(Str(ProcLine(0))) + ")"

/*
  TField
  Teo. Mexico 2009
*/
CLASS TField
PRIVATE:

  DATA FActive  INIT .F.
  DATA FAutoIncrementKeyIndex
  DATA FDataOfValidValues
  DATA FDescription INIT ""
  DATA FFieldCodeBlock                  // Code Block
  DATA FFieldWriteBlock                 // Code Block to do WRITE
  DATA FFieldExpression                 // Literal Field expression on the Database
  DATA FGetItPick                       // codeblock to help to pick a value
  DATA FGroup                           // A Text label for grouping
  DATA FIsMasterFieldComponent INIT .F. // Field is a MasterField only 'C' TFields
  DATA FIsTheMasterSource INIT .F.      // Field is TObjectField type and is the MasterSource Table
  DATA FKeyIndex
  DATA FLabel
  DATA FModStamp  INIT .F.              // Field is automatically mantained (dbf layer)
  DATA FPrimaryKeyComponent INIT .F.    // Field is included in a Array of fields for a Primary Index Key
  DATA FPublished INIT .T.              // Logical: Appears in user field selection
  DATA FReadOnly  INIT .F.
  DATA FRequired INIT .F.
  DATA FUniqueKeyIndex
  DATA FUsingField						// Field used on Calculated Field
  METHOD GetAutoIncrement INLINE ::FAutoIncrementKeyIndex != NIL
  METHOD GetAutoIncrementValue
  METHOD GetFieldMethod
  METHOD GetIsKeyIndex INLINE ::FKeyIndex != NIL
  METHOD GetIsPrimaryKeyField INLINE ::Table:PrimaryKeyField == Self
  METHOD GetLabel INLINE iif( ::FLabel = NIL, ::FName, ::FLabel )
  METHOD GetReadOnly INLINE ::FReadOnly
  METHOD GetUnique INLINE ::FUniqueKeyIndex != NIL
  METHOD SetAutoIncrementKeyIndex( Index ) INLINE ::FAutoIncrementKeyIndex := Index
  METHOD SetDescription( Description ) INLINE ::FDescription := Description
  METHOD SetFieldMethod( FieldMethod )
  METHOD SetGetItPick( block )
  METHOD SetGroup( Group ) INLINE ::FGroup := Group
  METHOD SetIsMasterFieldComponent( IsMasterFieldComponent )
  METHOD SetKeyIndex( Index ) INLINE ::FKeyIndex := Index
  METHOD SetLabel( label ) INLINE ::FLabel := label
  METHOD SetName( Name )
  METHOD SetPrimaryKeyComponent( PrimaryKeyComponent )
  METHOD SetPublished( Published ) INLINE ::FPublished := Published
  METHOD SetReadOnly( ReadOnly ) INLINE ::FReadOnly := ReadOnly
  METHOD SetUniqueKeyIndex( Index ) INLINE ::FUniqueKeyIndex := Index
  METHOD SetUsingField( usingField )

PROTECTED:

  DATA FBuffer
  DATA FTableBaseClass
  DATA FCalculated INIT .F.
  DATA FDefaultValue
  DATA FFieldArray                    // Array of TField's objects
  DATA FFieldMethodType
  DATA FFieldReadBlock                // Code Block to do READ

  DATA FName INIT ""
  DATA FTable
  DATA FValType INIT "U"
  DATA FWrittenValue

  METHOD GetAsVariant
  METHOD GetDefaultValue
  METHOD GetEmptyValue BLOCK {|| NIL }
  METHOD SetAsString( string ) VIRTUAL
  METHOD SetBuffer( buffer )
  METHOD SetDefaultValue( DefaultValue ) INLINE ::FDefaultValue := DefaultValue
  METHOD SetRequired( Required ) INLINE ::FRequired := Required

PUBLIC:

  DATA Picture

  CONSTRUCTOR New( Table )

  METHOD AsIndexKeyVal INLINE ::Need_To_Declare_AsIndexKeyVal()
  METHOD Delete
  METHOD GetAsString INLINE "<" + ::ClassName + ">"
  METHOD GetBuffer
  METHOD GetEditText
  METHOD GetData
  METHOD GetItDoPick
  METHOD GetValidValues
  METHOD IsValid( Value )
  METHOD Reset
  METHOD SetAsVariant( Value )
  METHOD SetData( Value )
  METHOD SetEditText( Text )
  METHOD ValidateFieldInfo VIRTUAL

  PROPERTY AsString READ GetAsString WRITE SetAsString
  PROPERTY AsVariant READ GetAsVariant WRITE SetAsVariant
  PROPERTY Calculated READ FCalculated
  PROPERTY DisplayText READ GetEditText
  PROPERTY EmptyValue READ GetEmptyValue
  PROPERTY GetItPick READ FGetItPick WRITE SetGetItPick
  PROPERTY IsKeyIndex READ GetIsKeyIndex
  PROPERTY IsPrimaryKeyField READ GetIsPrimaryKeyField
  PROPERTY IsTheMasterSource READ FIsTheMasterSource
  PROPERTY Text READ GetEditText WRITE SetEditText
  PROPERTY Value READ GetAsVariant WRITE SetAsVariant

PUBLISHED:

  DATA OnGetIndexKeyVal
  /*
   * Event holders
   */
  DATA OnGetText      // Params: Sender: TField, Text: String
  DATA OnSetText      // Params: Sender: TField, Text: String
  DATA OnSetValue     // Parama:
  DATA OnBeforeChange
  DATA OnChange       // Params: Sender: TField
  DATA OnValidate     // Params: Sender: TField
  
  DATA ValidValues

  PROPERTY AutoIncrement READ GetAutoIncrement
  PROPERTY AutoIncrementKeyIndex READ FAutoIncrementKeyIndex WRITE SetAutoIncrementKeyIndex
  PROPERTY TableBaseClass READ FTableBaseClass
  PROPERTY DefaultValue READ GetDefaultValue WRITE SetDefaultValue
  PROPERTY Description READ FDescription WRITE SetDescription
  PROPERTY FieldArray READ FFieldArray WRITE SetFieldMethod
  PROPERTY FieldCodeBlock READ FFieldCodeBlock WRITE SetFieldMethod
  PROPERTY FieldExpression READ FFieldExpression WRITE SetFieldMethod
  PROPERTY FieldMethod READ GetFieldMethod WRITE SetFieldMethod
  PROPERTY FieldMethodType READ FFieldMethodType
  PROPERTY FieldReadBlock READ FFieldReadBlock
  PROPERTY Group READ FGroup WRITE SetGroup
  PROPERTY IsMasterFieldComponent READ FIsMasterFieldComponent WRITE SetIsMasterFieldComponent
  PROPERTY KeyIndex READ FKeyIndex WRITE SetKeyIndex
  PROPERTY Label READ GetLabel WRITE SetLabel
  PROPERTY PrimaryKeyComponent READ FPrimaryKeyComponent WRITE SetPrimaryKeyComponent
  PROPERTY Published READ FPublished WRITE SetPublished
  PROPERTY Name READ FName WRITE SetName
  PROPERTY ReadOnly READ GetReadOnly WRITE SetReadOnly
  PROPERTY Required READ FRequired WRITE SetRequired
  PROPERTY Table READ FTable
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

  ::FTable   := Table
  ::FTableBaseClass := Table:BaseClass

  AAdd( ::FTable:FieldList, Self )

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
  Delete
  Teo. Mexico 2009
*/
METHOD PROCEDURE Delete CLASS TField
  LOCAL errObj

  IF AScan( { dsEdit, dsInsert }, ::Table:State ) = 0
    ::Table:Table_Not_In_Edit_or_Insert_mode()
    RETURN
  ENDIF

  IF !::FFieldMethodType = 'C' .OR. ::FCalculated .OR. ::FFieldWriteBlock = NIL .OR. ::FModStamp
    RETURN
  ENDIF

  TRY

    ::Table:Alias:Eval( ::FFieldWriteBlock, ::EmptyValue() )

    ::Reset()

  CATCH errObj

    Throw( errObj )

  END

RETURN

/*
  GetAsVariant
  Teo. Mexico 2006
*/
METHOD FUNCTION GetAsVariant CLASS TField
  LOCAL AField
  LOCAL Result
  LOCAL value

  SWITCH ::FFieldMethodType
  CASE "A"
    /*
     * This will ONLY work when all the items are of TStringField type
     */
    Result := ""
    FOR EACH AField IN ::FFieldArray
      value := AField:GetAsVariant()
      IF !HB_IsString( value )
        RAISE TFIELD AField:Name ERROR "Error building Variant in compound field (not a string field)."
      ELSE
        Result += value
      ENDIF
    NEXT
    EXIT
  CASE "B"
	IF ::FUsingField = NIL
	  Result := ::FTable:Alias:Eval( ::FFieldCodeBlock, ::FTable )
	ELSE
	  Result := ::FFieldCodeBlock:Eval( ::FUsingField:Value )
	ENDIF
    EXIT
  CASE 'C'
    IF ::FCalculated
      IF ::FFieldReadBlock = NIL
        IF __ObjHasMsg( Self:FTable, "CalcField_" + ::FName )
          ::FFieldReadBlock := &("{|o|" + "o:CalcField_" + ::FName + " }")
        ELSE
          IF __ObjHasMsg( Self:FTable:MasterSource, "CalcField_" + ::FName )
            ::FFieldReadBlock := &("{|o|" + "o:MasterSource:CalcField_" + ::FName + " }")
          ELSE
            IF __ObjHasMsg( Self:FTable:MasterSource, "Field_" + ::FName )
              ::FFieldReadBlock := &("{|o|" + "o:MasterSource:Field_" + ::FName + ":GetAsVariant() }")
            ELSE
              IF Empty( ::FFieldExpression )
                RAISE TFIELD ::Name ERROR "Unable to Solve Undefined Calculated Field: "
              ELSE
                ::FFieldReadBlock := &("{|| " + ::FFieldExpression + " }")
              ENDIF
            ENDIF
          ENDIF
        ENDIF
      ENDIF
      //Result := ::FFieldReadBlock:Eval( ::FTable )
      Result := ::FTable:Alias:Eval( ::FFieldReadBlock, ::FTable )
    ELSE
      Result := ::GetBuffer()
    ENDIF
    EXIT
#ifdef __XHARBOUR__
  DEFAULT
#else
  OTHERWISE
#endif
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

  value := ::Table:Alias:Get4SeekLast(  {|| ::FieldReadBlock:Eval() }, AIndex:MasterKeyString, AIndex:Name )

  value := Inc( value )

RETURN value

/*
  GetBuffer
  Teo. Mexico 2009
*/
METHOD FUNCTION GetBuffer CLASS TField

  /* FieldArray's doesn't have a absolute FBuffer */
  IF ::FFieldMethodType = "A"
    RETURN NIL
  ENDIF

  IF ::FBuffer = NIL
    ::Reset()
  ENDIF

RETURN ::FBuffer

/*
  GetData
  Teo. Mexico 2006
*/
METHOD FUNCTION GetData CLASS TField
  LOCAL AField

  SWITCH ::FFieldMethodType
  CASE 'B'
    ::SetBuffer( ::GetAsVariant() )
    EXIT
  CASE 'C'
    IF ::FCalculated
      ::SetBuffer( ::GetAsVariant() )
    ELSE
      ::FWrittenValue := ::Table:Alias:Eval( ::FFieldReadBlock )
      ::SetBuffer( ::FWrittenValue )
    ENDIF
    EXIT
  CASE 'A'
    FOR EACH AField IN ::FFieldArray
      AField:GetData()
    NEXT
    EXIT
  END

RETURN .T.

/*
  GetDefaultValue
  Teo. Mexico 2009
*/
METHOD FUNCTION GetDefaultValue CLASS TField
  LOCAL AField

  IF ::FFieldMethodType = 'A'
    FOR EACH AField IN ::FFieldArray
      AField:GetDefaultValue()
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
  GetFieldMethod
  Teo. Mexico 2006
*/
METHOD FUNCTION GetFieldMethod CLASS TField
  SWITCH ::FFieldMethodType
  CASE 'A'
    RETURN ::FFieldArray
  CASE 'B'
    RETURN ::FFieldCodeBlock
  CASE 'C'
    RETURN ::FFieldExpression
  END
RETURN NIL

/*
  GetItDoPick
  Teo. Mexico 2009
*/
METHOD FUNCTION GetItDoPick( param ) CLASS TField

  IF !HB_IsBlock( ::FGetItPick )
    RETURN NIL
  ENDIF

RETURN ::FGetItPick:Eval( param )

/*
  GetValidValues
  Teo. Mexico 2009
*/
METHOD FUNCTION GetValidValues() CLASS TField

  IF ValType( ::ValidValues ) = "B"
    IF ::FDataOfValidValues = NIL
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
METHOD FUNCTION IsValid( Value ) CLASS TField
  LOCAL validValues

  IF Value = NIL
    Value := ::GetBuffer()
  ENDIF

  IF ::FRequired .AND. Empty( Value )
    wxhAlert( ::FTable:ClassName + ":" + ::FName + " <empty key value>" )
    RETURN .F.
  ENDIF

  IF ::Unique
	/* IF Empty( Value )
	  wxhAlert( ::FTable:ClassName + ":" + ::FName + " <empty INDEX key value>" )
	  RETURN .F.
	ENDIF
	 */    IF ::FUniqueKeyIndex:ExistKey( ::AsIndexKeyVal( Value ) )
      wxhAlert( ::FTable:ClassName + ":" + ::FName + " <key value already exists> '" + AsString( Value ) + "'")
      RETURN .F.
    ENDIF
  ENDIF

  IF ::ValidValues != NIL
	
	validValues := ::GetValidValues()
    
	SWITCH ValType( validValues )
    CASE 'A'
      IF AScan( validValues, {|e| e == Value } ) = 0
        RETURN .F.
      ENDIF
      EXIT
    CASE 'H'
      IF AScan( HB_HKeys( validValues ), {|e| e == Value } ) = 0
        RETURN .F.
      ENDIF
      EXIT
    #ifdef __XHARBOUR__
    DEFAULT
    #else
    OTHERWISE
    #endif
      wxhAlert( ::FTable:ClassName + ":" + ::FName + " <Value not in 'ValidValues'> '" + AsString( Value ) + "'")
    ENDSWITCH
  ENDIF

  IF ::OnValidate = NIL
    RETURN .T.
  ENDIF

RETURN ::OnValidate:Eval( Value )

/*
  Reset
  Teo. Mexico 2009
*/
METHOD PROCEDURE Reset CLASS TField
  LOCAL AField
  LOCAL value

  IF ::FFieldMethodType = 'A'

    FOR EACH AField IN ::FFieldArray
      AField:Reset()
    NEXT

    RETURN

  ENDIF

  /*
   * If there is a field in the mastersource with the same name
   * and is a masterfield (attached to the keyfield in the mastersource)
   * then syncs the value in buffer
   * if there is a DefaultValue this is ignored (may be a warning is needed)
   */
  AField := ::FTable:FindMasterSourceField( ::Name )
  IF AField != NIL .AND. ::IsMasterFieldComponent

    value := AField:GetBuffer()

#ifdef _DEBUG_
    IF ::FDefaultValue != NIL
      wxhAlert( ::FTable:ClassName + ":" + ::FName + ";<DefaultValue Ignored on Reset>" )
    ENDIF
#endif
  ELSE

    IF ::FDefaultValue != NIL

      value := ::GetDefaultValue()

    ELSE

      IF ::IsDerivedFrom( "TObjectField" )
        value := ::LinkedTable:PrimaryKeyField:GetDefaultValue()
        IF value = NIL
          value := ::LinkedTable:PrimaryKeyField:GetEmptyValue()
        ENDIF
      ELSE
        value := ::GetEmptyValue()
      ENDIF

    ENDIF

  ENDIF

  ::SetBuffer( value )

  ::FWrittenValue := NIL

RETURN

/*
  SetAsVariant
  Teo. Mexico 2006
*/
METHOD PROCEDURE SetAsVariant( rawValue ) CLASS TField
  LOCAL Value

  /* if Browsing then do a SeekKey() with the rawValue */
  IF ::FTable:State = dsBrowse
  
    IF ::IsKeyIndex

      IF !Empty( rawValue )
        ::KeyIndex:Seek( rawValue )
      ELSE
        ::FTable:DbGoTo( 0 )
      ENDIF

      IF ::FTable:LinkedObjField != NIL

        IF AScan( { dsEdit, dsInsert }, ::FTable:LinkedObjField:Table:State ) > 0
          ::FTable:LinkedObjField:SetAsVariant( ::FTable:PrimaryKeyField:GetBuffer() )
        ENDIF

        IF ! ::FTable:LinkedObjField:GetAsVariant == ::FTable:PrimaryKeyField:GetBuffer()
          ::FTable:Seek( ::FTable:LinkedObjField:GetAsVariant, 0 )
        ENDIF

      ENDIF

    ELSE
	
      //RAISE TFIELD ::Name ERROR "Field has no Index in the Table..."
	  wxhAlert( "Field '" + ::FName + "' has no Index in the Table..." )

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

    IF ::FTable:State = dsReading .OR. ::AutoIncrement .OR. ::IsMasterFieldComponent
      ::SetBuffer( Value )
      RETURN
    ENDIF

    /* Check if we are really changing values here */
    IF Value == ::GetBuffer()
      RETURN
    ENDIF

    ::SetData( Value )

    RETURN

#ifdef __XHARBOUR__
  DEFAULT
#else
  OTHERWISE
#endif

  END

RETURN

/*
  SetBuffer
  Teo. Mexico 2009
*/
METHOD PROCEDURE SetBuffer( Value ) CLASS TField

  /* FieldArray's doesn't have a absolute FBuffer */
  IF ::FFieldMethodType = "A"
    RETURN
  ENDIF

  IF !( hb_IsNIL( Value ) .OR. ValType( Value ) = ::FValType ) .AND. ;
     ( ::IsDerivedFrom("TStringField") .AND. AScan( {"C","M"}, ValType( Value ) ) = 0 )
    RAISE TFIELD ::Name ERROR "Wrong Type Assign: [" + Value:ClassName + "] to <" + ::ClassName + ">"
  ENDIF

  ::FBuffer := Value

  IF ::OnSetValue != NIL
    ::OnSetValue:Eval( Self, @::FBuffer )
  ENDIF

RETURN

/*
  SetData
  Teo. Mexico 2006
*/
METHOD PROCEDURE SetData( Value ) CLASS TField
  LOCAL AField
  LOCAL nTries
  LOCAL errObj
  LOCAL abort

  /* SetData is only for the physical fields on the database */
  SWITCH ::FFieldMethodType
  CASE 'A'

    IF Value != NIL
      RAISE TFIELD ::Name ERROR "SetData: Not allowed custom value with a compund TField..."
    ENDIF

    FOR EACH AField IN ::FFieldArray
      AField:SetData()
    NEXT

  CASE 'C'

    EXIT

#ifdef __XHARBOUR__
  DEFAULT
#else
  OTHERWISE
#endif

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
      IF  (--nTries = 0)
        RAISE TFIELD ::Name ERROR "Can't create AutoIncrement Value..."
        RETURN
      ENDIF
    ENDDO

  ELSE

    IF Value = NIL
      Value := ::GetBuffer()
    ENDIF

  ENDIF

  /* Don't bother... */
  IF Value == ::FWrittenValue
    RETURN
  ENDIF

  /* Check if field is a masterkey in child tables */
  IF ::FTable:PrimaryIndex:UniqueKeyField == Self .AND. ::FWrittenValue != NIL
    IF ::FTable:HasChilds()
      wxhAlert( "Can't modify key <"+::FName+"> with "+Value+";Has dependant child tables.")
      RETURN
    ENDIF
  ENDIF

  /* Validate before the physical writting */
  IF !::IsValid( Value )
    RETURN
  ENDIF

  IF ::OnBeforeChange != NIL
    abort := .F.
    ::OnBeforeChange:Eval( ::FTable, @abort )
    IF abort
      RETURN
    ENDIF
  ENDIF

  ::SetBuffer( Value )

  TRY

    /*
     * Check for a key violation
     */
    IF ::IsPrimaryKeyField .AND. ::FUniqueKeyIndex:ExistKey( ::AsIndexKeyVal() )
      RAISE TFIELD ::Name ERROR "Key violation."
    ENDIF

    /* The physical write to the field */
    ::FTable:Alias:Eval( ::FFieldWriteBlock, Value )

    ::FWrittenValue := Value

    /* Check if has to update Custom Index */
    //IF ::CustomIndexed
      //::CustomIndexUpdate()
    //ENDIF

    /*
     * Check if has to propagate change to a child sources
     */
    IF ::FTable:PrimaryIndex:UniqueKeyField == Self
      ::FTable:SyncDetailSources()
    ENDIF

    IF ::OnChange != NIL
      ::OnChange:Eval( ::FTable )
    ENDIF

  CATCH errObj

    //ShowError( errObj )
    ErrorBlock():Eval( errObj )

  END

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
  LOCAL fieldName
  LOCAL AField
  LOCAL n

  SWITCH (::FFieldMethodType := ValType( FieldMethod ))
  CASE "A"
    IF ::IsDerivedFrom("TObjectField")
      RAISE TFIELD ::Name ERROR "Array of Fields Not Allowed in <TObjectField>..."
    ENDIF
    IF ::IsDerivedFrom("TStringField")
      ::TStringField:FSize := 0
    ENDIF
    ::FFieldArray := {}
    FOR EACH fieldName IN FieldMethod
      AField := ::FTable:FieldByName( fieldName )
      IF AField != NIL
        AAdd( ::FFieldArray, AField )
      ELSE
        RAISE TFIELD fieldName ERROR "Field is not defined yet..."
      ENDIF
      IF ::IsDerivedFrom("TStringField")
        IF Len( AField ) == NIL
          RAISE TFIELD AField:Name ERROR "Size is NIL..."
        ENDIF
        ::TStringField:FSize += Len( AField )
      ENDIF
    NEXT
    ::FFieldCodeBlock  := NIL
    ::FFieldReadBlock  := NIL
    ::FFieldWriteBlock := NIL
    ::FFieldExpression := NIL
    EXIT
  CASE "B"
    ::FFieldArray := NIL
    ::FFieldCodeBlock  := FieldMethod
    ::FFieldReadBlock  := NIL
    ::FFieldWriteBlock := NIL
    ::FFieldExpression := NIL
    EXIT
  CASE "C"

    ::FFieldArray := NIL
    ::FFieldCodeBlock := NIL

    FieldMethod := LTrim( RTrim( FieldMethod ) )

    /* Check if the same FieldExpression is declared redeclared in the same table baseclass */
    FOR EACH AField IN ::FTable:FieldList
      IF !Empty( AField:FieldExpression ) .AND. ;
         Upper( AField:FieldExpression ) == Upper( FieldMethod ) .AND. ;
         AField:FTableBaseClass == ::FTableBaseClass
        RAISE TFIELD ::Name ERROR "Atempt to Re-Declare FieldExpression <" + ::ClassName + ":" + FieldMethod + ">"
      ENDIF
    NEXT

    IF ::FTable:Alias != NIL .AND. ::FTable:Alias:FieldPos( FieldMethod ) > 0
      ::FFieldReadBlock  := FieldBlock( FieldMethod )
      ::FFieldWriteBlock := FieldBlock( FieldMethod )
      n := AScan( ::Table:DbStruct, {|e| Upper( FieldMethod ) == e[1] } )
      /*!
       * Check if TField and database field are compatible
       * except for TObjectField's here
       */
      IF !::IsDerivedFrom("TObjectField") .AND. !::IsDerivedFrom( ::FTable:FieldTypes[ ::Table:DbStruct[n][2] ] )
        RAISE TFIELD ::Name ERROR "Invalid type on TField Class '" + ::FTable:FieldTypes[ ::Table:DbStruct[n][2] ] + "' : <" + FieldMethod + ">"
      ENDIF
      ::FModStamp        := ::Table:DbStruct[n][2] $ "=^+"
      ::FCalculated := .F.
    ELSE
      ::FFieldReadBlock  := NIL
      ::FFieldWriteBlock := NIL
      ::FCalculated := .T.
    ENDIF

    fieldName := iif( Empty( ::FName ), FieldMethod, ::FName )

    IF Empty( fieldName )
      RAISE TFIELD "<Empty>" ERROR "Empty field name and field method."
    ENDIF

    // Check if FieldExpression is re-declared in parent class
    IF AScan( ::FTable:FieldList, {|AField| !Empty(AField:FieldExpression) .AND. Upper( AField:FieldExpression ) == Upper( fieldName ) }) > 0
      n := AScan( ::FTable:FieldList, {|AField| AField == Self } )
      IF n > 0
        ADel( ::FTable:FieldList, n )
        ASize( ::FTable:FieldList, Len( ::FTable:FieldList ) - 1 )
      ENDIF
      RETURN /* ok, we don't need this now repeated parent field */
    ENDIF

    ::FFieldExpression := FieldMethod
    ::Name := FieldMethod

    EXIT

  END

RETURN

/*
  SetGetItPick
  Teo. Mexico 2009
*/
METHOD PROCEDURE SetGetItPick( block ) CLASS TField
  ::FGetItPick := block
RETURN

/*
  SetIsMasterFieldComponent
  Teo. Mexico 2009
*/
METHOD PROCEDURE SetIsMasterFieldComponent( IsMasterFieldComponent ) CLASS TField
  LOCAL AField

  SWITCH ::FFieldMethodType
  CASE 'A'
    FOR EACH AField IN ::FFieldArray
      AField:IsMasterFieldComponent  := IsMasterFieldComponent
    NEXT
    EXIT
  CASE 'C'
    ::FIsMasterFieldComponent  := IsMasterFieldComponent
  END

RETURN

/*
  SetName
  Teo. Mexico 2006
*/
METHOD PROCEDURE SetName( Name ) CLASS TField

  IF Empty( Name ) .OR. !Empty( ::FName )
    RETURN
  ENDIF

  ::FName := Name

  ::Table:AddMessageField( Name, Self )

RETURN

/*
  SetPrimaryKeyComponent
  Teo. Mexico 2009
*/
METHOD PROCEDURE SetPrimaryKeyComponent( PrimaryKeyComponent ) CLASS TField
  LOCAL AField

  SWITCH ::FFieldMethodType
  CASE 'A'
    FOR EACH AField IN ::FFieldArray
      AField:PrimaryKeyComponent := PrimaryKeyComponent
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
  METHOD SetSize( Size ) INLINE ::FSize := Size
PROTECTED:
  DATA FSize
  DATA FValType INIT "C"
  METHOD GetEmptyValue INLINE iif( ::FSize = NIL, "", Space( ::FSize ) )
  METHOD SetAsString( sValue ) INLINE ::SetAsVariant( sValue )
  METHOD SetBuffer( buffer )
  METHOD SetDefaultValue( DefaultValue )
PUBLIC:
  METHOD AsIndexKeyVal( value )
  METHOD GetAsString
PUBLISHED:
  PROPERTY Size READ FSize WRITE SetSize
ENDCLASS

/*
  AsIndexKeyVal
  Teo. Mexico 2009
*/
METHOD FUNCTION AsIndexKeyVal( value ) CLASS TStringField
  LOCAL AField

  IF value = NIL
    IF ::FFieldMethodType = "A"
      value := ""
      FOR EACH AField IN ::FFieldArray
        value += AField:AsIndexKeyVal
      NEXT
    ELSE
      value := ::GetAsVariant()
    ENDIF
  ELSEIF !HB_IsString( value )
    value := AsString( value )
  ENDIF

  IF ::OnGetIndexKeyVal != NIL
    RETURN ::OnGetIndexKeyVal:Eval( value )
  ENDIF

RETURN value

/*
  GetAsString
  Teo. Mexico 2009
*/
METHOD FUNCTION GetAsString CLASS TStringField
  LOCAL Result := ""
  LOCAL AField

  SWITCH ::FFieldMethodType
  CASE 'A'
    FOR EACH AField IN ::FFieldArray
      Result += AField:AsString()
    NEXT
    EXIT
#ifdef __XHARBOUR__
  DEFAULT
#else
  OTHERWISE
#endif
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

  IF DefaultValue = NIL
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
  ENDCLASS TStringField
*/

/*
  TMemoField
  Teo. Mexico 2006
*/
CLASS TMemoField FROM TStringField
PRIVATE:
PROTECTED:
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
  DATA FValType INIT "N"
  METHOD GetEmptyValue BLOCK {|| 0 }
  METHOD SetAsString( Text )
PUBLIC:

  METHOD AsIndexKeyVal( value )
  METHOD GetAsString

  PROPERTY AsNumeric READ GetAsVariant WRITE SetAsVariant

PUBLISHED:
ENDCLASS

/*
  AsIndexKeyVal
  Teo. Mexico 2009
*/
METHOD FUNCTION AsIndexKeyVal( value ) CLASS TNumericField
  IF value = NIL
    value := ::GetAsVariant()
  ELSEIF !HB_IsNumeric( value )
    value := AsNumeric( value )
  ENDIF
  IF ::OnGetIndexKeyVal != NIL
    RETURN ::OnGetIndexKeyVal:Eval( value )
  ENDIF
RETURN AsString( value )

/*
  GetAsString
  Teo. Mexico 2009
*/
METHOD FUNCTION GetAsString( Value ) CLASS TNumericField
  LOCAL Result

  IF Value = NIL
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
  SetAsString
  Teo. Mexico 2009
*/
METHOD PROCEDURE SetAsString( Text ) CLASS TNumericField
  ::SetAsVariant( Val( Text ) )
RETURN

/*
  ENDCLASS TNumericField
*/

/*
  TLogicalField
  Teo. Mexico 2006
*/
CLASS TLogicalField FROM TField
PRIVATE:
PROTECTED:
  DATA FValType INIT "L"
  METHOD GetEmptyValue BLOCK {|| .F. }
PUBLIC:

  METHOD AsIndexKeyVal( value )
  PROPERTY AsBoolean READ GetAsVariant WRITE SetAsVariant

PUBLISHED:
ENDCLASS

/*
  AsIndexKeyVal
  Teo. Mexico 2009
*/
METHOD FUNCTION AsIndexKeyVal( value ) CLASS TLogicalField
  IF value = NIL
    value := ::GetAsVariant()
  ELSEIF !HB_IsLogical( value )
    value := AsLogical( value )
  ENDIF
  IF ::OnGetIndexKeyVal != NIL
    RETURN ::OnGetIndexKeyVal:Eval( value )
  ENDIF
RETURN iif( value, "T", "F" )

/*
  ENDCLASS TLogicalField
*/

/*
  TDateField
  Teo. Mexico 2006
*/
CLASS TDateField FROM TField
PRIVATE:
  DATA FSize INIT 8         // Size on index is 8 = len of DToS()
PROTECTED:
  DATA FValType INIT "D"
  METHOD GetEmptyValue BLOCK {|| CtoD("") }
PUBLIC:
  METHOD AsIndexKeyVal( value )
  METHOD GetAsString INLINE DToS( ::GetAsVariant() )
  PROPERTY Size READ FSize
PUBLISHED:
ENDCLASS

/*
  AsIndexKeyVal
  Teo. Mexico 2009
*/
METHOD FUNCTION AsIndexKeyVal( value ) CLASS TDateField
  IF value = NIL
    value := ::GetAsVariant()
  ELSEIF !HB_IsDate( value )
    value := AsDate( value )
  ENDIF
  IF ::OnGetIndexKeyVal != NIL
    RETURN ::OnGetIndexKeyVal:Eval( value )
  ENDIF
RETURN DToS( value )

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
  DATA FValType INIT "C"
  METHOD GetEmptyValue BLOCK {|| DateTimeStampStr() }
PUBLIC:
  METHOD AsIndexKeyVal( value )
PUBLISHED:
ENDCLASS

/*
  AsIndexKeyVal
  Teo. Mexico 2009
*/
METHOD FUNCTION AsIndexKeyVal( value ) CLASS TDayTimeField
  IF value = NIL
    value := ::GetAsVariant()
  ELSEIF !HB_IsDate( value )
    value := AsString( value )
  ENDIF
  IF ::OnGetIndexKeyVal != NIL
    RETURN ::OnGetIndexKeyVal:Eval( value )
  ENDIF
RETURN AsString( value )

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
PUBLIC:
PUBLISHED:
ENDCLASS

/*
  EndClass TModTimeField
*/

/*
  TObjectField
  Teo. Mexico 2006
*/
CLASS TObjectField FROM TField
PRIVATE:
  DATA FIsTheMasterSource
  DATA FObjValue
  DATA FLinkedTable                  /* holds the Table object */
  METHOD GetIsTheMasterSource
  METHOD GetSize INLINE Len( ::LinkedTable:PrimaryKeyField )
  METHOD SetObjValue( objValue ) INLINE ::FObjValue := objValue
PROTECTED:
  DATA FValType                   INIT "O"
  METHOD GetLinkedTable
  METHOD GetEmptyValue            INLINE ::LinkedTable:PrimaryKeyField:EmptyValue
PUBLIC:
  METHOD DataObj
  METHOD AsIndexKeyVal( value )
  METHOD GetAsString              //INLINE ::LinkedTable:PrimaryKeyField:AsString()
  METHOD SetAsVariant
  PROPERTY LinkedTable READ GetLinkedTable
  PROPERTY IsTheMasterSource READ GetIsTheMasterSource
  PROPERTY ObjValue READ FObjValue WRITE SetObjValue
  PROPERTY Size READ GetSize
PUBLISHED:
ENDCLASS

/*
  DataObj
  Syncs the Table with the key in buffer
  Teo. Mexico 2009
*/
METHOD FUNCTION DataObj CLASS TObjectField
  ::LinkedTable:Value := ::GetBuffer()
RETURN ::FLinkedTable

/*
  AsIndexKeyVal
  Teo. Mexico 2009
*/
METHOD FUNCTION AsIndexKeyVal( value ) CLASS TObjectField
  IF value = NIL
    value := ::GetBuffer()
  ENDIF
RETURN ::LinkedTable:PrimaryKeyField:AsIndexKeyVal( value )

/*
  GetAsString
  Teo. Mexico 2009
*/
METHOD FUNCTION GetAsString CLASS TObjectField
  LOCAL Result

  Result := ::GetBuffer()

RETURN Result

/*
  GetIsTheMasterSource
  Teo. Mexico 2009
*/
METHOD FUNCTION GetIsTheMasterSource CLASS TObjectField
  LOCAL masterSource

  IF ::FIsTheMasterSource != NIL
    RETURN ::FIsTheMasterSource
  ENDIF

  ::FIsTheMasterSource := .F.

  masterSource := ::FTable:MasterSource

  WHILE masterSource != NIL .AND. ! ::FIsTheMasterSource
    ::FIsTheMasterSource := ::LinkedTable == masterSource
    masterSource := masterSource:MasterSource
  ENDDO

RETURN ::FIsTheMasterSource

/*
  GetLinkedTable
  Teo. Mexico 2009
*/
METHOD FUNCTION GetLinkedTable CLASS TObjectField

  IF ::FLinkedTable = NIL

    IF Empty( ::FObjValue )
      RAISE TFIELD ::Name ERROR "TObjectField has not a ObjValue value."
    ENDIF

    /*
     * Solve using the default ObjValue
     */
    SWITCH ValType( ::FObjValue )
    CASE 'C'
      ::FLinkedTable := __ClsInstFromName( ::FObjValue ):New()
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
    IF !::IsMasterFieldComponent .AND. ::FLinkedTable:LinkedObjField = NIL
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
      ::ReadOnly := .T.
    ENDIF

  ENDIF

RETURN ::FLinkedTable

METHOD PROCEDURE SetAsVariant( value ) CLASS TObjectField
  Super:SetAsVariant( value )
RETURN

/*
  ENDCLASS TObjectField
*/
