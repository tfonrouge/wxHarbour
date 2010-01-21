/*
 * $Id$
 */

/*
	TTable
	Teo. Mexico 2007
*/

#ifdef __XHARBOUR__
	#include "wx_hbcompat.ch"
#endif

#include "wxharbour.ch"
#include "xerror.ch"

#define rxMasterSourceTypeNone     0
#define rxMasterSourceTypeTTable   1
#define rxMasterSourceTypeTField   2
#define rxMasterSourceTypeBlock    3

REQUEST TField

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
CLASS TTable FROM WXHBaseClass
PRIVATE:

	DATA pSelf

	CLASSDATA FFieldTypes
	CLASSDATA FInstances INIT HB_HSetCaseMatch( {=>}, .F. )

	DATA FActive				INIT .F.
	DATA FAddress
	DATA FAlias
	DATA FDisplayFields										// Contains a Object
	DATA FHasDeletedOrder INIT .F.
	DATA FIndex														// Current TIndex in Table
	DATA FMasterSource
	DATA FMasterSourceType  INIT rxMasterSourceTypeNone
	DATA FPort

	/* TODO: Check if we can re-use a client socket */
	DATA FRDOClient

	DATA FRecNoBeforeInsert

	DATA FReadOnly              INIT .F.
	DATA FRecNo					INIT 0
	DATA FRemote				INIT .F.
	DATA FState INIT dsInactive
	DATA FSubState INIT dssNone
	DATA FSyncingToContainerField INIT .F.
	DATA FTableFileName
	DATA FTimer INIT 0
	DATA FUndoList

	METHOD DbGoBottomTop( n )
	METHOD GetAlias
	METHOD GetBof INLINE ::Alias:Bof
	METHOD GetDbStruct
	METHOD GetEof INLINE ::Alias:Eof
	METHOD GetFieldTypes
	METHOD GetFound INLINE ::Alias:Found
	METHOD GetIndexName INLINE ::FIndex:Name
	METHOD GetInstance EXPORTED
	METHOD GetMasterSource()
	METHOD GetPrimaryIndex( curClass )
	METHOD GetPrimaryMasterKeyField()
	METHOD GetPrimaryMasterKeyString INLINE iif( ::GetPrimaryMasterKeyField == NIL, "", ::GetPrimaryMasterKeyField:AsString )
	METHOD GetPublishedFieldList
	METHOD GetTableName INLINE ::TableNameValue
	METHOD SetIndex( AIndex ) INLINE ::FIndex := AIndex
	METHOD SetIndexName( IndexName )
	METHOD SetMasterSource( masterSource )
	METHOD SetReadOnly( readOnly )
	METHOD SetState( state )
	METHOD SetSyncingToContainerField( value ) INLINE ::FSyncingToContainerField := value
	METHOD Process_TableName( tableName )
#ifndef __XHARBOUR__
	METHOD SendToServer
#endif

PROTECTED:

	CLASSDATA FDbStructValidated INIT .F.

	DATA FBaseClass
	DATA FFieldList
	DATA FIndexList        INIT HB_HSetCaseMatch( {=>}, .F. )  // <className> => <indexName> => <indexObject>
	DATA FPrimaryIndexList INIT HB_HSetCaseMatch( {=>}, .F. )  // <className> => <indexName>
	DATA MasterSourceBaseClass EXPORTED
	DATA TableNameValue INIT "" // to be assigned (INIT) on inherited classes

	METHOD AddRec()
	METHOD CheckDbStruct()
	METHOD FillPrimaryIndexes( curClass )
	METHOD FindDetailSourceField( masterField )
	METHOD InitDataBase INLINE TDataBase():New()
	METHOD InitTable()
	METHOD RawGet4Seek( direction, xField, keyVal, index, softSeek )

PUBLIC:

	CLASSDATA DataBase

	DATA allowDataChange INIT .T.
	DATA autoOpen INIT .T.
	DATA dataIsOEM	INIT .T.
	/*!
		array of possible TObjectField's that have this (SELF) object referenced
	 */
	DATA DetailSourceList INIT {=>}
	DATA FieldNamePrefix	INIT "Field_"		// Table Field Name prefix
	DATA FUnderReset INIT .F.
	DATA LinkedObjField
	DATA validateDbStruct INIT .T.		// On Open, Check for a valid struct dbf (against DEFINE FIELDS )

	CONSTRUCTOR New( MasterSource, tableName )

	DEFINE FIELDS
	DEFINE INDEXES											VIRTUAL

	METHOD BaseSeek( direction, Value, index, lSoftSeek )
	METHOD AddMessageField( MessageName, AField )
	METHOD Cancel
	METHOD ChildSource( tableName )
	METHOD CopyRecord( origin )
	METHOD Count
	METHOD DefineMasterDetailFields			VIRTUAL
	METHOD DefineRelations							VIRTUAL
	METHOD Destroy()
	METHOD DbEval( bBlock, bForCondition, bWhileCondition )
	METHOD DbGoBottom INLINE ::DbGoBottomTop( 1 )
	METHOD DbGoTo( RecNo )
	METHOD DbGoTop INLINE ::DbGoBottomTop( 0 )
	METHOD DbSkip( numRecs )
	METHOD Delete( lDeleteChilds )
	METHOD DeleteChilds
	METHOD Edit()
	METHOD FieldByName
	METHOD FindMasterSourceField( detailField )
	METHOD FindTable( table )
	METHOD FullFileName
	METHOD Get4Seek( xField, keyVal, index, softSeek ) INLINE ::RawGet4Seek( 1, xField, keyVal, index, softSeek )
	METHOD Get4SeekLast( xField, keyVal, index, softSeek ) INLINE ::RawGet4Seek( 0, xField, keyVal, index, softSeek )
	METHOD GetAsString
	METHOD GetAsVariant
	METHOD GetCurrentRecord()
	METHOD GetDisplayFieldBlock( xField )
	METHOD GetDisplayFields( syncFromAlias )
	METHOD GetField( fld )
	METHOD GetIndex( index )
	METHOD GetMasterSourceClassName( className )
	METHOD GetPrimaryKeyField( masterSourceBaseClass )
	METHOD HasChilds
	METHOD IndexByName( IndexName, curClass )
	METHOD Insert()
	METHOD InsertRecord( origin )
	METHOD InsideScope()
	METHOD Open
	METHOD Post()
	METHOD RawSeek( Value, index )
	METHOD RecLock
	METHOD RecUnLock
	METHOD Refresh
	METHOD Reset()								// Set Field Record to their default values, Sync MasterKeyString Value
	METHOD Seek( Value, AIndex, SoftSeek ) INLINE ::BaseSeek( 0, Value, AIndex, SoftSeek )
	METHOD SeekLast( Value, AIndex, SoftSeek ) INLINE ::BaseSeek( 1, Value, AIndex, SoftSeek )
	METHOD SetAsString( Value ) INLINE ::GetPrimaryKeyField():AsString := Value
	METHOD SetAsVariant( Value ) INLINE ::GetPrimaryKeyField():Value := Value
	/*
	 * TODO: Enhance this to:
	 *			 <order> can be "fieldname" or "fieldname1;fieldname2"
	 *			 able to create a live index
	 */
	METHOD SetOrderBy( order ) INLINE ::FIndex := ::FieldByName( order ):KeyIndex
	METHOD SkipBrowse( n )
	METHOD SyncDetailSources
	METHOD SyncFromMasterSourceFields()
	METHOD SyncRecNo( fromAlias )
	METHOD TableClass INLINE ::ClassName + "@" + ::TableName

	METHOD Validate( showAlert )

	METHOD OnCreate() VIRTUAL
	METHOD OnAfterCancel() VIRTUAL
	METHOD OnAfterDelete() VIRTUAL
	METHOD OnAfterInsert() VIRTUAL
	METHOD OnAfterOpen() VIRTUAL
	METHOD OnAfterPost VIRTUAL
	METHOD OnBeforeInsert() INLINE .T.
	METHOD OnBeforePost() INLINE .T.
	METHOD OnDataChange() VIRTUAL
	METHOD OnPickList( param ) VIRTUAL
	METHOD OnStateChange( state ) VIRTUAL

	PROPERTY Active READ FActive
	PROPERTY Alias READ GetAlias
	PROPERTY AsString READ GetAsString WRITE SetAsString
	PROPERTY BaseClass READ FBaseClass
	PROPERTY Bof READ GetBof
	PROPERTY DbStruct READ GetDbStruct
	PROPERTY Deleted READ Alias:Deleted()
	PROPERTY DisplayFields READ GetDisplayFields
	PROPERTY Eof READ GetEof
	PROPERTY FieldList READ FFieldList
	PROPERTY Found READ GetFound
	PROPERTY FieldTypes READ GetFieldTypes
	PROPERTY Instance READ GetInstance
	PROPERTY Instances READ FInstances
	PROPERTY KeyVal READ GetAlias():KeyVal()
	PROPERTY PrimaryIndexList READ FPrimaryIndexList
	PROPERTY PrimaryMasterKeyString READ GetPrimaryMasterKeyString
	PROPERTY RDOClient READ FRDOClient
	PROPERTY RecCount READ GetAlias:RecCount()
	PROPERTY RecNo READ FRecNo WRITE DbGoTo
	PROPERTY State READ FState
	PROPERTY SubState READ FSubState
	PROPERTY SyncingToContainerField READ FSyncingToContainerField WRITE SetSyncingToContainerField
	PROPERTY TableFileName READ FTableFileName
	PROPERTY UndoList READ FUndoList

PUBLISHED:

	DATA Cargo

	PROPERTY ChildReferenceList READ FInstances[ ::TableClass, "ChildReferenceList" ]
	PROPERTY Index READ FIndex WRITE SetIndex
	PROPERTY IndexList READ FIndexList
	PROPERTY IndexName READ GetIndexName WRITE SetIndexName
	PROPERTY MasterDetailFieldList READ FInstances[ ::TableClass, "MasterDetailFieldList" ]
	PROPERTY MasterSource READ GetMasterSource WRITE SetMasterSource
	PROPERTY PrimaryMasterKeyField READ GetPrimaryMasterKeyField
	PROPERTY PrimaryIndex READ GetPrimaryIndex
	PROPERTY PublishedFieldList READ GetPublishedFieldList
	PROPERTY ReadOnly READ FReadOnly WRITE SetReadOnly
	PROPERTY TableName READ GetTableName
	PROPERTY Value READ GetAsVariant WRITE SetAsVariant

ENDCLASS

/*
	New
	Teo. Mexico 2006
*/
METHOD New( masterSource, tableName ) CLASS TTable
	LOCAL rdoClient
	LOCAL Result,itm

	::Process_TableName( tableName )

	IF ::FRDOClient != NIL

		rdoClient := ::FRDOClient

		Result := ::SendToServer( masterSource, ::TableFileName )

		? "Result from Server:"
		? "ClassName:",Result:ClassName,":",Result
		? "Alias",Result:Alias:Name

		FOR EACH itm IN Result
			Self[ itm:__enumIndex() ] := itm
		NEXT

		::FRDOClient := rdoClient

		IF !HB_HHasKey( ::FInstances, ::TableName )
			::FInstances[ ::TableName ] := ::GetInstance()
		ENDIF

		RETURN Self

	ENDIF

	IF ::DataBase == NIL
		::DataBase := ::InitDataBase()
	ENDIF

	/*!
	 * Sets the MasterSource (maybe will be needed in the fields definitions ahead )
	 */
	IF masterSource != NIL
	
		/*
		 * As we have not fields defined yet, this will not execute SyncFromMasterSourceFields()
		 */
		::SetMasterSource( masterSource )

	ENDIF

	IF Empty( ::TableName )
		::Error_Empty_TableName()
	ENDIF
	
	::InitTable()

	::OnCreate()

	/* Check for a valid db structure (based on definitions on DEFINE FIELDS) */
	IF ::validateDbStruct .AND. !::FDbStructValidated
		::CheckDbStruct()
	ENDIF

	IF ::autoOpen
		::Open()
	ENDIF
	
RETURN Self

/*
	AddMessageField
	Teo. Mexico 2006
*/
METHOD PROCEDURE AddMessageField( MessageName, AField ) CLASS TTable
	LOCAL n

//	 IF !::Instances[ ::ClassName ]["Initializing"]
//		 RETURN
//	 ENDIF

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

	//MessageName := ::FieldNamePrefix + MessageName
	//EXTEND OBJECT Self WITH MESSAGE MessageName INLINE ::FFieldList[n]

	EXTEND OBJECT Self WITH MESSAGE ::FieldNamePrefix + MessageName INLINE ::FieldByName( MessageName )

RETURN

/*
	AddRec
	Teo. Mexico 2006
*/
METHOD FUNCTION AddRec() CLASS TTable
	LOCAL Result
	LOCAL AField
	LOCAL errObj
	LOCAL index

	IF ::FReadOnly
		wxhAlert( "Table '" + ::ClassName() + "' is marked as READONLY...")
		RETURN .F.
	ENDIF

	IF ::FHasDeletedOrder
		index := "Deleted"
	ELSEIF ::PrimaryIndex != NIL
		index := ::PrimaryIndex:Name
	ENDIF

	::FRecNoBeforeInsert := ::RecNo()

	IF !( Result := ::Alias:AddRec(index) )
		RETURN Result
	ENDIF

	::Reset() // Reset record data to default values

	::FRecNo := ::Alias:RecNo

	::SetState( dsInsert )
	::FSubState := dssAdding

	/*
	 * Write the PrimaryMasterKeyField
	 * Write the PrimaryKeyField
	 * Write the Fields that have a DefaultValue
	 */
	BEGIN SEQUENCE WITH {|oErr| Break( oErr ) }
	
		::FillPrimaryIndexes( Self )

		FOR EACH AField IN ::FFieldList
			IF AField:FieldMethodType = 'C' .AND. !AField:PrimaryKeyComponent .AND. AField:WrittenValue == NIL
				IF AField:DefaultValue != NIL .OR. AField:AutoIncrement
					AField:SetData()
				ENDIF
			ENDIF
		NEXT

	RECOVER USING errObj

		::TTable:Delete()
		::RecUnLock()

		SHOW ERROR errObj

		Result := .F.

	END SEQUENCE

	::FSubState := dssNone

RETURN Result

/*
	BaseSeek
	Teo. Mexico 2007
*/
METHOD FUNCTION BaseSeek( direction, Value, index, lSoftSeek ) CLASS TTable
	LOCAL AIndex
	
	AIndex := ::GetIndex( index )

	IF direction = 0
		RETURN AIndex:BaseSeek( 0, Value, lSoftSeek )
	ENDIF

RETURN AIndex:BaseSeek( 1, Value, lSoftSeek )

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
			IF AField:FieldMethodType = "C" .AND. !Empty( AField:Value ) .AND. !AField:IsValid()
				AField:Reset()
			ENDIF
		NEXT
		::TTable:Delete()
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
	
	::OnAfterCancel()

	IF ::FRecNoBeforeInsert != NIL
		::RecNo := ::FRecNoBeforeInsert
		::FRecNoBeforeInsert := NIL
	ENDIF

RETURN

/*
	CheckDbStruct
	Teo. Mexico 2010
*/
METHOD FUNCTION CheckDbStruct() CLASS TTable
	LOCAL AField,pkField
	LOCAL n
	LOCAL aDb := ::DbStruct()
	LOCAL sResult := ""
	
	FOR EACH AField IN ::FieldList
		IF AField:FieldMethodType = "C" .AND. !AField:Calculated

			n := AScan( aDb, {|e| Upper( e[1] ) == Upper( AField:DBS_NAME ) } )

			IF AField:IsDerivedFrom("TObjectField")
				pkField := AField:DataObj:GetPrimaryKeyField( AField:ObjValueClassName )
			ELSE
				pkField := AField
			ENDIF

			IF n = 0
				sResult += "Field not found: " + pkField:DBS_NAME + E"\n"
			ELSEIF !aDb[ n, 2 ] == pkField:DBS_TYPE
				sResult += "Wrong field type: " + pkField:DBS_NAME + E"\n"
			ELSEIF aDb[ n, 2 ] = "N" .AND. ( !aDb[ n, 3 ] == pkField:DBS_LEN .OR. !aDb[ n, 4 ] == pkField:DBS_DEC )
				sResult += "Wrong len/dec values on numeric field: " + pkField:DBS_NAME + E"\n"
			ENDIF

		ENDIF
	NEXT
	
	IF ! Empty( sResult )
	    ? "Error on Db structure..."
		? "Class:", ::ClassName(), "Database:", ::Alias:Name
		? sResult
	ENDIF
	
	::FDbStructValidated := .T.

RETURN .T.

/*
	ChildSource
	Teo. Mexico 2008
*/
METHOD FUNCTION ChildSource( tableName ) CLASS TTable
	LOCAL itm
	
	tableName := Upper( tableName )

	/* tableName is in the DetailSourceList */
	FOR EACH itm IN ::DetailSourceList
		IF itm:ClassName() == tableName
			itm:Reset()
			RETURN itm
		ENDIF
	NEXT
	
RETURN __ClsInstFromName( tableName ):New( Self )

/*
	CopyRecord
	Teo. Mexico 2007
*/
METHOD FUNCTION CopyRecord( origin ) CLASS TTable
	LOCAL AField
	LOCAL AField1
	LOCAL entry

	SWITCH ValType( origin )
	CASE 'O'	// Record from another Table
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
	CASE 'H'	// Hash of Values
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
METHOD FUNCTION Count( whileBlock ) CLASS TTable
	LOCAL nCount := 0
	LOCAL RecNo
	LOCAL key
	LOCAL indexName

	RecNo := ::FAlias:RecNo

	key := ::PrimaryMasterKeyString
	indexName := ::PrimaryIndex:Name

	::FAlias:Seek( key, indexName )

	WHILE !::FAlias:Eof() .AND. ::FAlias:KeyVal( indexName ) = key
		IF whileBlock == NIL .OR. whileBlock:Eval( ::FAlias )
			nCount++
		ENDIF
		::DbSkip()
	ENDDO

	::FAlias:RecNo := RecNo

RETURN nCount

/*
	DbEval
	Teo. Mexico 2008
*/
METHOD PROCEDURE DbEval( bBlock, bForCondition, bWhileCondition ) CLASS TTable
	LOCAL DetailSourceList

	IF ::FMasterSource != NIL
		DetailSourceList := ::MasterSource:DetailSourceList
		::MasterSource:DetailSourceList := {=>}
	ENDIF

	IF ::pSelf == NIL
		::pSelf := __ClsInst( ::ClassH ):New( ::FMasterSource )
	ENDIF

	::pSelf:DbGoTop()

	WHILE !::pSelf:Eof() .AND. ( bWhileCondition == NIL .OR. bWhileCondition:Eval( ::pSelf ) )

		IF bForCondition == NIL .OR. bForCondition:Eval( ::pSelf )
			bBlock:Eval( ::pSelf )
		ENDIF

		::pSelf:DbSkip()

	ENDDO

	IF DetailSourceList != NIL
		::MasterSource:DetailSourceList := DetailSourceList
	ENDIF

RETURN

/*
	DbGoBottomTop
	Teo. Mexico 2007
*/
METHOD FUNCTION DbGoBottomTop( n ) CLASS TTable

	IF AScan( {dsEdit,dsInsert}, ::FState ) > 0
		::Post()
	ENDIF
	
	IF ::FIndex != NIL
		IF n = 0
			RETURN ::FIndex:DbGoTop()
		ELSE
			RETURN ::FIndex:DbGoBottom()
		ENDIF
	ELSE
		IF n = 0
			::Alias:DbGoTop()
		ELSE
			::Alias:DbGoBottom()
		ENDIF
		::GetCurrentRecord()
	ENDIF

RETURN .F.

/*
	DbGoTo
	Teo. Mexico 2007
*/
METHOD DbGoTo( RecNo ) CLASS TTable
	LOCAL Result

	Result := ::Alias:DbGoTo( RecNo )

	::GetCurrentRecord()

RETURN Result

/*
	DbSkip
	Teo. Mexico 2007
*/
METHOD PROCEDURE DbSkip( numRecs ) CLASS TTable

	IF AScan( {dsEdit,dsInsert}, ::FState ) > 0
		::Post()
	ENDIF
	IF ::FIndex != NIL
		::FIndex:DbSkip( numRecs )
	ELSE
		::Alias:DbSkip( numRecs )
		::GetCurrentRecord()
	ENDIF

RETURN

/*
	FIELDS
	Teo. Mexico 2008
*/
METHOD PROCEDURE __DefineFields( curClass ) CLASS TTable
	LOCAL dbStruct := ::GetDbStruct()
	LOCAL fld
	LOCAL AField

	IF !Empty( ::FieldList )
		RETURN
	ENDIF

	FIELDS BASECLASS

	FOR EACH fld IN dbStruct

		AField := __ClsInstFromName( ::FieldTypes[ fld[ 2 ] ]	 ):New( Self )

		AField:FieldMethod := fld[ 1 ]

	NEXT

RETURN /* no Super:__DefineFields to call here */

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
			wxhAlert("Error_Table_Has_Childs")
			RETURN .F.
		ENDIF
		IF !::DeleteChilds()
			RETURN .F.
		ENDIF
	ENDIF

	FOR EACH AField IN ::FieldList
		AField:Delete()
	NEXT

	IF ::FHasDeletedOrder()
		::Alias:DbDelete()
	ENDIF

	::RecUnLock()
	
	::OnAfterDelete()

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

		WHILE ChildDB:DbGoTop()
			ChildDB:TTable:Delete( .T. )
		ENDDO

	NEXT

	::Alias:DbGoTo(nrec)

RETURN .T.

/*
	Destroy
	Teo. Mexico 2008
*/
METHOD PROCEDURE Destroy() CLASS TTable

	IF ::MasterSource != NIL
		IF HB_HHasKey( ::MasterSource:DetailSourceList, ::ObjectH )
			HB_HDel( ::MasterSource:DetailSourceList, ::ObjectH )
		ENDIF
	ENDIF

	IF ::pSelf != NIL
		::pSelf:Destroy()
		::pSelf := NIL
	ENDIF

	IF !HB_IsArray( ::FFieldList )
		//WLOG("ERROR!: " + ::ClassName + ":Destroy - :FieldList is not a array...")
		RETURN
	ENDIF

	::FFieldList := NIL

	::FActive := .F.

RETURN

/*
	Edit
	Teo. Mexico 2006
*/
METHOD FUNCTION Edit() CLASS TTable

	IF !::State = dsBrowse
		::Error_TableNotInBrowseState()
		RETURN .F.
	ENDIF

	IF !::RecLock()
		RETURN .F.
	ENDIF
	
	::FUndoList := HB_HSetCaseMatch( {=>}, .F. )

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
	FillPrimaryIndexes
	Teo. Mexico 2009
*/
METHOD PROCEDURE FillPrimaryIndexes( curClass ) CLASS TTable
	LOCAL className
	LOCAL AIndex
	LOCAL AField

	className := curClass:ClassName()

	IF !className == "TTABLE"
	
		::FillPrimaryIndexes( curClass:Super )
		
		IF HB_HHasKey( ::FPrimaryIndexList, className )
			AIndex := ::FIndexList[ className, ::FPrimaryIndexList[ className ] ]
		ELSE
			AIndex := NIL
		ENDIF

		IF AIndex != NIL
			AField := AIndex:MasterKeyField
			IF AField != NIL
				AField:SetData()
			ENDIF
			/*!
			 * AutoIncrement fields always need to be written (to set a value)
			 */
			AField := AIndex:UniqueKeyField
			IF AField != NIL .AND. ( AIndex:AutoIncrement .OR. !Empty( AField:Value ) )
				AField:SetData()
			ENDIF
		ENDIF
	
	ENDIF

RETURN

/*
	FindDetailSourceField
	Teo. Mexico 2007
*/
METHOD FUNCTION FindDetailSourceField( masterField ) CLASS TTable
	LOCAL Result

	IF HB_HHasKey( ::MasterDetailFieldList, masterField:Name )
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

	IF ::FMasterSource == NIL
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
			RETURN ::MasterSource:FieldByName( enum:__enumValue )
		ENDIF
	NEXT

RETURN ::MasterSource:FieldByName( name )

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
		RETURN ::MasterSource:FindTable( table )
	ENDIF

RETURN NIL

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

RETURN Result + ::TableFileName

/*
	GetAlias
	Teo. Mexico 2008
*/
METHOD FUNCTION GetAlias CLASS TTable
	IF ::FRDOClient != NIL .AND. ::FAlias == NIL
		//::FAlias := ::SendToServer()
	ENDIF
RETURN ::FAlias

/*
	GetAsString
	Teo. Mexico 2009
*/
METHOD GetAsString() CLASS TTable
	LOCAL pkField := ::GetPrimaryKeyField()

	IF pkField == NIL
		RETURN ""
	ENDIF

RETURN pkField:AsString

/*
	GetAsVariant
	Teo. Mexico 2009
*/
METHOD GetAsVariant() CLASS TTable
	LOCAL pkField := ::GetPrimaryKeyField()

	IF pkField == NIL
		RETURN NIL
	ENDIF

RETURN pkField:Value

/*
	GetCurrentRecord
	Teo. Mexico 2007
*/
METHOD FUNCTION GetCurrentRecord() CLASS TTable
	LOCAL AField
	LOCAL Result
	
	IF ::FState = dsBrowse

		/*
		 * Record needs to have a valid MasterKeyField
		 */
		IF ( Result := ::InsideScope() )

			::FRecNo := ::Alias:RecNo

			FOR EACH AField IN ::FFieldList

				IF AField:FieldMethodType = "C" .AND. !AField:Calculated .AND. !AField:IsTheMasterSource
					AField:GetData()
				ENDIF

			NEXT

		ELSE
			::FRecNo := 0
			::Alias:DbGoTo( 0 )
			::Reset()
		ENDIF

		::SyncDetailSources()
		
		IF Result .AND. ::allowDataChange
			::OnDataChange()
		ENDIF

	ELSE
		//RAISE ERROR "Table not in dsBrowse mode..."
		Result := .F.
	ENDIF

RETURN Result

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
METHOD FUNCTION GetDisplayFieldBlock( xField ) CLASS TTable
	LOCAL AField
	LOCAL msgName
	
	SWITCH ValType( xField )
	CASE 'C'
		AField := ::FieldByName( xField )
		EXIT
	CASE 'O'
		AField := xField
		EXIT
	CASE 'N'
		AField := ::FieldList[ xField ]
		EXIT
	END
	
	IF AField == NIL
		RAISE ERROR "Wrong value"
		RETURN NIL
	ENDIF
	
	msgName := AField:Name

	IF ! AField:IsDerivedFrom("TObjectField")
		RETURN ;
			BEGIN_CB|o|
				LOCAL Result
				LOCAL AField
				
				IF HB_HHasKey( o:__FFields, msgName )
					AField := o:__FFields[ msgName ]
				ELSE
					AField := o:__FObj:FieldByName( msgName )
					o:__FFields[ msgName ] := AField
				ENDIF
				
				IF o:__FSyncFromAlias
					o:__FObj:SyncRecNo( .T. )
				ENDIF
				
				IF o:__FObj:Eof() .OR. o:__FObj:Bof()
					Result := AField:EmptyValue
				ELSE
					Result := AField:Value
				ENDIF
				
				RETURN Result

			END_CB

	ENDIF

	RETURN ;
		BEGIN_CB|o|
			LOCAL AField
			LOCAL Result

			IF HB_HHasKey( o:__FFields, msgName )
				AField := o:__FFields[ msgName ]
			ELSE
				AField := o:__FObj:FieldByName( msgName )
				o:__FFields[ msgName ] := AField
			ENDIF

			IF o:__FSyncFromAlias
				o:__FObj:SyncRecNo( .T. )
			ENDIF

			Result := AField:DataObj:DisplayFields()
				
			RETURN Result

		END_CB

METHOD FUNCTION GetDisplayFields( syncFromAlias ) CLASS TTable
	LOCAL DisplayFieldsClass
	LOCAL msgName
	LOCAL AField

	IF ::FDisplayFields == NIL

		IF ::FInstances[ ::TableClass, "DisplayFieldsClass" ] == NIL

			DisplayFieldsClass := HBClass():New( ::ClassName + "DisplayFields" )

			DisplayFieldsClass:AddData( "__FObj" )
			DisplayFieldsClass:AddData( "__FFields" )
			DisplayFieldsClass:AddData( "__FSyncFromAlias" )

			FOR EACH AField IN ::FFieldList

				msgName := AField:Name

				/* TODO: Check for a duplicate message name */
				IF !Empty( msgName ) //.AND. ! __ObjHasMsg( ef, msgName )

					DisplayFieldsClass:AddInline( msgName, ::GetDisplayFieldBlock( msgName ) )

				ENDIF

			NEXT

			// Create the MasterSource field access reference
			IF ::FMasterSource != NIL
				DisplayFieldsClass:AddInline( "MasterSource", {|Self| ::__FObj:MasterSource:GetDisplayFields() } )
			ENDIF

			DisplayFieldsClass:Create()

			::FInstances[ ::TableClass, "DisplayFieldsClass" ] := DisplayFieldsClass

		ENDIF

		::FDisplayFields := ::FInstances[ ::TableClass, "DisplayFieldsClass" ]:Instance()
		::FDisplayFields:__FObj := Self
		::FDisplayFields:__FFields := {=>}
		::FDisplayFields:__FSyncFromAlias := syncFromAlias == .T.

	ENDIF

RETURN ::FDisplayFields

/*
	GetFieldTypes
	Teo. Mexico 2008
*/
METHOD FUNCTION GetFieldTypes CLASS TTable

	IF ::FFieldTypes == NIL
		::FFieldTypes := {=>}
		::FFieldTypes['C'] := "TStringField"		/* HB_FT_STRING */
		::FFieldTypes['L'] := "TLogicalField"		/* HB_FT_LOGICAL */
		::FFieldTypes['D'] := "TDateField"			/* HB_FT_DATE */
		::FFieldTypes['I'] := "TNumericField"		/* HB_FT_INTEGER */
		::FFieldTypes['Y'] := "TNumericField"		/* HB_FT_CURRENCY */
		::FFieldTypes['2'] := "TNumericField"		/* HB_FT_INTEGER */
		::FFieldTypes['4'] := "TNumericField"		/* HB_FT_INTEGER */
		::FFieldTypes['N'] := "TNumericField"		/* HB_FT_LONG */
		::FFieldTypes['F'] := "TNumericField"		/* HB_FT_FLOAT */
		::FFieldTypes['8'] := "TNumericField"		/* HB_FT_DOUBLE */
		::FFieldTypes['B'] := "TNumericField"		/* HB_FT_DOUBLE */

		::FFieldTypes['T'] := "TTimeField"			/* HB_FT_DAYTIME(8) HB_FT_TIME(4) */
		::FFieldTypes['@'] := "TDayTimeField"		/* HB_FT_DAYTIME */
		::FFieldTypes['='] := "TModTimeField"		/* HB_FT_MODTIME */
		::FFieldTypes['^'] := "TRowVerField"		/* HB_FT_ROWVER */
		::FFieldTypes['+'] := "TAutoIncField"		/* HB_FT_AUTOINC */
		::FFieldTypes['Q'] := "TVarLengthField" /* HB_FT_VARLENGTH */
		::FFieldTypes['V'] := "TVarLengthField" /* HB_FT_VARLENGTH */
		::FFieldTypes['M'] := "TMemoField"			/* HB_FT_MEMO */
		::FFieldTypes['P'] := "TImageField"			/* HB_FT_IMAGE */
		::FFieldTypes['W'] := "TBlobField"			/* HB_FT_BLOB */
		::FFieldTypes['G'] := "TOleField"				/* HB_FT_OLE */
		::FFieldTypes['0'] := "TVarLengthField" /* HB_FT_VARLENGTH (NULLABLE) */
	ENDIF

RETURN ::FFieldTypes

/*
	GetField
	Teo. Mexico 2009
*/
METHOD FUNCTION GetField( fld ) CLASS TTable
	LOCAL AField
	
	SWITCH ValType( fld )
	CASE 'C'
		AField := ::FieldByName( fld )
		EXIT
	CASE 'O'
		AField := fld
		EXIT
	OTHERWISE
		RAISE ERROR "Unknown field reference..."
	END

RETURN AField

/*
	GetIndex
	Teo. Mexico 2009
*/
METHOD FUNCTION GetIndex( index ) CLASS TTable
	LOCAL AIndex

	SWITCH ValType( index )
	CASE 'U'
		AIndex := ::FIndex
		EXIT
	CASE 'C'
		IF Empty( index )
			AIndex := ::PrimaryIndex
		ELSE
			AIndex := ::IndexByName( index )
		ENDIF
		EXIT
	CASE 'O'
		IF index:IsDerivedFrom( "TIndex" )
			AIndex := index
			EXIT
		ENDIF
	OTHERWISE
		RAISE ERROR "Unknown index reference..."
	ENDSWITCH

RETURN AIndex

/*
	GetInstance
	Teo. Mexico 2008
*/
METHOD FUNCTION GetInstance CLASS TTable
//	 LOCAL instance

//	 IF ::FRDOClient != NIL //.AND. !HB_HHasKey( ::FInstances, ::TableClass )
//		 instance := ::SendToServer()
//		 RETURN instance
//	 ENDIF

RETURN ::FInstances[ ::TableClass ]

/*
	GetPrimaryIndex
	Teo. Mexico 2009
*/
METHOD FUNCTION GetPrimaryIndex( curClass ) CLASS TTable
	LOCAL className

	curClass := iif( curClass = NIL, Self, curClass )
	className := curClass:ClassName()

	IF ! className == "TTABLE"
		IF HB_HHasKey( ::FPrimaryIndexList, className )
			RETURN ::FIndexList[ className, ::FPrimaryIndexList[ className ] ]
		ENDIF
		RETURN ::GetPrimaryIndex( curClass:Super )
	ENDIF

RETURN NIL

/*
	GetPrimaryKeyField
	Teo. Mexico 2009
*/
METHOD FUNCTION GetPrimaryKeyField( masterSourceBaseClass ) CLASS TTable
	LOCAL pkField
	LOCAL AIndex

	IF !Empty( masterSourceBaseClass )
		pkField := ::IndexList[ masterSourceBaseClass, ::PrimaryIndexList[ masterSourceBaseClass ] ]:KeyField
	ELSE
		AIndex := ::PrimaryIndex
		IF AIndex != NIL
			pkField := AIndex:UniqueKeyField
		ENDIF
	ENDIF

RETURN pkField

/*
	GetPrimaryMasterKeyField
	Teo. Mexico 2009
*/
METHOD FUNCTION GetPrimaryMasterKeyField() CLASS TTable
	IF ::PrimaryIndex != NIL
		RETURN ::PrimaryIndex:MasterKeyField
	ENDIF
RETURN NIL

/*
	GetMasterSource
	Teo. Mexico 2009
*/
METHOD FUNCTION GetMasterSource() CLASS TTable
	
	SWITCH ::FMasterSourceType
	CASE rxMasterSourceTypeTTable
		RETURN ::FMasterSource
	CASE rxMasterSourceTypeTField
		IF ::Active .AND. ::FMasterSource:Table:Active
			RETURN ::FMasterSource:DataObj
		ENDIF
		RETURN ::FMasterSource:LinkedTable
	CASE rxMasterSourceTypeBlock
		RETURN ::FMasterSource:Eval()
	END

RETURN NIL

/*
	GetMasterSourceClassName
	Teo. Mexico 2008
*/
METHOD FUNCTION GetMasterSourceClassName( className ) CLASS TTable
	LOCAL Result := ""
	
	IF className = NIL
		className := ::ClassName
	ENDIF

	IF HB_HHasKey( ::DataBase:ChildParentList, className )
		Result := ::DataBase:ChildParentList[ className ]
		WHILE HB_HHasKey( ::DataBase:TableList, Result ) .AND. ::DataBase:TableList[ Result, "Virtual" ]
			IF !HB_HHasKey ( ::DataBase:ChildParentList, Result )
				EXIT
			ENDIF
			Result := ::DataBase:ChildParentList[ Result ]
		ENDDO
	ENDIF

RETURN Result

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

		IF ChildDB:DbGoTop()
			RETURN .T.
		ENDIF

	NEXT

RETURN .F.

/*
	IndexByName
	Teo. Mexico 2006
*/
METHOD FUNCTION IndexByName( indexName, curClass ) CLASS TTable
	LOCAL className
	
	curClass := iif( curClass = NIL, Self, curClass )
	className := curClass:ClassName()
	
	IF ! className == "TTABLE"
		IF HB_HHasKey( ::FIndexList, className )
			IF HB_HHasKey( ::FIndexList[ className ], indexName )
				RETURN ::FIndexList[ className, indexName ]
			ENDIF
		ENDIF
		RETURN ::IndexByName( indexName, curClass:Super )
	ENDIF

RETURN NIL

/*
	InitTable
	Teo. Mexico 2009
*/
METHOD PROCEDURE InitTable() CLASS TTable

	/*!
	* Make sure that database is open here
	*/
	IF ::FAlias == NIL
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
		::__DefineFields()
	ENDIF

	IF Empty( ::FIndexList )
		::__DefineIndexes()
	ENDIF

	IF ::FIndex = NIL
		::FIndex := ::PrimaryIndex
	ENDIF

RETURN

/*
	Insert
	Teo. Mexico 2006
*/
METHOD FUNCTION Insert() CLASS TTable

	IF !::State = dsBrowse
		::Error_TableNotInBrowseState()
		RETURN .F.
	ENDIF
	
	IF ::OnBeforeInsert() .AND. ::AddRec()

		/* To Flush !!! */
		::Alias:DbSkip( 0 )
		
		::OnAfterInsert()
	
		RETURN .T.

	ENDIF

RETURN .F.

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

/*
	InsideScope
	Teo. Mexico 2008
*/
METHOD FUNCTION InsideScope() CLASS TTable
	LOCAL primaryIndex := ::PrimaryIndex

	IF ::Eof() .OR. ::Bof()
		RETURN .F.
	ENDIF

	IF !primaryIndex == NIL .AND. !primaryIndex:InsideScope()
		RETURN .F.
	ENDIF

RETURN primaryIndex == ::Index .OR. ::Index:InsideScope()

/*
	Open
	Teo. Mexico 2008
*/
METHOD FUNCTION Open() CLASS TTable
	LOCAL masterSource := ::GetMasterSourceClassName()

	IF ::MasterSource == NIL .AND. !Empty( masterSource )

		RAISE ERROR "Table '" + ::ClassName() + "' needs a MasterSource of type '" + masterSource  + "'..."
	
	ENDIF

	::FActive := .T.

	/*
	 * Try to sync with MasterSource (if any)
	 */
	::SyncFromMasterSourceFields()
	
	::FHasDeletedOrder := ::Alias:OrdNumber( "Deleted" ) > 0

	::SetState( dsBrowse )

	::OnAfterOpen()

RETURN .T.

/*
	Post
	Teo. Mexico 2006
*/
METHOD FUNCTION Post() CLASS TTable
	LOCAL AField
	LOCAL errObj
	LOCAL itm
	LOCAL result := .F.

	IF AScan( { dsEdit, dsInsert }, ::State ) = 0
		::Error_Table_Not_In_Edit_or_Insert_mode()
	ENDIF

	BEGIN SEQUENCE WITH {|oErr| Break( oErr ) }

		::FSubState := dssPosting

		IF ::OnBeforePost()

			IF Len( ::DetailSourceList ) > 0
				FOR EACH itm IN ::DetailSourceList
					IF AScan( { dsEdit, dsInsert }, itm:State ) > 0
						itm:Post()
					ENDIF
				NEXT
			ENDIF

			FOR EACH AField IN ::FieldList

				IF !AField:IsValid()
					RAISE ERROR "Post: Invalid data on Field: <" + ::ClassName + ":" + AField:Name + ">"
				ENDIF

				IF AField:FieldMethodType = "C"
					AField:SetData()
				ENDIF

			NEXT

			::RecUnLock()

			result := .T.

		ENDIF

	RECOVER USING errObj
	
		::Cancel()

		SHOW ERROR errObj

#ifndef __XHARBOUR__
	ALWAYS

		::FSubState := dssNone
#endif
	END SEQUENCE

	IF result
		::OnAfterPost()
	ENDIF

RETURN result

/*
	Process_TableName
	Teo. Mexico 2008
*/
METHOD PROCEDURE Process_TableName( tableName ) CLASS TTable
	LOCAL s, sHostPort

	IF tableName == NIL
		tableName := ::TableNameValue
	ELSE
		::TableNameValue := tableName
	ENDIF

	IF Empty( tableName )
		::Error_Empty_TableName()
	ENDIF

	/*
		Process tableName to check if we need a RDOClient to an RDOServer
	*/
	IF Upper( tableName ) = "RDO://"

		s := HB_TokenGet( ::TableName, 2, "://" )
		sHostPort := HB_TokenGet( s, 1, "/" )
		::FTableFileName := SubStr( s, At( "/", s ) + 1 )

		::FAddress := HB_TokenGet( sHostPort, 1, ":" )
		::FPort := HB_TokenGet( sHostPort, 2, ":" )

		/*
			Checks if RDO Client is required
		*/
		::FRDOClient := TRDOClient():New( ::FAddress, ::FPort )
		IF !::FRDOClient:Connect()
			::Error_ConnectToServer_Failed()
			RETURN
		ENDIF

	ELSE

		::FTableFileName := ::TableName

	ENDIF

RETURN

/*
	RawGet4Seek
	Teo. Mexico 2009
*/
METHOD FUNCTION RawGet4Seek( direction, xField, keyVal, index, softSeek ) CLASS TTable
	LOCAL AIndex := ::GetIndex( index )

RETURN AIndex:RawGet4Seek( direction, ::GetField( xField ):FieldReadBlock, keyVal, softSeek )

/*
	RawSeek
	Teo. Mexico 2008
*/
METHOD FUNCTION RawSeek( Value, index ) CLASS TTable
RETURN ::GetIndex( index ):RawSeek( Value )

/*
	RecLock
	Teo. Mexico 2006
*/
METHOD FUNCTION RecLock CLASS TTable

	IF ::FState != dsBrowse
		::Error_Table_Not_In_Browse_Mode()
		RETURN .F.
	ENDIF
	
	IF ::FReadOnly
		wxhAlert( "Table '" + ::ClassName() + "' is marked as READONLY...")
		RETURN .F.
	ENDIF

	IF ::Eof()
		RAISE ERROR "Attempt to lock record at EOF..."
	ENDIF

	IF !::InsideScope .OR. !::Alias:RecLock()
		RETURN .F.
	ENDIF

	IF ::GetCurrentRecord()
		::SetState( dsEdit )
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
		::SetState( dsBrowse )
		::OnDataChange()
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
METHOD PROCEDURE Reset() CLASS TTable
	LOCAL AField

	::FRecNo := 0
	
	::FUnderReset := .T.

	FOR EACH AField IN ::FFieldList

		IF AField:FieldMethodType = "C" .AND. !AField:Calculated
			AField:Reset()
		ENDIF

	NEXT
	
	::FUnderReset := .F.

RETURN

/*
	SetIndexName
	Teo. Mexico 2007
*/
METHOD PROCEDURE SetIndexName( indexName ) CLASS TTable
	LOCAL index

	IF !Empty( indexName )
	
		index := ::IndexByName( indexName )
	
		IF index != NIL
			::FIndex := index
			RETURN
		ENDIF

		RAISE ERROR	 "<" + ::ClassName + ">: Index name '" + indexName + "' doesn't exist..."

	ENDIF

RETURN

/*
	SetMasterSource
	Teo. Mexico 2007
*/
METHOD PROCEDURE SetMasterSource( masterSource ) CLASS TTable

	IF ::FMasterSource == masterSource
		RETURN
	ENDIF

	::FMasterSource := masterSource
	
	SWITCH ValType( masterSource )
	CASE 'O'
		IF masterSource:IsDerivedFrom( "TTable" )
			::FMasterSourceType := rxMasterSourceTypeTTable
		ELSEIF masterSource:IsDerivedFrom( "TObjectField" )
			::FMasterSourceType := rxMasterSourceTypeTField
		ELSEIF masterSource:IsDerivedFrom( "TField" )
			RAISE ERROR "need to specify TField generic syncing..."
		ELSE
			RAISE ERROR "Invalid object in assigning MasterSource..."
		ENDIF
		EXIT
	CASE 'B'
		::FMasterSourceType := rxMasterSourceTypeBlock
		EXIT
	CASE 'U'
		::FMasterSourceType := rxMasterSourceTypeNone
		RETURN
	_OTHERWISE
		RAISE ERROR "Invalid type in assigning MasterSource..."
	END

	::MasterSourceBaseClass := ::GetMasterSourceClassName()

	/*!
	 * Check for a valid GetMasterSourceClassName (if any)
	 */
	IF !Empty( ::MasterSourceBaseClass )
		//IF !::MasterSource:IsDerivedFrom( ::GetMasterSourceClassName ) .AND. !::DataBase:TableIsChildOf( ::GetMasterSourceClassName, ::MasterSource:ClassName )
		//IF ! Upper( ::GetMasterSourceClassName ) == ::MasterSource:ClassName
		IF ! ::MasterSource:IsDerivedFrom( ::MasterSourceBaseClass )
			RAISE ERROR "Table <" + ::TableClass + "> Invalid MasterSource Class Name: " + ::MasterSource:ClassName + ";Expected class type: <" + ::MasterSourceBaseClass + ">"
		ENDIF
	ELSE
		RAISE ERROR "Table '" + ::ClassName() + "' has not declared the MasterSource '" + ::MasterSource:ClassName() + "' in the DataBase structure..."
	ENDIF

	/*
	 * Check if another Self is already in the MasterSource DetailSourceList
	 * and RAISE ERROR if another Self is trying to break the previous link
	 */
	IF HB_HHasKey( ::MasterSource:DetailSourceList, Self:ObjectH )
		RAISE ERROR "Cannot re-assign DetailSourceList:<" + ::ClassName +">"
	ENDIF

	::MasterSource:DetailSourceList[ Self:ObjectH ] := Self

	::SyncFromMasterSourceFields()

RETURN

/*
	SetReadOnly
	Teo. Mexico 2009
*/
METHOD PROCEDURE SetReadOnly( readOnly ) CLASS TTable
	IF ! HB_IsLogical( readOnly )
		RAISE ERROR "Invalid value on SetReadOnly..."
	ENDIF
	IF ::FState = dsBrowse
		::FReadOnly := readOnly
	ENDIF
RETURN

/*
	SetState
	Teo. Mexico 2009
*/
METHOD PROCEDURE SetState( state ) CLASS TTable
	LOCAL oldState

	oldState := ::FState
	::FState := state
	::OnStateChange( oldState )

RETURN

/*
	SkipBrowse : BROWSE skipblock
	Teo. Mexico 2008
*/
METHOD FUNCTION SkipBrowse( n ) CLASS TTable
	LOCAL num_skipped := 0
	LOCAL recNo

	IF n = 0
		::DbSkip( 0 )
		RETURN 0
	ENDIF

	IF n > 0
		WHILE !::Eof() .AND. num_skipped < n
			recNo := ::RecNo
			::DbSkip( 1 )
			IF ::Eof()
				::RecNo := recNo
				EXIT
			ENDIF
			num_skipped++
		ENDDO
	ELSE
		WHILE !::Bof() .AND. num_skipped > n
			recNo := ::RecNo
			::DbSkip( -1 )
			IF ::Bof()
				::RecNo := recNo
				EXIT
			ENDIF
			num_skipped--
		ENDDO
	ENDIF

RETURN num_skipped

/*
	SyncDetailSources
	Teo. Mexico 2007
*/
METHOD PROCEDURE SyncDetailSources CLASS TTable
	LOCAL itm

	IF !Empty( ::DetailSourceList )
		FOR EACH itm IN ::DetailSourceList
			itm:SyncFromMasterSourceFields()
		NEXT
	ENDIF

RETURN

/*
	SyncFromMasterSourceFields
	Teo. Mexico 2007
*/
METHOD PROCEDURE SyncFromMasterSourceFields() CLASS TTable

	IF ::MasterSource != NIL .AND. ::FActive .AND. ::MasterSource:Active
		/* TField:Reset does the job */
		IF ::PrimaryMasterKeyField != NIL
			::PrimaryMasterKeyField:Reset()
		ENDIF

		IF ::InsideScope()
			::GetCurrentRecord()
		ELSE
			::DbGoTop()
		ENDIF

	ENDIF
	
RETURN

 /*
	SyncRecNo
	Teo. Mexico 2007
*/
METHOD PROCEDURE SyncRecNo( fromAlias ) CLASS TTable
	IF fromAlias == .T.
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
	Validate
	Teo. Mexico 2009
*/
METHOD FUNCTION Validate( showAlert ) CLASS TTable
	LOCAL AField

	FOR EACH AField IN ::FFieldList
		IF !AField:IsValid( showAlert )
			RETURN .F.
		ENDIF
	NEXT

RETURN .T.

/*
	End Class TTable
*/
