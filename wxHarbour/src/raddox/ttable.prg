/*
  TTable
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
  __ClsInstFromName (Just UpperCase in __ClsInstName)
  Teo. Mexico 2007
*/
FUNCTION __ClsInstFromName( ClassName )
RETURN __ClsInstName( Upper( ClassName ) )

/*
  TTable
  Teo. Mexico 2007
*/
CLASS TTable
PRIVATE:

  CLASSDATA FFieldTypes
  CLASSDATA FInstances INIT HB_HSetCaseMatch( {=>}, .F. )

  DATA pSelf

  DATA FActive        INIT .F.
  DATA FAlias
  DATA FDisplayFields                   // Contains a Object
  DATA FIndex                           // Current TIndex in Table
  DATA FIndexList
  DATA FMasterList    INIT .F.  // Needed to tell when listing a Detail DataSource.
  DATA FMasterSource
  DATA FPrimaryIndex
  DATA FRecNo         INIT 0
  DATA FState INIT dsInactive
  DATA FSubState INIT dssNone
  DATA FTimer INIT 0
  DATA FUndoList INIT HB_HSetCaseMatch( {=>}, .F. )

  METHOD FirstLast
  METHOD GetBof INLINE ::Alias:Bof
  METHOD GetDbStruct
  METHOD GetEof INLINE ::Alias:Eof
  METHOD GetFieldTypes
  METHOD GetFound INLINE ::Alias:Found
  METHOD GetIndexName INLINE ::FIndex:Name
  METHOD GetPrimaryKeyField INLINE iif( ::FPrimaryIndex = NIL .OR. ::FPrimaryIndex:UniqueKeyField = NIL, NIL, ::FPrimaryIndex:UniqueKeyField )
  METHOD GetPrimaryMasterKeyField INLINE iif( ::FPrimaryIndex = NIL, NIL, ::FPrimaryIndex:MasterKeyField )
  METHOD SetIndex( AIndex ) INLINE ::FIndex := AIndex
  METHOD SetIndexName( IndexName )
  METHOD SetMasterList( MasterList ) INLINE ::FMasterList := MasterList
  METHOD SetMasterSource( MasterSource )
  METHOD GetPrimaryMasterKeyString INLINE iif( ::GetPrimaryMasterKeyField = NIL, "", ::GetPrimaryMasterKeyField:AsString )
  METHOD GetPublishedFieldList
  METHOD SetPrimaryIndex( AIndex )

PROTECTED:

  DATA FBaseClass
  DATA FFieldList

  METHOD AddRec
  METHOD FindDetailSourceField( masterField )
  METHOD InitDataBase INLINE TDataBase():New()

PUBLIC:

  CLASSDATA DataBase

  /*!
    array of possible TObjectField's that have this (SELF) object referenced
   */
  DATA DetailSourceList INIT HB_HSetCaseMatch( {=>}, .F. )
  DATA FieldNamePrefix  INIT "Field_"   // Table Field Name prefix
  DATA LinkedObjField
  DATA TableName //VIRTUAL

  CONSTRUCTOR New( MasterSource )

  METHOD AddMessageField( MessageName, AField )
  METHOD Cancel
  METHOD ChildSource( tableName )
  METHOD CopyRecord( Value )
  METHOD Count
  METHOD DefineFields
  METHOD DefineIndexes                VIRTUAL
  METHOD DefineMasterDetailFields     VIRTUAL
  METHOD DefineRelations              VIRTUAL
  METHOD Destroy
  METHOD DbEval( bBlock, bForCondition, bWhileCondition )
  METHOD DbGoTo( RecNo )
  METHOD Delete
  METHOD DeleteChilds
  METHOD Edit
  METHOD FieldByName
  METHOD FindMasterSourceField( detailField )
  METHOD FindTable( table )
  METHOD First INLINE ::FirstLast( 0 )
  METHOD FullFileName
  METHOD GetAsString INLINE iif( ::PrimaryKeyField=NIL, "", ::PrimaryKeyField:AsString )
  METHOD GetAsVariant INLINE iif( ::PrimaryKeyField=NIL, NIL, ::PrimaryKeyField:Value )
  METHOD GetCurrentRecord
  METHOD GetDisplayFieldBlock( nField )
  METHOD GetDisplayFields( directAlias )
  METHOD HasChilds
  METHOD IndexByName( IndexName )
  METHOD Insert
  METHOD InsertRecord( Value )
  METHOD InsideScope
  METHOD Last INLINE ::FirstLast( 1 )
  METHOD MasterSourceClassName
  METHOD Next( numRecs )
  METHOD Open
  METHOD Post
  METHOD RawSeek( Value )
  METHOD RecLock
  METHOD RecUnLock
  METHOD Refresh
  METHOD Reset                // Set Field Record to their default values, Sync MasterKeyString Value
  METHOD Seek( Value, AIndex, SoftSeek )
  METHOD SetAsString( Value ) INLINE ::PrimaryKeyField:AsString := Value
  METHOD SetAsVariant( Value ) INLINE ::PrimaryKeyField:Value := Value
  /*
   * TODO: Enhance this to:
   *       <order> can be "fieldname" or "fieldname1;fieldname2"
   *       able to create a live index
   */
  METHOD SetOrderBy( order ) INLINE ::FIndex := ::FieldByName( order ):KeyIndex
  METHOD SyncDetailSources
  METHOD SyncFromMasterSourceFields
  METHOD SyncRecNo
  METHOD TableClass INLINE ::ClassName + "@" + ::TableName

  METHOD ValidateFields

  EVENT OnCreate VIRTUAL
  EVENT OnAfterInsert VIRTUAL
  EVENT OnAfterPost VIRTUAL
  EVENT OnBeforeInsert VIRTUAL
  EVENT OnBeforePost VIRTUAL

  PROPERTY Alias READ FAlias
  PROPERTY AsString READ GetAsString WRITE SetAsString
  PROPERTY BaseClass READ FBaseClass
  PROPERTY Bof READ GetBof
  PROPERTY DbStruct READ GetDbStruct
  PROPERTY DisplayFields READ GetDisplayFields
  PROPERTY Eof READ GetEof
  PROPERTY FieldList READ FFieldList
  PROPERTY Found READ GetFound
  PROPERTY FieldTypes READ GetFieldTypes
  PROPERTY Instances READ FInstances
  PROPERTY MasterList READ FMasterList WRITE SetMasterList
  PROPERTY PrimaryMasterKeyString READ GetPrimaryMasterKeyString
  PROPERTY RecNo READ FRecNo WRITE DbGoTo
  PROPERTY State READ FState
  PROPERTY SubState READ FSubState

PUBLISHED:

  DATA Cargo

  PROPERTY ChildReferenceList READ FInstances[ ::TableClass, "ChildReferenceList" ]
  PROPERTY Index READ FIndex WRITE SetIndex
  PROPERTY IndexList READ FIndexList
  PROPERTY IndexName READ GetIndexName WRITE SetIndexName
  PROPERTY MasterDetailFieldList READ FInstances[ ::TableClass, "MasterDetailFieldList" ]
  PROPERTY MasterSource READ FMasterSource WRITE SetMasterSource
  PROPERTY PrimaryKeyField READ GetPrimaryKeyField
  PROPERTY PrimaryMasterKeyField READ GetPrimaryMasterKeyField
  PROPERTY PrimaryIndex READ FPrimaryIndex WRITE SetPrimaryIndex
  PROPERTY PublishedFieldList READ GetPublishedFieldList
  PROPERTY Value READ GetAsVariant WRITE SetAsVariant

ENDCLASS

/*
  New
  Teo. Mexico 2006
*/
METHOD New( MasterSource ) CLASS TTable

  ::OnCreate( Self )

  IF ::DataBase = NIL
    ::DataBase := ::InitDataBase()
  ENDIF

  /*!
   * Sets the MasterSource (maybe will be needed in the fields definitions ahead )
   */
  IF MasterSource != NIL

    /*!
     * Check for a valid MasterSourceClassName (if any)
     */
    IF ::MasterSourceClassName != NIL
      IF !MasterSource:IsDerivedFrom( ::MasterSourceClassName ) .AND. !::DataBase:TableIsDerivedFrom( ::MasterSourceClassName, MasterSource:ClassName )
        RAISE ERROR "Table <" + ::TableClass + "> Invalid MasterSource Class Name: " + MasterSource:ClassName + ";Expected class type: <" + ::MasterSourceClassName + ">"
      ENDIF
    ENDIF

    /*
     * removes any previous entry for Self in MasterSource:DetailSourceList
     */
    IF HB_HHasKey( MasterSource:DetailSourceList, ::ClassName )
      HB_HDel( MasterSource:DetailSourceList, ::ClassName )
    ENDIF

    /*
     * As we have not fields defined yet, this will not execute SyncFromMasterSourceFields()
     */
    ::SetMasterSource( MasterSource )

  ELSE

    IF ::MasterSourceClassName != NIL
      ::SetMasterSource( __ClsInstFromName( Upper( ::MasterSourceClassName ) ):New() )
      /*
       * DetailSource declared without a MasterSource
       */
      ::FMasterList := .T.
    ENDIF

  ENDIF

  IF !Empty( ::TableName )
    ::Open()
  ENDIF

RETURN Self

/*
  AddMessageField
  Teo. Mexico 2006
*/
METHOD PROCEDURE AddMessageField( MessageName, AField ) CLASS TTable
  LOCAL n

//   IF !::Instances[ ::ClassName ]["Initializing"]
//     RETURN
//   ENDIF

  /* Check if Name is already created in class */
  IF __ObjHasMsg( Self, ::FieldNamePrefix + MessageName )

    /* Don't, not needed this here for correct class inheritance
    RAISE ERROR ::ClassName+": FieldName Already Defined: " + MessageName
    */
    RETURN
  ENDIF

  n := AScan( ::FieldList, {|BField| AField == BField } )

  IF n = 0
    RETURN
  ENDIF

  MessageName := ::FieldNamePrefix + MessageName

  EXTEND OBJECT Self WITH MESSAGE MessageName INLINE ::FFieldList[n]

RETURN

/*
  AddRec
  Teo. Mexico 2006
*/
METHOD FUNCTION AddRec CLASS TTable
  LOCAL Result
  LOCAL AField
  LOCAL errObj
  LOCAL index

  IF ::FPrimaryIndex != NIL
    index := ::FPrimaryIndex:Name
  ENDIF

  IF !( Result := ::Alias:AddRec(index) )
    RETURN Result
  ENDIF

  ::Reset() // Reset record data to default values

  ::FRecNo := ::Alias:RecNo

  ::FState := dsInsert
  ::FSubState := dssAdding

  /*
   * Write the PrimaryMasterKeyField
   * Write the PrimaryKeyField
   * Write the Fields that have a DefaultValue
   */
  TRY

    IF ::FPrimaryIndex != NIL
      IF ::FPrimaryIndex:MasterKeyField != NIL
        ::FPrimaryIndex:MasterKeyField:SetData()
      ENDIF
      /*!
       * AutoIncrement fields always need to be written (to set a value)
       */
      IF ::FPrimaryIndex:UniqueKeyField != NIL .AND. ( ::FPrimaryIndex:AutoIncrement .OR. !Empty( ::FPrimaryIndex:UniqueKeyField:Value ) )
        ::FPrimaryIndex:UniqueKeyField:SetData()
      ENDIF
    ENDIF

    FOR EACH AField IN ::FFieldList
      IF AField:FieldMethodType = 'C' .AND. !AField:PrimaryKeyComponent
        IF AField:DefaultValue != NIL
          AField:SetData()
        ENDIF
      ENDIF
    NEXT

  CATCH errObj

    ErrorBlock():Eval( errObj )

    ::Delete()
    ::RecUnLock()

    Result := .F.

  END

  ::FSubState := dssNone

RETURN Result

/*
  Cancel
  Teo. Mexico 2006
*/
METHOD PROCEDURE Cancel CLASS TTable
  LOCAL AField

  IF AScan( { dsInsert, dsEdit }, ::State ) = 0
    //::Error_Table_Not_In_Edit_or_Insert_mode()
    RETURN
  ENDIF

  SWITCH ::State
  CASE dsInsert
    FOR EACH AField IN ::FFieldList
      IF AField:FieldMethodType = "C" .AND. !Empty( AField:Value ) .AND. !AField:IsValid
        AField:Reset()
      ENDIF
    NEXT
    ::Delete()
    EXIT
  CASE dsEdit
    FOR EACH AField IN ::FieldList
      IF AField:FieldMethodType = "C" .AND. HB_HHasKey( ::FUndoList, AField:Name ) .AND. !AField:Value == ::FUndoList[ AField:Name ]
        AField:Value := ::FUndoList[ AField:Name ]
      ENDIF
    NEXT
    EXIT
#ifdef __XHARBOUR__
  DEFAULT
#else
  OTHERWISE
#endif

  END

  ::RecUnLock()

RETURN

/*
  ChildSource
  Teo. Mexico 2008
*/
METHOD FUNCTION ChildSource( tableName ) CLASS TTable
  LOCAL table

  /* tableName is in the DetailSourceList */
  IF HB_HHasKey( ::DetailSourceList, tableName )
    table := ::DetailSourceList[ tableName ]
    table:Reset()
  ELSE
    table := __ClsInstFromName( Upper( tableName ) ):New( Self )
  ENDIF

RETURN table

/*
  CopyRecord
  Teo. Mexico 2007
*/
METHOD FUNCTION CopyRecord( origin ) CLASS TTable
  LOCAL AField
  LOCAL AField1
  LOCAL entry

  SWITCH ValType( origin )
  CASE 'O'  // Record from another Table
    IF !origin:IsDerivedFrom("TTable")
      RAISE ERROR "Origin is not a TTable class descendant."
      RETURN .F.
    ENDIF
    IF origin:Eof()
      RAISE ERROR "Origin is at EOF."
      RETURN .F.
    ENDIF
    FOR EACH AField IN ::FFieldList
      IF AField:FieldMethodType = 'C' .AND. !AField:PrimaryKeyComponent
        AField1 := origin:FieldByName( AField:Name )
        IF AField1 != NIL
          AField:Value := AField1:Value
        ENDIF
      ENDIF
    NEXT
    EXIT
  CASE 'H'  // Hash of Values
    FOR EACH entry IN origin
      AField := ::FieldByName( entry:__enumKey )
      IF AField!=NIL .AND. AField:FieldMethodType = 'C' .AND. !AField:PrimaryKeyComponent
        AField:Value := entry:__enumValue
      ENDIF
    NEXT
    EXIT
#ifdef __XHARBOUR__
  DEFAULT
#else
  OTHERWISE
#endif
    RAISE ERROR "Unknown Record from Origin"
    RETURN .F.
  END

RETURN .T.

/*
  Count : number of records
  Teo. Mexico 2008
*/
METHOD FUNCTION Count CLASS TTable
  LOCAL nCount := 0
  LOCAL RecNo
  LOCAL key
  LOCAL indexName

  RecNo := ::FAlias:RecNo

  key := ::PrimaryMasterKeyString
  indexName := ::PrimaryIndex:Name

  ::FAlias:Seek( key, indexName )

  WHILE !::FAlias:Eof() .AND. ::FAlias:KeyVal( indexName ) = key
    nCount++
    ::FAlias:Skip( 1, indexName )
  ENDDO

  ::FAlias:RecNo := RecNo

RETURN nCount

/*
  DbEval
  Teo. M�xico 2008
*/
METHOD PROCEDURE DbEval( bBlock, bForCondition, bWhileCondition ) CLASS TTable
  LOCAL DetailSourceList

  IF ::FMasterSource != NIL
    DetailSourceList := ::FMasterSource:DetailSourceList
    ::FMasterSource:DetailSourceList := HB_HSetAutoAdd( {=>}, .T. )
  ENDIF

  IF ::pSelf = NIL
    ::pSelf := __ClsInst( ::ClassH ):New( ::FMasterSource )
  ENDIF

  ::pSelf:First()

  WHILE !::pSelf:Eof() .AND. ( bWhileCondition = NIL .OR. bWhileCondition:Eval( ::pSelf ) )

    IF bForCondition = NIL .OR. bForCondition:Eval( ::pSelf )
      bBlock:Eval( ::pSelf )
    ENDIF

    ::pSelf:Next()

  ENDDO

  IF DetailSourceList != NIL
    ::FMasterSource:DetailSourceList := DetailSourceList
  ENDIF

RETURN

/*
  DbGoTo
  Teo. Mexico 2007
*/
METHOD DbGoTo( RecNo ) CLASS TTable
  LOCAL Result

  /* TODO: Check if RecNo has a valid Primary Key Value */

  Result := ::Alias:DbGoTo( RecNo )

  ::GetCurrentRecord()

RETURN Result

REQUEST TStringField

/*
  DefineFields
  Teo. Mexico 2008
*/
METHOD PROCEDURE DefineFields CLASS TTable
  LOCAL dbStruct := ::GetDbStruct()
  LOCAL fld
  LOCAL AField

  IF !Empty( ::FieldList )
    RETURN
  ENDIF

  BEGIN FIELD SECTION

  FOR EACH fld IN dbStruct

    AField := __ClsInstFromName( ::FieldTypes[ fld[ 2 ] ]  ):New( Self )

    AField:FieldMethod := fld[ 1 ]

  NEXT

  //END FIELD SECTION /* no Super:DefineFields to call here */

RETURN

/*
  Delete
  Teo. Mexico 2006
*/
METHOD FUNCTION Delete( lDeleteChilds ) CLASS TTable
  LOCAL AField

  IF AScan( { dsBrowse, dsInsert }, ::State ) = 0
    ::Error_Table_Not_In_Browse_or_Insert_State()
    RETURN .F.
  ENDIF

  IF ::State = dsBrowse .AND. !::RecLock()
    RETURN .F.
  ENDIF

  IF ::HasChilds()
    IF !lDeleteChilds == .T.
      Alert("Error_Table_Has_Childs")
      RETURN .F.
    ENDIF
    IF !::DeleteChilds()
      RETURN .F.
    ENDIF
  ENDIF

  FOR EACH AField IN ::FieldList
    AField:Delete()
  NEXT

  ::RecUnLock()

RETURN .T.

/*
  DeleteChilds
  Teo. Mexico 2006
*/
METHOD FUNCTION DeleteChilds CLASS TTable
  LOCAL childTableName
  LOCAL ChildDB
  LOCAL nrec

  IF ! HB_HHasKey( ::DataBase:ParentChildList, ::ClassName )
    RETURN .F.
  ENDIF

  nrec := ::Alias:RecNo()

  FOR EACH childTableName IN ::DataBase:GetParentChildList( ::ClassName )

    ChildDB := ::ChildSource( childTableName )

    IF ::DataBase:TableList[ childTableName, "IndexName" ] != NIL
      ChildDB:IndexName := ::DataBase:TableList[ childTableName, "IndexName" ]
    ENDIF

    WHILE ChildDB:First()
      ChildDB:Delete( .T. )
    ENDDO

  NEXT

  ::Alias:DbGoTo(nrec)

RETURN .T.

/*
  Destroy
  Teo. Mexico 2008
*/
METHOD PROCEDURE Destroy CLASS TTable
//   LOCAL AField

  IF ::pSelf != NIL
    ::pSelf:Destroy()
    ::pSelf := NIL
  ENDIF

  IF !HB_IsArray( ::FFieldList )
    //WLOG("ERROR!: " + ::ClassName + ":Destroy - :FieldList is not a array...")
    RETURN
  ENDIF

//   FOR EACH AField IN ::FFieldList
//     AField:Destroy()
//   NEXT

  ::FFieldList := NIL

  ::FActive := .F.

RETURN

/*
  Edit
  Teo. Mexico 2006
*/
METHOD FUNCTION Edit CLASS TTable
  LOCAL AField

  IF !::State = dsBrowse
    ::Error_TableNotInBrowseState()
    RETURN .F.
  ENDIF

  IF !::RecLock()
    RETURN .F.
  ENDIF

  FOR EACH AField IN ::FieldList

    IF AField:FieldMethodType = "C"
      //::FUndoList[ AField:Name ] := AField:Value
      ::FUndoList[ AField:Name ] := AField:GetBuffer()
    ENDIF

  NEXT

RETURN .T.

/*
  FieldByName
  Teo. Mexico 2006
*/
METHOD FUNCTION FieldByName( Name ) CLASS TTable
  LOCAL AField

  IF Empty( Name )
    RETURN NIL
  ENDIF

  Name := Upper( Name )

  FOR EACH AField IN ::FFieldList
    IF Name == Upper( AField:Name )
      RETURN AField
    ENDIF
  NEXT

RETURN NIL

/*
  FindDetailSourceField
  Teo. Mexico 2007
*/
METHOD FUNCTION FindDetailSourceField( masterField ) CLASS TTable
  LOCAL Result

  IF hb_HHasKey( ::MasterDetailFieldList, masterField:Name )
    Result := ::FieldByName( ::MasterDetailFieldList[ masterField:Name ] )
  ELSE
    Result := ::FieldByName( masterField:Name )
  ENDIF

RETURN Result

/*
  FindMasterSourceField
  Teo. Mexico 2007
*/
METHOD FUNCTION FindMasterSourceField( detailField ) CLASS TTable
  LOCAL enum
  LOCAL name
  LOCAL vt := ValType( detailField )

  IF ::FMasterSource = NIL
    RETURN NIL
  ENDIF

  DO CASE
  CASE vt = "C"
    name := Upper( detailField )
  CASE vt = "O" .AND. detailField:IsDerivedFrom( "TField" )
    name := Upper( detailField:Name )
  OTHERWISE
    RETURN NIL
  ENDCASE

  FOR EACH enum IN ::MasterDetailFieldList
    IF name == Upper( enum:__enumValue )
      RETURN ::FMasterSource:FieldByName( enum:__enumValue )
    ENDIF
  NEXT

RETURN ::FMasterSource:FieldByName( name )

/*
  FindTable : returns a ObjectField that has the table parameter
  Teo. Mexico 2008
*/
METHOD FUNCTION FindTable( table ) CLASS TTable
  LOCAL AField

  FOR EACH AField IN ::FFieldList
    IF AField:IsDerivedFrom( "TObjectField" )
      IF AField:LinkedTable == table
        RETURN AField
      ENDIF
    ENDIF
  NEXT

  /*
   * none found in current table
   * search in mastersource
   */
  IF ::FMasterSource != NIL
    RETURN ::FMasterSource:FindTable( table )
  ENDIF

RETURN NIL

/*
  FirstLast
  Teo. Mexico 2007
*/
METHOD FUNCTION FirstLast( n ) CLASS TTable

  IF AScan( {dsEdit,dsInsert}, ::FState ) > 0
    ::Post()
  ENDIF

  IF ::FIndex != NIL
    IF n = 0
      RETURN ::FIndex:First()
    ELSE
      RETURN ::FIndex:Last()
    ENDIF
  ENDIF

RETURN .F.

/*
  FullFileName
  Teo. Mexico 2008
*/
METHOD FUNCTION FullFileName CLASS TTable
  LOCAL Result

  IF !Empty( ::DataBase:Directory )
    Result := LTrim( RTrim( ::DataBase:Directory ) )
    IF !Right( Result, 1 ) == HB_OSPathSeparator()
      Result += HB_OSPathSeparator()
    ENDIF
  ELSE
    Result := ""
  ENDIF

RETURN Result + ::TableName

/*
  GetCurrentRecord
  Teo. Mexico 2007
*/
METHOD FUNCTION GetCurrentRecord CLASS TTable
  LOCAL pkField,mkField
  LOCAL AField,BField
  LOCAL state
  LOCAL pSelf

  IF ::FState != dsBrowse
    //RAISE ERROR "Table not in dsBrowse mode..."
    RETURN .F.
  ENDIF

  // DetailTable Syncs to a MasterSource
  IF ::FMasterSource != NIL .AND. ::FMasterList

    IF ::FMasterSource:PrimaryKeyField = NIL
      RAISE ERROR "Master Source '"+::FMasterSource:ClassName+"' has no Primary Index..."
      RETURN .F.
    ENDIF

    IF HB_HHasKey( ::FMasterSource:DetailSourceList, ::ClassName )
      pSelf := ::FMasterSource:DetailSourceList[ ::ClassName ]
      ::FMasterSource:DetailSourceList[ ::ClassName ] := NIL
    ENDIF

    IF !::Eof()

      pkField := ::FindDetailSourceField( ::FMasterSource:PrimaryKeyField, .T. )

      IF pkField = NIL
        RAISE ERROR "Cannot find PrimaryKey Field from MasterSource <" + ::FMasterSource:ClassName  + "> Table..."
      ENDIF

      // To Avoid infinite loop when Master updates their DetailSourceList
      ::PrimaryMasterKeyField:GetData() /* fill MasterKey Field */
      // Syncs MasterSource MasterKeyField with ::MasterKeyField
      mkField := ::FMasterSource:PrimaryMasterKeyField
      IF mkField != NIL
        state := ::FMasterSource:FState
        ::FMasterSource:FState := dsReading
        SWITCH mkField:FieldMethodType
        CASE 'A'
          FOR EACH AField IN mkField:FieldArray
            BField := ::FindDetailSourceField( AField, .T. )
            IF BField != NIL .AND. BField:IsMasterFieldComponent .AND. !AField:ReadOnly .AND. AField:DefaultValue = NIL
              //BField:GetData()
              AField:Value := BField:Value
            ELSE
              AField:Reset()
            ENDIF
          NEXT
          EXIT
        CASE 'C'
          AField := ::FindDetailSourceField( mkField, .T. )
          IF AField != NIL .AND. AField:IsMasterFieldComponent .AND. !mkField:ReadOnly .AND. mkField:DefaultValue = NIL
            AField:GetData()
            mkField:Value := AField:Value
          ELSE
            mkField:Reset()
          ENDIF
        END
        ::FMasterSource:FState := state
      ENDIF
      ::FMasterSource:MasterList := .T. // To allow all mastersources processed
      pkField:GetData()
      ::FMasterSource:PrimaryKeyField:Value := pkField:Value
      ::FMasterSource:MasterList := .F.
      IF ::FMasterSource:Eof()
        ::Reset()
        IF pSelf != NIL
          ::FMasterSource:DetailSourceList[ ::ClassName ] := pSelf
        ENDIF
        //RAISE ERROR "EOF at Master Source '"+::FMasterSource:ClassName+"'"
        RETURN .F.
      ENDIF
      state := ::FState
      ::FState := dsReading
      pkField:Value := ::FMasterSource:PrimaryKeyField:Value
      ::FState := state
      //ENDIF
    ELSE
      //::FMasterSource:FEof := .T.
      ::FMasterSource:DbGoTo( 0 )
    ENDIF
    IF pSelf != NIL
      ::FMasterSource:DetailSourceList[ ::ClassName ] := pSelf
    ENDIF
  ENDIF

  /*
   * Record needs to have a valid MasterKeyField
   */
  IF !::InsideScope
    ::FRecNo := 0
    ::Alias:DbGoTo( 0 )
    ::Reset()
    ::SyncDetailSources()
    RETURN .F.
  ENDIF

  ::FRecNo := ::Alias:RecNo

  FOR EACH AField IN ::FFieldList

    IF AField:FieldMethodType = "C" .AND. !AField:Calculated .AND. !AField:IsTheMasterSource
      AField:GetData()
    ENDIF

  NEXT

  ::SyncDetailSources()

RETURN .T.

/*
  GetDbStruct
  Teo. Mexico 2007
*/
METHOD FUNCTION GetDbStruct CLASS TTable
  IF ! HB_HHasKey( ::FInstances[ ::TableClass ], "DbStruct" )
    ::FInstances[ ::TableClass, "DbStruct" ] := ::Alias:DbStruct
  ENDIF
RETURN ::FInstances[ ::TableClass, "DbStruct" ]

/*
  GetDisplayFieldBlock
  Teo. Mexico 2008
*/
METHOD FUNCTION GetDisplayFieldBlock( n ) CLASS TTable

  IF !::FieldList[ n ]:IsDerivedFrom("TObjectField")
    #ifdef __XHARBOUR__
    RETURN ;
      <|o|
    #else
    RETURN ;
      {|o|
    #endif
        LOCAL Result
        IF o:__Obj:Eof()
          Result := o:__Obj:FieldList[ n ]:EmptyValue
        ELSE
          Result := o:__Obj:FieldList[ n ]:Value
        ENDIF
        /*
          * Alias RecNo maybe changed, so force a record sync
          */
        o:__FObj:Alias:SyncFromRecNo()
        RETURN Result
      #ifdef __XHARBOUR__
      >
      #else
      }
      #endif
  ENDIF

  #ifdef __XHARBOUR__
  RETURN ;
    <|o|
  #else
  RETURN ;
    {|o|
  #endif
      IF o:__Obj:FieldList[ n ]:DataObj != NIL
        RETURN o:__Obj:FieldList[ n ]:DataObj:DisplayFields
      ENDIF
      RETURN NIL
    #ifdef __XHARBOUR__
    >
    #else
    }
    #endif

METHOD FUNCTION GetDisplayFields( directAlias ) CLASS TTable
  LOCAL DisplayFieldsClass
  LOCAL MessageName
  LOCAL AField

  IF ::FDisplayFields = NIL

    IF ::FInstances[ ::TableClass, "DisplayFieldsClass" ] = NIL

      DisplayFieldsClass := HBClass():New( ::ClassName + "DisplayFields" )

      DisplayFieldsClass:AddInline( "__Obj", {|Self| PushWS(), ::__FObj:SyncRecNo( directAlias ),PopWS(), ::__FObj } )

      DisplayFieldsClass:AddData( "__FObj" )

      FOR EACH AField IN ::FFieldList

        MessageName := AField:Name

        /* TODO: Check for a duplicate message name */
        IF !Empty( MessageName ) //.AND. ! __ObjHasMsg( ef, MessageName )

          DisplayFieldsClass:AddInline( MessageName, ::GetDisplayFieldBlock( AField:__enumIndex() ) )

        ENDIF

      NEXT

      // Create the MasterSource field access reference
      IF ::FMasterSource != NIL
        DisplayFieldsClass:AddInline( "MasterSource", {|Self| ::__Obj:MasterSource:SyncRecNo(), ::__Obj:MasterSource:GetDisplayFields() } )
      ENDIF

      DisplayFieldsClass:Create()

      ::FInstances[ ::TableClass, "DisplayFieldsClass" ] := DisplayFieldsClass

    ENDIF

    ::FDisplayFields := ::FInstances[ ::TableClass, "DisplayFieldsClass" ]:Instance()
    ::FDisplayFields:__FObj := Self

  ENDIF

RETURN ::FDisplayFields

/*
  GetFieldTypes
  Teo. Mexico 2008
*/
METHOD FUNCTION GetFieldTypes CLASS TTable

  IF ::FFieldTypes = NIL
    ::FFieldTypes := {=>}
    ::FFieldTypes['C'] := "TStringField"    /* HB_FT_STRING */
    ::FFieldTypes['L'] := "TLogicalField"   /* HB_FT_LOGICAL */
    ::FFieldTypes['D'] := "TDateField"      /* HB_FT_DATE */
    ::FFieldTypes['I'] := "TNumericField"   /* HB_FT_INTEGER */
    ::FFieldTypes['Y'] := "TNumericField"   /* HB_FT_CURRENCY */
    ::FFieldTypes['2'] := "TNumericField"   /* HB_FT_INTEGER */
    ::FFieldTypes['4'] := "TNumericField"   /* HB_FT_INTEGER */
    ::FFieldTypes['N'] := "TNumericField"   /* HB_FT_LONG */
    ::FFieldTypes['F'] := "TNumericField"   /* HB_FT_FLOAT */
    ::FFieldTypes['8'] := "TNumericField"   /* HB_FT_DOUBLE */
    ::FFieldTypes['B'] := "TNumericField"   /* HB_FT_DOUBLE */

    ::FFieldTypes['T'] := "TTimeField"      /* HB_FT_DAYTIME(8) HB_FT_TIME(4) */
    ::FFieldTypes['@'] := "TDayTimeField"   /* HB_FT_DAYTIME */
    ::FFieldTypes['='] := "TModTimeField"   /* HB_FT_MODTIME */
    ::FFieldTypes['^'] := "TRowVerField"    /* HB_FT_ROWVER */
    ::FFieldTypes['+'] := "TAutoIncField"   /* HB_FT_AUTOINC */
    ::FFieldTypes['Q'] := "TVarLengthField" /* HB_FT_VARLENGTH */
    ::FFieldTypes['V'] := "TVarLengthField" /* HB_FT_VARLENGTH */
    ::FFieldTypes['M'] := "TMemoField"      /* HB_FT_MEMO */
    ::FFieldTypes['P'] := "TImageField"     /* HB_FT_IMAGE */
    ::FFieldTypes['W'] := "TBlobField"      /* HB_FT_BLOB */
    ::FFieldTypes['G'] := "TOleField"       /* HB_FT_OLE */
    ::FFieldTypes['0'] := "TVarLengthField" /* HB_FT_VARLENGTH (NULLABLE) */
  ENDIF

RETURN ::FFieldTypes

/*
  GetPublishedFieldList
  Teo. Mexico 2007
*/
METHOD FUNCTION GetPublishedFieldList CLASS TTable
  LOCAL Result := {}
  LOCAL AField

  FOR EACH AField IN Self:FFieldList
    IF !Empty( AField:Name ) .AND. AField:Published
      AAdd( Result, AField )
    ENDIF
  NEXT

  ASort( Result,,, {|x,y| x:ValType < y:ValType .OR. ( x:ValType == y:ValType .AND. x:Name < y:Name ) } )

RETURN Result

/*
  HasChilds
  Teo. Mexico
*/
METHOD FUNCTION HasChilds CLASS TTable
  LOCAL childTableName
  LOCAL ChildDB

  IF ! HB_HHasKey( ::DataBase:ParentChildList, ::ClassName )
    RETURN .F.
  ENDIF

  FOR EACH childTableName IN ::DataBase:GetParentChildList( ::ClassName )

    ChildDB := ::ChildSource( childTableName )

    IF ::DataBase:TableList[ childTableName, "IndexName" ] != NIL
      ChildDB:IndexName := ::DataBase:TableList[ childTableName, "IndexName" ]
    ENDIF

    IF ChildDB:First()
      RETURN .T.
    ENDIF

  NEXT

RETURN .F.

/*
  IndexByName
  Teo. Mexico 2006
*/
METHOD FUNCTION IndexByName( IndexName ) CLASS TTable
  LOCAL AIndex

  FOR EACH AIndex IN ::FIndexList
    IF IndexName == AIndex:Name
      RETURN AIndex
    ENDIF
  NEXT

RETURN NIL

/*
  Insert
  Teo. Mexico 2006
*/
METHOD FUNCTION Insert CLASS TTable

  IF !::State = dsBrowse
    ::Error_TableNotInBrowseState()
    RETURN .F.
  ENDIF

  ::OnBeforeInsert( Self )

  IF !::AddRec()
    RETURN .F.
  ENDIF

  ::OnAfterInsert( Self )

  /* To Flush !!! */
  ::Alias:DbSkip( 0 )

RETURN .T.

// dOMINOS PIZZA CANTAROS 58274343

/*
  InsertRecord
  Teo. Mexico 2007
*/
METHOD PROCEDURE InsertRecord( origin ) CLASS TTable

  IF !::Insert() .OR. !::CopyRecord( origin )
    RETURN
  ENDIF

  ::Post()

RETURN

/* TODO: Eliminate this Function */
/*
  InsideScope
  Teo. Mexico 2006
*/
METHOD FUNCTION InsideScope CLASS TTable
  LOCAL keyString

  IF ::Eof()
    RETURN .F.
  ENDIF

  IF ::PrimaryMasterKeyField=NIL
    RETURN .T.
  ENDIF

  keyString := ::PrimaryMasterKeyString

RETURN Empty( keyString ) .OR. ::Alias:KeyVal(::PrimaryIndex:Name) = keyString

/*
  MasterSourceClassName
  Teo. Mexico 2008
*/
METHOD FUNCTION MasterSourceClassName CLASS TTable
  LOCAL Result

  IF HB_HHasKey( ::DataBase:ChildParentList, ::ClassName )
    Result := ::DataBase:ChildParentList[ ::ClassName ]
    WHILE HB_HHasKey( ::DataBase:TableList, Result ) .AND. ::DataBase:TableList[ Result, "Virtual" ]
      IF !HB_HHasKey ( ::DataBase:ChildParentList, Result )
        EXIT
      ENDIF
      Result := ::DataBase:ChildParentList[ Result ]
    ENDDO
  ENDIF

RETURN Result

/*
  Next
  Teo. Mexico 2007
*/
METHOD PROCEDURE Next( numRecs ) CLASS TTable

  TRY
    IF AScan( {dsEdit,dsInsert}, ::FState ) > 0
      ::Post()
    ENDIF
    ::FIndex:Next( numRecs )
  CATCH

  END

RETURN

/*
  Open
  Teo. Mexico 2008
*/
METHOD FUNCTION Open CLASS TTable

  /*!
   * Make sure that database is open here
   */
  IF ::FAlias = NIL
    ::FAlias := TAlias():New( Self )
  ENDIF

  IF !HB_HHasKey( ::FInstances, ::TableClass )

    ::FInstances[ ::TableClass ] := HB_HSetCaseMatch( { "Initializing" => .T. }, .F. )

  ENDIF

  IF ::FInstances[ ::TableClass, "Initializing" ]

    ::FInstances[ ::TableClass, "ChildReferenceList" ] := {}

    ::DefineRelations()

    ::FInstances[ ::TableClass, "MasterDetailFieldList" ] := HB_HSetCaseMatch( {=>}, .F. )

    ::DefineMasterDetailFields()

    ::FInstances[ ::TableClass, "DisplayFieldsClass" ] := NIL

    ::FInstances[ ::TableClass, "Initializing" ] := .F.

  ENDIF

  /*!
   * Load definitions for Fields and Indexes
   */
  IF Empty( ::FFieldList )
    ::FFieldList := {}
    ::DefineFields()
  ENDIF
  IF Empty( ::FIndexList )
    ::FIndexList := {}
    ::DefineIndexes()
  ENDIF

  IF Len( ::FIndexList ) > 0 .AND. ::FIndex = NIL
    ::FIndex := ::FIndexList[ 1 ]
  ENDIF

  ::FState := dsBrowse

  ::FActive := .T.

  /*
   * Try to sync with MasterSource (if any)
   */
  ::SyncFromMasterSourceFields()

RETURN .T.

/*
  Post
  Teo. Mexico 2006
*/
METHOD FUNCTION Post CLASS TTable
  LOCAL AField
  LOCAL errObj
  LOCAL table

  TRY

    ::OnBeforePost( Self )

  CATCH

    ::Cancel()

    RETURN .F.

  END

  IF AScan( { dsEdit, dsInsert }, ::State ) = 0
    ::Error_Table_Not_In_Edit_or_Insert_mode()
    RETURN .F.
  ENDIF

  ::FSubState := dssPosting

  IF Len( ::DetailSourceList ) > 0
    FOR EACH table IN ::DetailSourceList
      IF AScan( { dsEdit, dsInsert }, table:State ) > 0
        table:Post()
      ENDIF
    NEXT
  ENDIF

  TRY

    FOR EACH AField IN ::FieldList

      IF !AField:IsValid()
        RAISE ERROR "Post: Invalid data on Field: <" + ::ClassName + ":" + AField:Name + ">"
      ENDIF

      IF AField:FieldMethodType = "C"
        AField:SetData()
      ENDIF

    NEXT

  CATCH errObj

    ::Cancel()

    Throw( errObj )

  FINALLY

    ::FSubState := dssNone

  END

  IF errObj != NIL
    RETURN .F.
  ENDIF

  ::RecUnLock()

  ::OnAfterPost( Self )

RETURN .T.

/*
  RawSeek
  Teo. Mexico 2008
*/
METHOD FUNCTION RawSeek( Value, index ) CLASS TTable
  LOCAL AIndex

  SWITCH ValType( index )
  CASE 'U'
    AIndex := ::FIndex
    EXIT
  CASE 'C'
    IF Empty( index )
      AIndex := ::FPrimaryIndex
    ELSE
      AIndex := ::IndexByName( index )
    ENDIF
    EXIT
  CASE 'N'
    IF index = 0
      AIndex := ::FPrimaryIndex
    ELSE
      AIndex := ::FIndexList[ index ]
    ENDIF
    EXIT
  CASE 'O'
    IF index:IsDerivedFrom( "TIndex" )
      AIndex := index
      EXIT
    ENDIF
  #ifdef __XHARBOUR__
  DEFAULT
  #else
  OTHERWISE
  #endif
    RAISE ERROR "Unknown index reference..."
  ENDSWITCH

RETURN AIndex:RawSeek( Value )

/*
  RecLock
  Teo. Mexico 2006
*/
METHOD FUNCTION RecLock CLASS TTable

  IF ::FState != dsBrowse
    ::Error_Table_Not_In_Browse_Mode()
    RETURN .F.
  ENDIF

  IF !::InsideScope .OR. !::Alias:RecLock()
    RETURN .F.
  ENDIF

  IF ::GetCurrentRecord()
    ::FState := dsEdit
  ELSE
    ::Alias:RecUnLock()
    RETURN .F.
  ENDIF

RETURN .T.

/*
  RecUnLock
  Teo. Mexico 2006
*/
METHOD FUNCTION RecUnLock CLASS TTable
  LOCAL Result
  IF ( Result := ::Alias:RecUnLock() )
    ::FState := dsBrowse
  ENDIF
RETURN Result

/*
  Refresh
  Teo. Mexico 2007
*/
METHOD PROCEDURE Refresh CLASS TTable
  IF ::FRecNo = ::Alias:RecNo
    RETURN
  ENDIF
  ::GetCurrentRecord()
RETURN

/*
  Reset
  Teo. Mexico 2006
*/
METHOD PROCEDURE Reset CLASS TTable
  LOCAL AField

  ::FRecNo := 0

  FOR EACH AField IN ::FFieldList

    IF AField:FieldMethodType = "C" .AND. !AField:Calculated
      AField:Reset()
    ENDIF

  NEXT

RETURN

/*
  Seek
  Teo. Mexico 2007
*/
METHOD FUNCTION Seek( Value, index, lSoftSeek ) CLASS TTable
  LOCAL AIndex

  SWITCH ValType( index )
  CASE 'U'
    AIndex := ::FIndex
    EXIT
  CASE 'C'
    IF Empty( index )
      AIndex := ::FPrimaryIndex
    ELSE
      AIndex := ::IndexByName( index )
    ENDIF
    EXIT
  CASE 'N'
    IF index = 0
      AIndex := ::FPrimaryIndex
    ELSE
      AIndex := ::FIndexList[ index ]
    ENDIF
    EXIT
  CASE 'O'
    IF index:IsDerivedFrom( "TIndex" )
      AIndex := index
      EXIT
    ENDIF
  #ifdef __XHARBOUR__
  DEFAULT
  #else
  OTHERWISE
  #endif
    RAISE ERROR "Unknown index reference..."
  ENDSWITCH

RETURN AIndex:Seek( Value, lSoftSeek )

/*
  SetIndexName
  Teo. Mexico 2007
*/
METHOD PROCEDURE SetIndexName( IndexName ) CLASS TTable
  LOCAL AIndex

  IndexName := Upper( IndexName )

  FOR EACH AIndex IN ::FIndexList
    IF Upper( AIndex:Name ) == IndexName
      ::FIndex := AIndex
      RETURN
    ENDIF
  NEXT

  RAISE ERROR  "<" + ::ClassName + ">: Index name '"+IndexName+"' doesn't exist..."

RETURN

/*
  SetMasterSource
  Teo. Mexico 2007
*/
METHOD PROCEDURE SetMasterSource( MasterSource ) CLASS TTable

  IF ::FMasterSource == MasterSource
    RETURN
  ENDIF

  ::FMasterSource := MasterSource

  /*
   * Check if another Self is already in the MasterSource DetailSourceList
   * and RAISE ERROR if another Self is trying to break the previous link
   */
  IF HB_HHasKey( MasterSource:DetailSourceList, ::ClassName) .AND. ;
     MasterSource:DetailSourceList[ ::ClassName ] != NIL .AND. ;
     !MasterSource:DetailSourceList[ ::ClassName ] == Self
    RAISE ERROR "Cannot re-assign DetailSourceList:<" + ::ClassName +">"
  ENDIF

  MasterSource:DetailSourceList[ ::ClassName ] := Self

  ::SyncFromMasterSourceFields()

RETURN

/*
  SetPrimaryIndex
  Teo. Mexico 2007
*/
METHOD PROCEDURE SetPrimaryIndex( AIndex ) CLASS TTable

  ::FPrimaryIndex := AIndex

  IF ::FIndex = NIL
    ::FIndex := AIndex
  ENDIF

RETURN

/*
  SyncDetailSources
  Teo. Mexico 2007
*/
METHOD PROCEDURE SyncDetailSources CLASS TTable
  LOCAL DetailSource

  IF Empty( ::DetailSourceList )
    RETURN
  ENDIF

  FOR EACH DetailSource IN ::DetailSourceList
    IF DetailSource != NIL
      DetailSource:SyncFromMasterSourceFields()
    ENDIF
  NEXT

RETURN

/*
  SyncFromMasterSourceFields
  Teo. Mexico 2007
*/
METHOD PROCEDURE SyncFromMasterSourceFields CLASS TTable

  /* TField:Reset does the job */
  IF ::PrimaryMasterKeyField != NIL
    ::PrimaryMasterKeyField:Reset()
  ENDIF

  IF ::FActive
    ::First()
  ENDIF

RETURN

/*
  SyncRecNo
  Teo. Mexico 2007
*/
METHOD PROCEDURE SyncRecNo( directAlias ) CLASS TTable
  IF directAlias == .T.
    ::Alias:SyncFromAlias()
  ELSE
    ::Alias:SyncFromRecNo()
  ENDIF
  IF ::FRecNo = ::Alias:RecNo
    RETURN
  ENDIF
  ::GetCurrentRecord()
RETURN

/*
  ValidateFields
  Teo. Mexico 2007
*/
METHOD FUNCTION ValidateFields CLASS TTable
  LOCAL AField

  FOR EACH AField IN ::FFieldList
    IF !AField:IsValid()
      RETURN .F.
    ENDIF
  NEXT

RETURN .T.

/*
  End Class TTable
*/
