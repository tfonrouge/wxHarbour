/*
 * $Id$
 */

/*
	Arelds.ch
	Teo. Mexico 2008
*/

#ifndef _RADDOX_H_
#define _RADDOX_H_

#include "rdodefs.h"

#define dsInactive  0
#define dsBrowse    1
#define dsInsert    2
#define dsEdit      4
#define dsReading   8

#define dssNone     0
#define dssAdding   1
#define dssPosting  2

#xtranslate ADD TABLE <tableName> [ <vt: VIRTUAL> ] [ INDEX <indexName> ] ;
			=> ;
			::cmdAddTable( <tableName>, [ <indexName> ], <.vt.> )

#xtranslate DEFINE CHILD ;
			=> ;
			::cmdDefineChild()

#xtranslate END CHILD ;
			=> ;
			::cmdEndChild()

#xtranslate ADD TABLE <parentTableName> CHILD <childTableName> [ INDEX <indexName> ];
			=> ;
			::AddParentChild( <parentTableName>, <childTableName>, [ <indexName> ] )

/* To REQUIRE SIZE in TStringField */
#xtranslate ADD STRING FIELD <xFieldMethod> [<clauses1,...>] SIZE <nsize> [<clauses2,...>] ;
						=> ;
						ADD _STRING FIELD <xFieldMethod> [<clauses1>] SIZE <nsize> [<clauses2>]
#xtranslate T_StringField => TStringField

/* To REQUIRE LEN DEC in TNumericField */
#xtranslate ADD NUMERIC FIELD <xFieldMethod> [<clauses1,...>] LEN <nLen> DEC <nDec> [<clauses2,...>] ;
						=> ;
						ADD _NUMERIC FIELD <xFieldMethod> [<clauses1>] LEN <nLen> DEC <nDec> [<clauses2>]
#xtranslate T_NumericField => TNumericField

/* To REQUIRE OBJVALUE in TObjectField */
#xtranslate ADD OBJECT FIELD <xFieldMethod> [<clauses1,...>] OBJVALUE <objValue> [<clauses2,...>] ;
						=> ;
						ADD _OBJECT FIELD <xFieldMethod> [<clauses1>] OBJVALUE <objValue> [<clauses2>]
#xtranslate T_ObjectField => TObjectField


#xtranslate ADD <type: _STRING, MEMO, _NUMERIC, FLOAT, INTEGER, LOGICAL, DATE, DAYTIME, MODTIME, _OBJECT> FIELD [<xFieldMethod>] ;
						[ NAME <cName> ] ;
						[ LABEL <label> ] ;
						[ <ro: READONLY> ] ;
						[ DEFAULT <xDefault> ] ;
						[ READ <readblock,...> ] ;
						[ WRITE <writeblock,...> ] ;
						[ <rq: REQUIRED> ] ;
						[ GROUP <cGroup> ] ;
						[ DESCRIPTION <cDesc> ] ;
						[ PICKLIST <pickList> ] ;
						[ SIZE <nSize> ] ;
						[ LEN <nLen> ] ;
						[ DEC <nDec> ] ;
						[ PICTURE <pict> ] ;
						[ <pv: PRIVATE> ] ;
						[ INCREMENT <incrementBlock> ] ;
						[ MASTERSOURCE <linkedTableMasterSource> ] ;
						[ OBJVALUE <objValue> ] ;
						[ ON GETTEXT <bOnGetText> ] ;
						[ ON SETTEXT <bOnSetText> ] ;
						[ ON SETVALUE <bOnSetValue> ] ;
						[ ON INDEXKEYVAL <bIndexKeyVal> ] ;
						[ ON VALIDATE <bOnValidate> ] ;
						[ ON SEARCH <bOnSearch> ] ;
						[ ON BEFORE CHANGE <bOnBeforeChange> ] ;
						[ ON AFTER CHANGE <bOnAfterChange> ] ;
						[ VALIDVALUES <validValues> ] ;
						[ USING <usingField> ] ;
					 => ;
						WITH OBJECT T<type>Field():New( Self ) ;;
							[ :Name := <cName> ] ;;
							[ :Label := <label> ] ;;
							[ :ReadOnly := <.ro.> ] ;;
							[ :FieldMethod := <xFieldMethod> ] ;;
							[ :ReadBlock := {|| <readblock> } ] ;;
							[ :WriteBlock := {|Value| <writeblock> } ] ;;
							[ :DefaultValue := <xDefault> ] ;;
							[ :Required := <.rq.> ] ;;
							[ :Group := <cGroup> ] ;;
							[ :Description := <cDesc> ] ;;
							[ :PickList := <pickList> ] ;;
							[ :Size := <nSize> ] ;;
							[ :DBS_LEN := <nLen> ] ;;
							[ :DBS_DEC := <nDec> ] ;;
							[ :Picture := <pict> ] ;;
							[ :Published := !<.pv.> ] ;;
							[ :IncrementBlock := <incrementBlock> ] ;;
							[ :LinkedTableMasterSource := <linkedTableMasterSource> ] ;;
							[ :ObjValue := <objValue> ] ;;
							[ :OnGetText := {|field,Text| <bOnGetText> } ] ;;
							[ :OnSetText := {|field,Text| <bOnSetText> } ] ;;
							[ :OnSetValue := {|field,Value| <bOnSetValue> } ] ;;
							[ :OnGetIndexKeyVal := <bIndexKeyVal> ] ;;
							[ :OnValidate := <bOnValidate> ] ;;
							[ :OnSearch := <bOnSearch> ] ;;
							[ :OnBeforeChange := <bOnBeforeChange> ] ;;
							[ :OnAfterChange := <bOnAfterChange> ] ;;
							[ :ValidValues := <validValues> ] ;;
							[ :UsingField := <usingField> ] ;;
							:AddFieldMessage() ;;
							:ValidateFieldInfo() ;;
						ENDWITH
						
#xtranslate ADD ALIAS FIELD <aliasFldName> FROM <fld> ;
			=> ;
			::AddFieldAlias( <aliasFldName>, <fld> )

#xtranslate DEFINE MASTERDETAIL FIELDS => METHOD DefineMasterDetailFields

#xtranslate DEFINE FIELDS => METHOD __DefineFields( curClass )
#xtranslate DEFINE INDEXES => METHOD __DefineIndexes( curClass )

#xtranslate BEGIN FIELDS CLASS <className>;
						=> ;
						METHOD PROCEDURE __DefineFields( curClass ) CLASS <className> ;;
						::FBaseClass := iif( curClass == NIL, Self:ClassName, curClass:ClassName ) ;;
						Super:__DefineFields( iif( curClass == NIL, Self:Super, curClass:Super ) ) 

#xtranslate END FIELDS CLASS ;
						=> ;
						RETURN

#xtranslate BEGIN INDEXES CLASS <className> ;
						=> ;
						METHOD PROCEDURE __DefineIndexes( curClass ) CLASS <className>
#xtranslate END INDEXES CLASS ;
						=> ;
			Super:__DefineIndexes( iif( curClass == NIL, Self:Super, curClass:Super ) ) ;;
			RETURN

#xtranslate BEGIN MASTERDETAIL FIELDS CLASS <className> => ;
						METHOD PROCEDURE DefineMasterDetailFields CLASS <className>
#xtranslate ADD MASTER <cMaster> DETAIL <cDetail> => ;
						::MasterDetailFieldList\[ <cMaster> \] := <cDetail>
#xtranslate END MASTERDETAIL FIELDS => ;
						RETURN

#xtranslate CALCFIELD <clcField> => METHOD CalcField_<clcField>
#xtranslate CALCFIELD <clcField>( [<params,...>] ) CLASS <className> ;
	=> ;
	METHOD FUNCTION CalcField_<clcField>( [<params>] ) CLASS <className>

/* TODO: Implement this, needs to use a index declared in ancestor class
#xtranslate DEFINE PRIMARY INDEX <cName> ;
			=> ;
			TIndex():New( Self, <cName>, "PRIMARY" )
*/

#xtranslate DEFINE <type: PRIMARY,SECONDARY> INDEX <cName> ;
						[ MASTERKEYFIELD <cMasterKeyField> ] ;
						[ KEYFIELD <cKeyField> ] ;
						[ FOR <ForKey> ] ;
						[ <cs: CASESENSITIVE> ] ;
						[ <de: DESCENDING> ] ;
						[ <cu: CUSTOM> ] ;
						[ <un: UNIQUE> ] ;
						[ <ai: AUTOINCREMENT> ] ;
						=> ;
						WITH OBJECT TIndex():New( Self , <cName>, <"type">, curClass ) ;;
								:AddIndex( [<cMasterKeyField>], [<.ai.>], [<.un.>], [<cKeyField>], [<ForKey>], [<.cs.>], [<.de.>], [<.cu.>] ) ;;
						ENDWITH

#endif
