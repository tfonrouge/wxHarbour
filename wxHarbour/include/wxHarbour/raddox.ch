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

/* To REQUIRE OBJVALUE in TObjectField */
#xtranslate ADD OBJECT FIELD <xFieldMethod> [<clauses1,...>] OBJVALUE <objValue> [<clauses2,...>] ;
            => ;
            ADD _OBJECT FIELD <xFieldMethod> [<clauses1>] OBJVALUE <objValue> [<clauses2>]
#xtranslate T_ObjectField => TObjectField


#xtranslate ADD <type: _STRING, MEMO, NUMERIC, INTEGER, LOGICAL, DATE, DAYTIME, MODTIME, _OBJECT> FIELD [<xFieldMethod>] ;
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
            [ PICTURE <pict> ] ;
            [ <pv: PRIVATE> ] ;
			[ MASTERSOURCE <linkedTableMasterSource> ] ;
            [ OBJVALUE <objValue> ] ;
            [ ON GETTEXT <bOnGetText> ] ;
            [ ON SETTEXT <bOnSetText> ] ;
            [ ON SETVALUE <bOnSetValue> ] ;
            [ ON INDEXKEYVAL <bIndexKeyVal> ] ;
            [ ON VALIDATE <bOnValidate> ] ;
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
              [ :Picture := <pict> ] ;;
              [ :Published := !<.pv.> ] ;;
			  [ :LinkedTableMasterSource := <linkedTableMasterSource> ] ;;
              [ :ObjValue := <objValue> ] ;;
              [ :OnGetText := {|field,Text| <bOnGetText> } ] ;;
              [ :OnSetText := {|field,Text| <bOnSetText> } ] ;;
              [ :OnSetValue := {|field,Value| <bOnSetValue> } ] ;;
              [ :OnGetIndexKeyVal := <bIndexKeyVal> ] ;;
              [ :OnValidate := <bOnValidate> ] ;;
              [ :OnBeforeChange := <bOnBeforeChange> ] ;;
              [ :OnAfterChange := <bOnAfterChange> ] ;;
              [ :ValidValues := <validValues> ] ;;
			  [ :UsingField := <usingField> ] ;;
              :ValidateFieldInfo() ;;
            ENDWITH

#xtranslate DEFINE MASTERDETAIL FIELDS => METHOD DefineMasterDetailFields

#xtranslate FIELDS BASECLASS => ::FBaseClass := iif( curClass == NIL, Self:ClassName, curClass:ClassName )

#xtranslate DEFINE FIELDS => METHOD __DefineFields( curClass )
#xtranslate DEFINE INDEXES => METHOD __DefineIndexes()

#xtranslate BEGIN FIELDS CLASS <className>;
            => ;
            METHOD PROCEDURE __DefineFields( curClass ) CLASS <className> ;;
            FIELDS BASECLASS

#xtranslate END FIELDS CLASS ;
            => ;
            Super:__DefineFields( iif( curClass == NIL, Self:Super, curClass:Super ) ) ;;
            RETURN

#xtranslate BEGIN INDEXES CLASS <className> ;
            => ;
            METHOD PROCEDURE __DefineIndexes() CLASS <className>
#xtranslate END INDEXES CLASS => RETURN


#xtranslate BEGIN MASTERDETAIL FIELDS CLASS <className> => ;
            METHOD PROCEDURE DefineMasterDetailFields CLASS <className>
#xtranslate ADD MASTER <cMaster> DETAIL <cDetail> => ;
            ::MasterDetailFieldList\[ <cMaster> \] := <cDetail>
#xtranslate END MASTERDETAIL FIELDS => ;
            RETURN

#xtranslate CALCFIELD <calcField> => METHOD CalcField_<calcField>
#xtranslate CALCFIELD <calcField> CLASS <className> ;
            => ;
            METHOD FUNCTION CalcField_<calcField>() CLASS <className>

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
            WITH OBJECT TIndex():New( Self , <"type"> ) ;;
                :AddIndex( <cName> , [<cMasterKeyField>], [<.ai.>], [<.un.>], [<cKeyField>], [<ForKey>], [<.cs.>], [<.de.>], [<.cu.>] ) ;;
            ENDWITH

#endif
