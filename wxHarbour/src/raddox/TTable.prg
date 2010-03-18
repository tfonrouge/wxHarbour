/*
 * $Id$
 */

/*
	TTable
	Teo. Mexico 2007
*/

#include "wxharbour.ch"
#include "error.ch"
#include "xerror.ch"

#include "dbinfo.ch"

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
	DATA FRemote				INIT .F.
	DATA FState INIT dsInactive
	DATA FSubState INIT dssNone
	DATA FSyncingToContainerField INIT .F.
	DATA FTableFileName
	DATA FTimer INIT 0
	DATA FUndoList

	METHOD DbGoBottomTop( n )
	METHOD GetAlias
	METHOD GetDbStruct
	METHOD GetFieldTypes
	METHOD GetFound INLINE ::Alias:Found
	METHOD GetIndexName INLINE iif( ::FIndex = NIL, NIL, ::FIndex:Name )
	METHOD GetInstance
	METHOD GetMasterSource()
	METHOD GetPrimaryMasterKeyField()
	METHOD GetPrimaryMasterKeyString INLINE iif( ::GetPrimaryMasterKeyField == NIL, "", ::GetPrimaryMasterKeyField:AsString )
	METHOD GetPublishedFieldList
	METHOD GetTableName INLINE ::TableNameValue
	METHOD SetIndex( index )
	METHOD SetIndexName( IndexName )
	METHOD SetMasterSource( masterSource )
	METHOD SetReadOnly( readOnly )
	METHOD SetState( state )
	METHOD SetSyncingToContainerField( value ) INLINE ::FSyncingToContainerField := value
	METHOD Process_TableName( tableName )
	METHOD SendToServer

PROTECTED:

	DATA FBaseClass
	DATA FBof				INIT .T.
	DATA FEof				INIT .T.
	DATA FFieldList
	DATA FFilter
	DATA FIndexList			INIT HB_HSetCaseMatch( {=>}, .F. )  // <className> => <indexName> => <indexObject>
	DATA FFound				INIT .F.
	DATA FPrimaryIndexList	INIT HB_HSetCaseMatch( {=>}, .F. )  // <className> => <indexName>
	DATA FRecNo				INIT 0
	DATA TableNameValue INIT "" // to be assigned (INIT) on inherited classes
	DATA tableState INIT {}
	DATA tableStateLen INIT 0

	METHOD AddRec()
	METHOD CheckDbStruct()
	METHOD DefineFieldsFromDb()
	METHOD FillPrimaryIndexes( curClass )
	METHOD FindDetailSourceField( masterField )
	METHOD FixDbStruct( aNewStruct, message )
	METHOD InitDataBase INLINE TDataBase():New()
	METHOD InitTable()
	METHOD RawGet4Seek( direction, xField, keyVal, index, softSeek )

PUBLIC:

	CLASSDATA DataBase

	DATA aliasIdx
	DATA aliasTmp
	DATA allowOnDataChange INIT .T.
	DATA autoEdit INIT .F.
	DATA autoMasterSource INIT .F.
	DATA autoOpen INIT .T.
	DATA dataIsOEM	INIT .T.
	/*!
		array of possible TObjectField's that have this (SELF) object referenced
	 */
	DATA DetailSourceList INIT {=>}
	DATA ExternalIndexList INIT {=>}
	DATA FieldNamePrefix	INIT "Field_"		// Table Field Name prefix
	DATA FUnderReset INIT .F.
	DATA fullFileName
	DATA LinkedObjField
	
	DATA OnDataChangeBlock
	
	DATA validateDbStruct INIT .T.		// On Open, Check for a valid struct dbf (against DEFINE FIELDS )

	CONSTRUCTOR New( MasterSource, tableName )
	DESTRUCTOR OnDestruct()

	METHOD __DefineFields() VIRTUAL // DEFINE FIELDS
	METHOD __DefineIndexes() VIRTUAL // DEFINE INDEXES

	METHOD BaseSeek( direction, Value, index, lSoftSeek )
	METHOD AddFieldAlias( nameAlias, fld )
	METHOD AddFieldMessage( messageName, AField )
	METHOD AssociateTableIndex( table, name, getRecNo, setRecNo )
	METHOD Cancel
	METHOD ChildSource( tableName )
	METHOD CopyRecord( origin )
	METHOD Count( bForCondition, bWhileCondition, index, scope )
	METHOD CreateIndex( index )
	METHOD DefineMasterDetailFields			VIRTUAL
	METHOD DefineRelations							VIRTUAL
	METHOD Destroy()
	METHOD DbEval( bBlock, bForCondition, bWhileCondition, index, scope )
	METHOD DbGoBottom INLINE ::DbGoBottomTop( -1 )
	METHOD DbGoTo( RecNo )
	METHOD DbGoTop INLINE ::DbGoBottomTop( 1 )
	METHOD DbSetFilter( filter ) INLINE ::FFilter := filter
	METHOD DbSkip( numRecs )
	METHOD Delete( lDeleteChilds )
	METHOD DeleteChilds
	METHOD Edit()
	METHOD FieldByName( name, index )
	METHOD FilterEval( index )
	METHOD FindIndex( index )
	METHOD FindMasterSourceField( detailField )
	METHOD FindTable( table )
	METHOD Get4Seek( xField, keyVal, index, softSeek ) INLINE ::RawGet4Seek( 1, xField, keyVal, index, softSeek )
	METHOD Get4SeekLast( xField, keyVal, index, softSeek ) INLINE ::RawGet4Seek( 0, xField, keyVal, index, softSeek )
	METHOD GetAsString
	METHOD GetAsVariant
	METHOD GetCurrentRecord( idxAlias )
	METHOD GetDisplayFieldBlock( xField )
	METHOD GetDisplayFields( syncFromAlias )
	METHOD GetField( fld )
	METHOD GetKeyVal() INLINE ::PrimaryIndex:GetKeyVal()
	METHOD GetMasterSourceClassName( className )
	METHOD GetPrimaryIndex( curClass, masterSourceBaseClass )
	METHOD GetPrimaryKeyField( masterSourceBaseClass )
	METHOD HasChilds
	METHOD IndexByName( IndexName, curClass )
	METHOD Insert()
	METHOD InsertRecord( origin )
	METHOD InsideScope()
	METHOD Open
	METHOD OrdCondSet( ... )
	METHOD OrdCreate( ... )
	METHOD OrdKeyNo() INLINE ::Index:OrdKeyNo()
	METHOD Post()
	METHOD RawSeek( Value, index )
	METHOD RecLock
	METHOD RecUnLock
	METHOD Refresh
	METHOD Reset()								// Set Field Record to their default values, Sync MasterKeyVal Value
	METHOD Seek( Value, AIndex, SoftSeek ) INLINE ::BaseSeek( 0, Value, AIndex, SoftSeek )
	METHOD SeekLast( Value, AIndex, SoftSeek ) INLINE ::BaseSeek( 1, Value, AIndex, SoftSeek )
	METHOD SetAsString( Value ) INLINE ::GetPrimaryKeyField():AsString := Value
	METHOD SetAsVariant( Value ) INLINE ::GetPrimaryKeyField():Value := Value
	METHOD SetKeyVal( keyVal )
	/*
	 * TODO: Enhance this to:
	 *			 <order> can be "fieldname" or "fieldname1;fieldname2"
	 *			 able to create a live index
	 */
	METHOD SetOrderBy( order ) INLINE ::FIndex := ::FieldByName( order ):KeyIndex
	METHOD SkipBrowse( n )
	METHOD SkipFilter( n, index )
	METHOD StatePop()
	METHOD StatePush()
	METHOD SyncDetailSources
	METHOD SyncFromMasterSourceFields()
	METHOD SyncRecNo( fromAlias )
	METHOD TableClass INLINE ::ClassName + "@" + ::TableName

	METHOD Validate( showAlert )

	METHOD OnClassInitializing() VIRTUAL
	METHOD OnCreate() VIRTUAL
	METHOD OnAfterCancel() VIRTUAL
	METHOD OnAfterDelete() VIRTUAL
	METHOD OnAfterInsert() VIRTUAL
	METHOD OnAfterOpen() VIRTUAL
	METHOD OnAfterPost VIRTUAL
	METHOD OnBeforeInsert() INLINE .T.
	METHOD OnBeforePost() INLINE .T.
	METHOD OnDataChange()
	METHOD OnPickList( param ) VIRTUAL
	METHOD OnStateChange( state ) VIRTUAL

	PROPERTY Active READ FActive
	PROPERTY Alias READ GetAlias
	PROPERTY AsString READ GetAsString WRITE SetAsString
	PROPERTY BaseClass READ FBaseClass
	PROPERTY Bof READ FBof
	PROPERTY DbStruct READ GetDbStruct
	PROPERTY Deleted READ Alias:Deleted()
	PROPERTY DisplayFields READ GetDisplayFields
	PROPERTY Eof READ FEof
	PROPERTY FieldList READ FFieldList
	PROPERTY Found READ FFound
	PROPERTY FieldTypes READ GetFieldTypes
	PROPERTY Filter READ FFilter
	PROPERTY Instance READ GetInstance
	PROPERTY Instances READ FInstances
	PROPERTY KeyVal READ GetKeyVal WRITE SetKeyVal
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
	LOCAL ms
	
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
	
	IF masterSource = NIL .AND. !Empty( ms := ::GetMasterSourceClassName() ) .AND. ::autoMasterSource
		masterSource := __ClsInstName( ms )
		masterSource:autoMasterSource := .T.
		masterSource:New()
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
	IF ::validateDbStruct .AND. !HB_HHasKey( ::FInstances[ ::TableClass ], "DbStructValidated" )
		::CheckDbStruct()
	ENDIF

	IF ::autoOpen
		::Open()
	ENDIF
	
RETURN Self

/*
	AddFieldAlias
	Teo. Mexico 2010
*/
METHOD PROCEDURE AddFieldAlias( nameAlias, fld ) CLASS TTable
	LOCAL AField

	SWITCH ValType( fld )
	CASE 'C'
		AField := ::FieldByName( fld )
		EXIT
	CASE 'O'
		IF fld:IsDerivedFrom("TField")
			AField := fld
			EXIT
		ENDIF
	ENDSWITCH

	IF AField != NIL
		IF AField:nameAlias != NIL
			RAISE ERROR "Alias Field Name '" + nameAlias + "' attempt to re-declare alias name on Field"
		ENDIF
		::AddFieldMessage( nameAlias, AField )
		AField:nameAlias := nameAlias
	ELSE
		RAISE ERROR "Alias Field Name '" + nameAlias + "' not valid Field from"
	ENDIF

RETURN

/*
	AddFieldMessage
	Teo. Mexico 2006
*/
METHOD PROCEDURE AddFieldMessage( messageName, AField ) CLASS TTable
	LOCAL index
	LOCAL fld
	
	fld := ::FieldByName( messageName, @index )
	
	IF index = 0
		AAdd( ::FFieldList, AField )
		index := Len( ::FFieldList )
	ELSE
		IF AField:TableBaseClass == fld:TableBaseClass
			RAISE ERROR "Attempt to Re-Declare Field '" + messageName + "' on Class <" + ::ClassName + ">"
		ENDIF
		::FFieldList[ index ] := AField
	ENDIF

	/* Check if Name is already created in class */
	IF !__ObjHasMsg( Self, ::FieldNamePrefix + messageName )
		EXTEND OBJECT Self WITH MESSAGE ::FieldNamePrefix + messageName INLINE ::FieldList[ index ]
	ENDIF

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
	AssociateTableIndex
	Teo. Mexico 2010
*/
METHOD PROCEDURE AssociateTableIndex( table, name, getRecNo, setRecNo ) CLASS TTable
	LOCAL index

	IF !HB_HHasKey( ::IndexList, ::ClassName() )
		::IndexList[ ::ClassName() ] := HB_HSetCaseMatch( {=>}, .F. )
	ENDIF
	
	index := table:IndexByName( name )
	index:associatedTable := Self
	
	index:getRecNo := getRecNo
	index:setRecNo := setRecNo

	::IndexList[ ::ClassName(), name ] := index
	
	::ExternalIndexList[ index:ObjectH ] := index

RETURN

/*
	BaseSeek
	Teo. Mexico 2007
*/
METHOD FUNCTION BaseSeek( direction, Value, index, lSoftSeek ) CLASS TTable
	LOCAL AIndex
	
	AIndex := ::FindIndex( index )

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
	OTHERWISE

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
	LOCAL aDb := AClone( ::DbStruct() )
	LOCAL sResult := ""
	
	FOR EACH AField IN ::FieldList
		IF AField:FieldMethodType = "C" .AND. !AField:Calculated

			n := AScan( aDb, {|e| Upper( e[1] ) == Upper( AField:DBS_NAME ) } )
			
			IF AField:IsDerivedFrom("TObjectField")
				pkField := AField:GetReferenceField()
				IF pkField = NIL
					RAISE ERROR "Cannot find data field for TObjectField '" + AField:Name + "'" + " in Database '" + ::ClassName + "'"
				ENDIF
			ELSE
				pkField := AField
			ENDIF
			
			IF n = 0
				AAdd( aDb, { pkField:DBS_NAME, pkField:DBS_TYPE, pkField:DBS_LEN, pkField:DBS_DEC } )
				sResult += "Field not found '" + pkField:DBS_NAME + E"'\n"
			ELSEIF !aDb[ n, 2 ] == pkField:DBS_TYPE
				sResult += "Wrong type ('" + aDb[ n, 2 ] + "') on field '" + pkField:DBS_NAME +"', must be '" + pkField:DBS_TYPE + E"'\n"
				aDb[ n, 2 ] := pkField:DBS_TYPE
				aDb[ n, 3 ] := pkField:DBS_LEN
				aDb[ n, 4 ] := pkField:DBS_DEC
			ELSEIF aDb[ n, 2 ] = "C" .AND. aDb[ n, 3 ] < pkField:DBS_LEN
				sResult += "Wrong len value (" + NTrim( aDb[ n, 3 ] ) + ") on 'C' field '" + pkField:DBS_NAME + E"', must be " + NTrim( pkField:DBS_LEN ) + E"\n"
				aDb[ n, 3 ] := pkField:DBS_LEN
			ELSEIF aDb[ n, 2 ] = "N" .AND. ( !aDb[ n, 3 ] == pkField:DBS_LEN .OR. !aDb[ n, 4 ] == pkField:DBS_DEC )
				sResult += "Wrong len/dec values (" + NTrim( aDb[ n, 3 ] ) + "," + NTrim( aDb[ n, 4 ] ) + ") on 'N' field '" + pkField:DBS_NAME + E"', must be " + NTrim( pkField:DBS_LEN ) + "," + NTrim( pkField:DBS_DEC ) + E"\n"
				aDb[ n, 3 ] := pkField:DBS_LEN
				aDb[ n, 4 ] := pkField:DBS_DEC
			ENDIF

		ENDIF
	NEXT
	
	IF ! Empty( sResult )
		sResult := "Error on Db structure." + ;
					E"\nClass: " + ::ClassName() + ", Database: " + ::Alias:Name + ;
					E"\n\n-----\n" + ;
					sResult + ;
					E"-----\n\n"
		? sResult
		RETURN ::FixDbStruct( aDb, sResult )
	ENDIF

	::FInstances[ ::TableClass, "DbStructValidated" ] := .T.

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
	OTHERWISE
		RAISE ERROR "Unknown Record from Origin"
		RETURN .F.
	END

RETURN .T.

/*
	Count : number of records
	Teo. Mexico 2008
*/
METHOD FUNCTION Count( bForCondition, bWhileCondition, index, scope ) CLASS TTable
	LOCAL nCount := 0
	
	::DbEval( {|| ++nCount }, bForCondition, bWhileCondition, index, scope )

RETURN nCount

/*
	CreateIndex
	Teo. Mexico 2010
*/
METHOD FUNCTION CreateIndex( index ) CLASS TTable
	LOCAL fileName
	LOCAL pathName
	LOCAL aliasName
	LOCAL dbsIdx
	LOCAL size
	LOCAL fldName
	LOCAL lNew := .F.
	
	fldName := index:Name

	IF !index:temporary

		HB_FNameSplit( ::Alias:DbOrderInfo( DBOI_FULLPATH ), @pathName )

		pathName += Lower( ::ClassName )

		fileName := pathName + ".dbf"

		aliasName := "IDX_" + ::ClassName()

		IF File( fileName )
	
			index:IdxAlias := TAlias()
			index:IdxAlias:lShared := .F.
			index:IdxAlias:New( fileName, aliasName )
			
		ENDIF

	ENDIF

	IF index:IdxAlias = NIL

		IF index:temporary

			FClose( HB_FTempCreateEx( @fileName, NIL, NIL, ".dbf" ) )

			aliasName := "TMP_" + ::ClassName()

		ENDIF

		size := 0

		IF index:MasterKeyField != NIL
			size += index:MasterKeyField:Size
		ENDIF

		IF index:KeyField != NIL
			size += index:KeyField:Size
		ENDIF

		dbsIdx := ;
		{ ;
			{ "RECNO", "I", 4, 0 },;
			{ fldName, "C", size, 0 } ;
		}

		DbCreate( fileName, dbsIdx )

		index:IdxAlias := TAlias()
		index:IdxAlias:lShared := .F.
		index:IdxAlias:New( fileName, aliasName )

		CREATE INDEX ON "RecNo" TAG "IDX_RECNO" BAG pathName ADDITIVE

		CREATE INDEX ON fldName TAG index:Name BAG pathName ADDITIVE
		
		lNew := .T.

	ENDIF

	IF index:temporary

		index:IdxAlias:__DbZap()
		
	ENDIF

	IF index:temporary .OR. lNew
		::DbEval( ;
			{|Self|
				index:IdxAlias:AddRec()
				index:IdxAlias:SetFieldValue( "RECNO", ::RecNo() )
				index:IdxAlias:SetFieldValue( fldName, index:MasterKeyVal + index:KeyVal )
				RETURN NIL
			}, NIL, NIL, index:useIndex )
	ENDIF

	index:FIdxAlias := .T.

RETURN .T.

/*
	DbEval
	Teo. Mexico 2008
*/
METHOD PROCEDURE DbEval( bBlock, bForCondition, bWhileCondition, index, scope ) CLASS TTable
	LOCAL oldIndex
	LOCAL oldScope

	::StatePush()

	IF index != NIL
		oldIndex := ::IndexName
		index := ::FindIndex( index )
		IF index != NIL
			::IndexName := index:Name
		ENDIF
	ENDIF
	
	IF scope != NIL
		oldScope := ::Index:Scope
		::Index:Scope := scope
	ENDIF

	::DbGoTop()

	WHILE !::Eof() .AND. ( bWhileCondition == NIL .OR. bWhileCondition:Eval( Self ) )

		IF bForCondition == NIL .OR. bForCondition:Eval( Self )
			bBlock:Eval( Self )
		ENDIF

		::DbSkip()

	ENDDO
	
	IF oldScope != NIL
		::Index:Scope := oldScope
	ENDIF
	
	IF oldIndex != NIL
		::IndexName := oldIndex
	ENDIF
	
	::StatePop()
	
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
		IF n = 1
			RETURN ::FIndex:DbGoTop()
		ELSE
			RETURN ::FIndex:DbGoBottom()
		ENDIF
	ELSE
		IF n = 1
			::Alias:DbGoTop()
		ELSE
			::Alias:DbGoBottom()
		ENDIF
		::GetCurrentRecord()
		IF ::FFilter != NIL .AND. !::FFilter:Eval( Self )
			::SkipFilter( n )
		ENDIF
	ENDIF

RETURN .F.

/*
	DbGoTo
	Teo. Mexico 2007
*/
METHOD FUNCTION DbGoTo( RecNo ) CLASS TTable
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
		IF ::FFilter = NIL
			::Alias:DbSkip( numRecs )
			::GetCurrentRecord()
		ELSE
			::SkipFilter( numRecs )
		ENDIF
	ENDIF

RETURN

/*
	FIELDS END
	Teo. Mexico 2010
*/
METHOD PROCEDURE DefineFieldsFromDb() CLASS TTable
	LOCAL dbStruct
	LOCAL fld
	LOCAL AField

	IF Empty( ::FFieldList ) .AND. !Empty( dbStruct := ::GetDbStruct() )

		FOR EACH fld IN dbStruct

			AField := __ClsInstFromName( ::FieldTypes[ fld[ 2 ] ] ):New( Self )

			AField:FieldMethod := fld[ 1 ]
			AField:AddFieldMessage()

		NEXT

	ENDIF

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
METHOD FUNCTION FieldByName( name, index ) CLASS TTable
	LOCAL AField

	index := 0

	IF Empty( name )
		RETURN NIL
	ENDIF

	name := Upper( name )

	FOR EACH AField IN ::FFieldList
		IF name == Upper( AField:Name ) .OR. ( AField:nameAlias != NIL .AND. name == Upper( AField:nameAlias ) )
			index := AField:__enumIndex
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
	FilterEval
	Teo. Mexico 2010
*/
METHOD FUNCTION FilterEval( index ) CLASS TTable
	LOCAL table
	
	IF index != NIL .AND. index:associatedTable != NIL
		table := index:associatedTable
	ELSE
		table := Self
	ENDIF

RETURN ( index = NIL .OR. index:Filter = NIL .OR. index:Filter:Eval( table ) ) .AND. ( table:Filter = NIL .OR. table:Filter:Eval( table ) )

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
	FindIndex
	Teo. Mexico 2010
*/
METHOD FUNCTION FindIndex( index ) CLASS TTable
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
	FixDbStruct
	Teo. Mexico 2010
*/
METHOD FUNCTION FixDbStruct( aNewStruct, message ) CLASS TTable
	LOCAL fileName
	LOCAL tempName
	LOCAL sPath,sName,sExt,sDrv
	LOCAL sPath2,sName2,sExt2,sDrv2
	LOCAL result
	
	IF message = NIL
		message := ""
	ENDIF
	
	IF wxhAlertYesNo( message + "Proceed to update Db Structure ?" ) = 1
	
		fileName := ::fullFileName
		
		HB_FNameSplit( fileName, @sPath, @sName, @sExt, @sDrv )

		::Alias:DbCloseAll()
		
		HB_FTempCreateEx( @tempName, sPath, "tmp", ".dbf" )
		
		DBCreate( tempName, aNewStruct )
		
		USE ( tempName ) NEW
		
		BEGIN SEQUENCE WITH ;
			{|oErr| 
				
				IF oErr:GenCode = EG_DATATYPE
					RETURN .F.
				ENDIF

				IF .T.
					Break( oErr )
				ENDIF

				RETURN NIL
			}

			APPEND FROM ( fileName )
			
			CLOSE ( Alias() )
			
			FRename( HB_FNameMerge( sPath, sName, sExt, sDrv ), HB_FNameMerge( sPath, "_" + sName, sExt, sDrv ) )

			FRename( HB_FNameMerge( sPath, sName, ".fpt", sDrv ), HB_FNameMerge( sPath, "_" + sName, ".fpt", sDrv ) )
			
			HB_FNameSplit( tempName, @sPath2, @sName2, @sExt2, @sDrv2 )

			FRename( HB_FNameMerge( sPath2, sName2, sExt2, sDrv2 ), HB_FNameMerge( sPath, sName, sExt, sDrv ) )

			FRename( HB_FNameMerge( sPath2, sName2, ".fpt", sDrv2 ), HB_FNameMerge( sPath, sName, ".fpt", sDrv ) )
			
			result := ::Alias:DbOpen()
			
		RECOVER

			result := .F.
			
		END SEQUENCE
		
	ELSE
		::CancelAtFixDbStruct()
		result := .F.
	ENDIF
	
RETURN result

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
METHOD FUNCTION GetAsString() CLASS TTable
	LOCAL pkField := ::GetPrimaryKeyField()

	IF pkField == NIL
		RETURN ""
	ENDIF

RETURN pkField:AsString

/*
	GetAsVariant
	Teo. Mexico 2009
*/
METHOD FUNCTION GetAsVariant() CLASS TTable
	LOCAL pkField := ::GetPrimaryKeyField()

	IF pkField == NIL
		RETURN NIL
	ENDIF

RETURN pkField:Value

/*
	GetCurrentRecord
	Teo. Mexico 2010
*/
METHOD FUNCTION GetCurrentRecord( idxAlias ) CLASS TTable
	LOCAL AField
	LOCAL Result
	LOCAL index
	LOCAL read

	IF idxAlias = NIL
		IF ::aliasIdx != NIL
			::aliasIdx:Seek( ::Alias:RecNo, "IDX_RECNO" )
		ENDIF
		IF ::aliasTmp != NIL
			::aliasTmp:Seek( ::Alias:RecNo, "IDX_RECNO" )
		ENDIF
		::FBof   := ::Alias:Bof()
		::FEof   := ::Alias:Eof()
		::FFound := ::Alias:Found()
	ELSE
		::Alias:DbGoTo( (idxAlias:workArea)->RecNo )
		::FBof   := idxAlias:Bof()
		::FEof   := idxAlias:Eof()
		::FFound := idxAlias:Found()
		IF ::aliasIdx != NIL .AND. ::aliasTmp != NIL
			IF idxAlias == ::aliasIdx
				::aliasTmp:Seek( ::Alias:RecNo, "IDX_RECNO" )
			ELSE
				::aliasIdx:Seek( ::Alias:RecNo, "IDX_RECNO" )
			ENDIF
		ENDIF
	ENDIF

	IF ::FIndex != NIL .AND. HB_HHasKey( ::ExternalIndexList, ::FIndex:ObjectH )
		index := ::FIndex ; ::FIndex := NIL
		::GetCurrentRecord( idxAlias )
		index:setRecNo:Eval( Self, index:Table)
		::FIndex := index
		read := .T.
	ENDIF

	::FRecNo := ::Alias:RecNo

	IF ::FState = dsBrowse

		IF ( Result := ::InsideScope() )

			IF !read == .T.

				FOR EACH AField IN ::FFieldList

					IF AField:FieldMethodType = "C" .AND. !AField:Calculated .AND. !AField:IsMasterFieldComponent
						AField:GetData()
					ENDIF

				NEXT

			ENDIF

		ELSE
			::FEof := .T.
			::FBof := .T.
			::FFound := .F.
			::Reset()
		ENDIF

		::SyncDetailSources()

		IF Result .AND. ::allowOnDataChange
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
			{|o,...|
				LOCAL odf
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
				
				odf := o

				WHILE odf:__FObj:LinkedObjField != NIL
					odf := odf:__FObj:LinkedObjField:Table:GetDisplayFields()
					odf:__FLastLabel := AField:Label
				ENDDO

				IF o:__FObj:Eof() .OR. o:__FObj:Bof()
					RETURN AField:EmptyValue
				ENDIF
				
				RETURN AField:GetAsVariant( ... )

			}

	ENDIF

	RETURN ;
		{|o|
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

			RETURN AField:DataObj:GetDisplayFields( NIL )

		}

METHOD FUNCTION GetDisplayFields( syncFromAlias ) CLASS TTable
	LOCAL DisplayFieldsClass
	LOCAL msgName
	LOCAL AField

	IF ::FDisplayFields == NIL

		IF ::FInstances[ ::TableClass, "DisplayFieldsClass" ] == NIL

			DisplayFieldsClass := HBClass():New( ::ClassName + "DisplayFields" )

			DisplayFieldsClass:AddData( "__FObj" )
			DisplayFieldsClass:AddData( "__FFields" )
			DisplayFieldsClass:AddData( "__FLastLabel" )
			DisplayFieldsClass:AddData( "__FSyncFromAlias" )

			FOR EACH AField IN ::FFieldList

				IF AField:nameAlias = NIL
					msgName := AField:Name
				ELSE
					msgName := AField:nameAlias
				ENDIF

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

	/* obtained from Harbour's src/rdd/workarea.c hb_waCreateFields */

	IF ::FFieldTypes == NIL
		::FFieldTypes := {=>}
		::FFieldTypes['C'] := "TStringField"		/* HB_FT_STRING */
		::FFieldTypes['L'] := "TLogicalField"		/* HB_FT_LOGICAL */
		::FFieldTypes['D'] := "TDateField"			/* HB_FT_DATE */
		::FFieldTypes['I'] := "TIntegerField"		/* HB_FT_INTEGER */
		::FFieldTypes['Y'] := "TNumericField"		/* HB_FT_CURRENCY */
		::FFieldTypes['2'] := "TIntegerField"		/* HB_FT_INTEGER */
		::FFieldTypes['4'] := "TIntegerField"		/* HB_FT_INTEGER */
		::FFieldTypes['N'] := "TNumericField"		/* HB_FT_LONG */
		::FFieldTypes['F'] := "TNumericField"		/* HB_FT_FLOAT */
		::FFieldTypes['8'] := "TFloatField"			/* HB_FT_DOUBLE */
		::FFieldTypes['B'] := "TFloatField"			/* HB_FT_DOUBLE */

		::FFieldTypes['T'] := "TTimeField"			/* HB_FT_DAYTIME(8) HB_FT_TIME(4) */
		::FFieldTypes['@'] := "TDayTimeField"		/* HB_FT_DAYTIME */
		::FFieldTypes['='] := "TModTimeField"		/* HB_FT_MODTIME */
		::FFieldTypes['^'] := "TRowVerField"		/* HB_FT_ROWVER */
		::FFieldTypes['+'] := "TAutoIncField"		/* HB_FT_AUTOINC */
		::FFieldTypes['Q'] := "TVarLengthField"		/* HB_FT_VARLENGTH */
		::FFieldTypes['V'] := "TVarLengthField"		/* HB_FT_VARLENGTH */
		::FFieldTypes['M'] := "TMemoField"			/* HB_FT_MEMO */
		::FFieldTypes['P'] := "TImageField"			/* HB_FT_IMAGE */
		::FFieldTypes['W'] := "TBlobField"			/* HB_FT_BLOB */
		::FFieldTypes['G'] := "TOleField"			/* HB_FT_OLE */
		::FFieldTypes['0'] := "TVarLengthField"		/* HB_FT_VARLENGTH (NULLABLE) */
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
	GetInstance
	Teo. Mexico 2008
*/
METHOD FUNCTION GetInstance CLASS TTable
//	 LOCAL instance

//	 IF ::FRDOClient != NIL //.AND. !HB_HHasKey( ::FInstances, ::TableClass )
//		 instance := ::SendToServer()
//		 RETURN instance
//	 ENDIF

	IF HB_HHasKey( ::FInstances, ::TableClass )
		RETURN ::FInstances[ ::TableClass ]
	ENDIF

RETURN NIL

/*
	GetPrimaryIndex
	Teo. Mexico 2009
*/
METHOD FUNCTION GetPrimaryIndex( curClass, masterSourceBaseClass ) CLASS TTable
	LOCAL className

	curClass := iif( curClass = NIL, Self, curClass )
	className := curClass:ClassName()

	IF ! className == "TTABLE"
		IF className == masterSourceBaseClass
			masterSourceBaseClass := NIL
		ENDIF
		IF HB_HHasKey( ::FPrimaryIndexList, className ) .AND. Empty( masterSourceBaseClass )
			RETURN ::FIndexList[ className, ::FPrimaryIndexList[ className ] ]
		ENDIF
		RETURN ::GetPrimaryIndex( curClass:Super, masterSourceBaseClass )
	ENDIF

RETURN NIL

/*
	GetPrimaryKeyField
	Teo. Mexico 2009
*/
METHOD FUNCTION GetPrimaryKeyField( masterSourceBaseClass ) CLASS TTable
	LOCAL index

	IF masterSourceBaseClass != NIL
		masterSourceBaseClass := Upper( masterSourceBaseClass )
	ENDIF

	index := ::GetPrimaryIndex( NIL, masterSourceBaseClass )
	
	IF index != NIL
		RETURN index:KeyField
	ENDIF

RETURN NIL

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
	
		::OnClassInitializing()

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
		IF Empty( ::FFieldList )
			::DefineFieldsFromDb()
		ENDIF
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

	IF ::Eof() .OR. ::Bof() .OR. ( ::MasterSource != NIL .AND. ::MasterSource:Eof() )
		RETURN .F.
	ENDIF

	IF !primaryIndex == NIL .AND. !primaryIndex:InsideScope()
		RETURN .F.
	ENDIF

RETURN ::FIndex = NIL .OR. primaryIndex == ::FIndex .OR. ::FIndex:InsideScope()

/*
	OnDataChange
	Teo. Mexico 2010
*/
METHOD PROCEDURE OnDataChange() CLASS TTable
	IF ::OnDataChangeBlock != NIL
		::OnDataChangeBlock:Eval( Self )
	ENDIF
RETURN

/*
	OnDestruct
	Teo. Mexico 2010
*/
METHOD PROCEDURE OnDestruct() CLASS TTable
	LOCAL dbfName, indexName

	IF ::aliasTmp != NIL
		dbfName := ::aliasTmp:DbInfo( DBI_FULLPATH )
		indexName := ::aliasTmp:DbOrderInfo( DBOI_FULLPATH )
		::aliasTmp:DbCloseAll()
		FErase( dbfName )
		FErase( indexName )
	ENDIF

RETURN

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

	::SetState( dsBrowse )

	/*
	 * Try to sync with MasterSource (if any)
	 */
	::SyncFromMasterSourceFields()
	
	::FHasDeletedOrder := ::Alias:OrdNumber( "Deleted" ) > 0

	::OnAfterOpen()

RETURN .T.

/*
	OrdCondSet
	Teo. Mexico 2010
*/
METHOD FUNCTION OrdCondSet( ... ) CLASS TTable
RETURN ::Alias:OrdCondSet( ... )

/*
	OrdCreate
	Teo. Mexico 2010
*/
METHOD PROCEDURE OrdCreate( ... ) CLASS TTable
	LOCAL scopeTop, scopeBottom
	LOCAL masterKeyVal
	LOCAL syncFromAlias := ::DisplayFields:__FSyncFromAlias
	LOCAL oDlg

	DbSelectArea( ::Alias:Name )
	
	IF !Empty( ::IndexName )
		masterKeyVal := ::Index:MasterKeyVal
		OrdSetFocus( ::IndexName )
		scopeTop := ordScope( 0, RTrim( masterKeyVal + ::Index:ScopeTop() ) )
		scopeBottom := ordScope( 1, masterKeyVal + ::Index:ScopeBottom() )
	ENDIF

	//DbGoTop()
	
	::DisplayFields:__FSyncFromAlias := .T.
	
	CREATE DIALOG oDlg ;
		TITLE "Un momento..." ;
		PARENT ::Frame
		
	SHOW WINDOW oDlg CENTRE

	::Alias:OrdCreate( ... )

	IF !Empty( ::IndexName )
		ordSetFocus( ::IndexName )
		ordScope( 0, scopeTop )
		ordScope( 1, scopeBottom )
	ENDIF

	DESTROY oDlg
	
	::DisplayFields:__FSyncFromAlias := syncFromAlias
	
	ordCustom( NIL, NIL, .T. )

RETURN

/*
	Post
	Teo. Mexico 2010
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

				/*
				IF AField:FieldMethodType = "C" .AND. AField:Changed
					AField:SetData()
				ENDIF
				*/

			NEXT

			::RecUnLock()

			result := .T.

		ENDIF

	RECOVER USING errObj
	
		::Cancel()

		SHOW ERROR errObj

	ALWAYS

		::FSubState := dssNone

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
	LOCAL AIndex := ::FindIndex( index )

RETURN AIndex:RawGet4Seek( direction, ::GetField( xField ):FieldReadBlock, keyVal, softSeek )

/*
	RawSeek
	Teo. Mexico 2008
*/
METHOD FUNCTION RawSeek( Value, index ) CLASS TTable
RETURN ::FindIndex( index ):RawSeek( Value )

/*
	RecLock
	Teo. Mexico 2006
*/
METHOD FUNCTION RecLock CLASS TTable
	LOCAL allowOnDataChange
	LOCAL result

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
	
	allowOnDataChange := ::allowOnDataChange
	::allowOnDataChange := .F.
	
	result := ::GetCurrentRecord()

	IF result
		::SetState( dsEdit )
	ELSE
		::Alias:RecUnLock()
	ENDIF
	
	::allowOnDataChange := allowOnDataChange

RETURN result

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

	::FUnderReset := .T.

	FOR EACH AField IN ::FFieldList

		IF AField:FieldMethodType = "C" .AND. !AField:Calculated .AND. !AField:IsMasterFieldComponent
			AField:Reset()
		ENDIF

	NEXT
	
	::FUnderReset := .F.

RETURN

/*
	SetIndex
	Teo. Mexico 2010
*/
METHOD PROCEDURE SetIndex( index ) CLASS TTable
	IF !::FIndex == index
		IF ::PrimaryIndex != NIL .AND. !::PrimaryMasterKeyField == index:MasterKeyField
			wxhAlert( "On Table '" + ::ClassName + "' MasterKeyField on index '" + index:Name + "' doesn't match the Primary MasterKeyField..." )
		ENDIF
		::FIndex := index
	ENDIF
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
			::Index := index
			RETURN
		ENDIF

		RAISE ERROR	 "<" + ::ClassName + ">: Index name '" + indexName + "' doesn't exist..."

	ENDIF

RETURN

/*
	SetKeyVal
	Teo. Mexico 2010
*/
METHOD FUNCTION SetKeyVal( keyVal ) CLASS TTable
	::PrimaryIndex:SetKeyVal( keyVal )
RETURN Self

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
	OTHERWISE
		RAISE ERROR "Invalid type in assigning MasterSource..."
	END

	/*!
	 * Check for a valid GetMasterSourceClassName (if any)
	 */
	IF !Empty( ::GetMasterSourceClassName() )
		//IF !::MasterSource:IsDerivedFrom( ::GetMasterSourceClassName ) .AND. !::DataBase:TableIsChildOf( ::GetMasterSourceClassName, ::MasterSource:ClassName )
		//IF ! Upper( ::GetMasterSourceClassName ) == ::MasterSource:ClassName
		IF ! ::MasterSource:IsDerivedFrom( ::GetMasterSourceClassName() )
			RAISE ERROR "Table <" + ::TableClass + "> Invalid MasterSource Class Name: " + ::MasterSource:ClassName + ";Expected class type: <" + ::GetMasterSourceClassName() + ">"
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
				::DbGoTo( recNo )
				EXIT
			ENDIF
			num_skipped++
		ENDDO
	ELSE
		WHILE !::Bof() .AND. num_skipped > n
			recNo := ::RecNo
			::DbSkip( -1 )
			IF ::Bof()
				::DbGoTo( recNo )
				EXIT
			ENDIF
			num_skipped--
		ENDDO
	ENDIF

RETURN num_skipped

/*
	SkipFilter
	Teo. Mexico 2010
*/
METHOD FUNCTION SkipFilter( n, index ) CLASS TTable
	LOCAL i
	LOCAL tagName
	LOCAL o
	LOCAL alias
	
	IF n = NIL
		n := 1
	ENDIF

	IF n > 0
		i := 1
	ELSEIF n < 0
		i := -1
	ELSE
		i := 0
	ENDIF

	n := Abs( n )
	
	IF index = NIL
		tagName := NIL
		o := Self
		alias := ::Alias
	ELSE
		tagName := index:TagName
		o := index
		alias := index:GetAlias()
	ENDIF

	WHILE .T.
		alias:DbSkip( i, tagName )
		IF ! o:GetCurrentRecord()
			RETURN .F.
		ENDIF
		IF ::FilterEval( index )
			--n
		ENDIF
		IF n <= 0
			EXIT
		ENDIF
	ENDDO

RETURN .T.

/*
	StatePop
	Teo. Mexico 2010
*/
METHOD PROCEDURE StatePop() CLASS TTable
	
	::FFieldList       := ::tableState[ ::tableStateLen ]["FieldList"]
	::DetailSourceList := ::tableState[ ::tableStateLen ]["DetailSourceList"]
	::FRecNo           := ::tableState[ ::tableStateLen ]["RecNo"]
	::FState           := ::tableState[ ::tableStateLen ]["State"]
	::IndexName        := ::tableState[ ::tableStateLen ]["IndexName"]

	--::tableStateLen
	
	::Alias:Pop()
	
RETURN

/*
	StatePush
	Teo. Mexico 2010
*/
METHOD PROCEDURE StatePush() CLASS TTable
	LOCAL obj

	IF Len( ::tableState ) < ++::tableStateLen
		AAdd( ::tableState, {=>} )
	ENDIF

	::tableState[ ::tableStateLen ]["FieldList"]        := ::FFieldList
	::tableState[ ::tableStateLen ]["DetailSourceList"] := ::DetailSourceList
	::tableState[ ::tableStateLen ]["RecNo"]            := ::FRecNo
	::tableState[ ::tableStateLen ]["State"]            := ::FState
	::tableState[ ::tableStateLen ]["IndexName"]        := ::IndexName
	
	IF !HB_HHasKey( ::tableState[ ::tableStateLen ], "FieldListNew" )
		::FFieldList := {}
		FOR EACH obj IN ::tableState[ ::tableStateLen ]["FieldList"]
			AAdd( ::FFieldList, __ObjClone( obj ) )
		NEXT
		::tableState[ ::tableStateLen ]["FieldListNew"] := ::FFieldList
	ELSE
		::FFieldList := ::tableState[ ::tableStateLen ]["FieldListNew"]
	ENDIF

	IF !HB_HHasKey( ::tableState[ ::tableStateLen ], "DetailSourceListNew" )
		::DetailSourceList := {=>}
		::tableState[ ::tableStateLen ]["DetailSourceListNew"] := ::DetailSourceList
	ELSE
		::DetailSourceList := ::tableState[ ::tableStateLen ]["DetailSourceListNew"]
	ENDIF

	::FState := dsBrowse
	
	::Alias:Push()
	
RETURN

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
			IF ! ::PrimaryMasterKeyField:Reset()
				// raise error
			ENDIF
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
