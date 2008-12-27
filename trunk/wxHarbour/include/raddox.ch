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

/* To REQUIRE SIZE in TObjectField */
#xtranslate ADD OBJECT FIELD <xFieldMethod> [<clauses1,...>] OBJVALUE <objValue> [<clauses2,...>] ;
            => ;
            ADD _OBJECT FIELD <xFieldMethod> [<clauses1>] OBJVALUE <objValue> [<clauses2>]
#xtranslate T_ObjectField => TObjectField


#xtranslate ADD <type: _STRING, MEMO, NUMERIC, LOGICAL, DATE, DAYTIME, MODTIME, _OBJECT> FIELD [<xFieldMethod>] ;
            [ NAME <cName> ] ;
            [ LABEL <label> ] ;
            [ <ro: READONLY> ] ;
            [ DEFAULT <xDefault> ] ;
            [ READ <readblock,...> ] ;
            [ WRITE <writeblock,...> ] ;
            [ <rq: REQUIRED> ] ;
            [ GROUP <cGroup> ] ;
            [ DESCRIPTION <cDesc> ] ;
            [ GETITPICK <bGetItPick> ] ;
            [ SIZE <nSize> ] ;
            [ PICTURE <pict> ] ;
            [ <pv: PRIVATE> ] ;
            [ OBJVALUE <objValue> ] ;
            [ ON GETTEXT <bOnGetText> ] ;
            [ ON SETTEXT <bOnSetText> ] ;
            [ ON SETVALUE <bOnSetValue> ] ;
            [ ON INDEXKEYVAL <bIndexKeyVal> ] ;
            [ ON VALIDATE <bOnValidate> ] ;
            [ ON BEFORE CHANGE <bOnBeforeChange> ] ;
            [ ON [AFTER] CHANGE <bOnChange> ] ;
            [ VALIDVALUES <validValues> ] ;
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
              [ :GetItPick := <bGetItPick> ] ;;
              [ :Size := <nSize> ] ;;
              [ :Picture := <pict> ] ;;
              [ :Published := !<.pv.> ] ;;
              [ :ObjValue := <objValue> ] ;;
              [ :OnGetText := {|field,Text| <bOnGetText> } ] ;;
              [ :OnSetText := {|field,Text| <bOnSetText> } ] ;;
              [ :OnSetValue := {|field,Value| <bOnSetValue> } ] ;;
              [ :OnGetIndexKeyVal := <bIndexKeyVal> ] ;;
              [ :OnValidate := <bOnValidate> ] ;;
              [ :OnBeforeChange := <bOnBeforeChange> ] ;;
              [ :OnChange := <bOnChange> ] ;;
              [ :ValidValues := <validValues> ] ;;
              :ValidateFieldInfo() ;;
            ENDWITH

#xtranslate DEFINE MASTERDETAIL FIELDS => METHOD DefineMasterDetailFields


#xtranslate METHOD [PROCEDURE] DefineFields CLASS <className> ;
            => ;
            METHOD PROCEDURE DefineFields( curClass ) CLASS <className>

#xtranslate BEGIN FIELD SECTION ;
            => ;
            ::FBaseClass := iif( curClass = NIL, Self:ClassName, curClass:ClassName )

#xtranslate END FIELD SECTION ;
            => ;
            Super:DefineFields( iif( curClass = NIL, Self:Super, curClass:Super ) )


#xtranslate BEGIN MASTERDETAIL FIELDS CLASS <className> => ;
            METHOD PROCEDURE DefineMasterDetailFields CLASS <className>
#xtranslate ADD MASTER <cMaster> DETAIL <cDetail> => ;
            ::MasterDetailFieldList\[ <cMaster> \] := <cDetail>
#xtranslate END MASTERDETAIL FIELDS => ;
            RETURN

#xtranslate EVENT <evtName> => METHOD <evtName>
#xtranslate CALCFIELD <calcField> => METHOD CalcField_<calcField>

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
