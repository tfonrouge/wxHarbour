/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  PROPERTY
  Teo Mexico 2006
*/

// With INDEX
// With READ
// With WRITE
#xcommand PROPERTY <name> [AS <astype>] INDEX <i> [READ <rm>] [WRITE <wm>] ;
          => ;
          METHOD <name> INLINE ::<rm>( <i> ) ;;
          METHOD _<name>( xNewVal ) INLINE ::<wm>( <i>, xNewVal )

// With INDEX
// With READ
// Without WRITE
#xcommand PROPERTY <name> [AS <astype>] INDEX <i> [READ <rm>] ;
          => ;
          METHOD <name> INLINE ::<rm>( <i> )

// With INDEX
// Without READ
// With WRITE
#xcommand PROPERTY <name> [AS <astype>] INDEX <i> [WRITE <wm>] ;
          => ;
          METHOD _<name>( xNewVal ) INLINE ::<wm>( <i>, xNewVal )

// Without INDEX
// With READ
// With WRITE
#xcommand PROPERTY <name> [AS <astype>] [READ <rm>] [WRITE <wm>] ;
          [<scope: EXPORTED, EXPORT, VISIBLE, PUBLIC, PROTECTED, HIDDEN, PRIVATE, READONLY, RO, PUBLISHED >] ;
          => ;
          METHOD <name> INLINE ::<rm> [<scope>] ;;
          METHOD _<name>( xNewVal ) INLINE ::<wm>( xNewVal ) [<scope>]

// Without INDEX
// With READ
// Without WRITE
#xcommand PROPERTY <name> [AS <astype>] [READ <rm>] ;
          => ;
          METHOD <name> INLINE ::<rm>

// Without INDEX
// Without READ
// With WRITE
#xcommand PROPERTY <name> [AS <astype>] [WRITE <wm>] ;
          => ;
          METHOD _<name>( xNewVal ) INLINE ::<wm>( xNewVal )

// Without INDEX
// Without READ
// Without WRITE
#xcommand PROPERTY <name> [AS <astype>] ;
          => ;
          METHOD <name> INLINE Super:<name> ;;
          METHOD _<name> INLINE Super:_<name>

// Simple VAR varname TO object
//#xcommand VAR <DataName> TO <oObject> => VAR <DataName> IS <DataName> TO <oObject>
#xcommand DATA <DataName> IS <OtherName> => VAR <DataName> IS <OtherName>
#xcommand DATA <DataName> IS <OtherName> TO <oObject> => VAR <DataName> IS <OtherName> TO <oObject>
#xcommand DATA <DataName> TO <oObject> => VAR <DataName> IS <DataName> TO <oObject>

#xcommand DEFAULT <uVar1> := <uVal1> ;
                  [, <uVarN> := <uValN> ] => ;
                     <uVar1> := If( <uVar1> == nil, <uVal1>, <uVar1> ) ;;
                   [ <uVarN> := If( <uVarN> == nil, <uValN>, <uVarN> ); ]

#xcommand DECLARE FUNCTION <FunctionName> ;
          => ;

#xcommand DECLARE PROCEDURE <ProcedureName> ;
          => ;

#xcommand DECLARE METHOD FUNCTION <FunctionName> ;
          => ;

#xcommand DECLARE METHOD PROCEDURE <ProcedureName> ;
          => ;

//  REPEAT .. UNTIL
#xcommand REPEAT => DO WHILE .T.
#xcommand UNTIL <expression> => ;
          IF <expression> ; EXIT ; ENDIF ; ENDDO

//
#xcommand FUNCTION <FuncDeclaration> CLASS <TheClass> ;
          => ;
          METHOD <FuncDeclaration> CLASS <TheClass>

//
#xcommand ENDWITH => END WITH

#xcommand EXTEND OBJECT <Obj> WITH MESSAGE <Message> INLINE <code,...> [SCOPE <Scope>] [<Persistent: PERSISTENT> ] [<Case: NOUPPER>] => ;
  __clsAddMsg( <Obj>:ClassH, <Message>, {|Self| <code> }, HB_OO_MSG_INLINE, NIL, IIF( <.Scope.>, <Scope>, HB_OO_CLSTP_EXPORTED ), <.Persistent>, <.Case.> )

#xcommand EXTEND OBJECT <Obj> WITH MESSAGE <Message>( <params,...> ) INLINE <code,...> [SCOPE <Scope>] [<Persistent: PERSISTENT> ] [<Case: NOUPPER>] => ;
  __clsAddMsg( <Obj>:ClassH , "_"+<Message>, {|Self, <params>| <code> }, HB_OO_MSG_INLINE, NIL, IIF( <.Scope.>, <Scope>, HB_OO_CLSTP_EXPORTED ), <.Persistent>, <.Case.> )









