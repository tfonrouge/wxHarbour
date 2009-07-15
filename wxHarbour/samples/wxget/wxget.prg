#include "wxharbour.ch"
#include "hbclass.ch"
#include "hblang.ch"
#include "color.ch"
#include "common.ch"
#include "setcurs.ch"
#include "getexit.ch"
#include "inkey.ch"
#include "button.ch"


FUNCTION Main
  LOCAL wxGetSample
  wxGetSample := wxGetSample():New()
  IMPLEMENT_APP( wxGetSample )
RETURN NIL

/*
  wxGetSample
  jamaj Brasil 2009
*/
CLASS wxGetSample FROM wxApp
PRIVATE:
PROTECTED:
PUBLIC:
  METHOD OnInit
PUBLISHED:
ENDCLASS

METHOD FUNCTION OnInit() CLASS wxGetSample
  LOCAL oDlg, oTextCtrl, oTextCtrl1, oTextCtrl2
	Local bAction, bOnGFocus, bOnLFocus, bOnChar, bOnKeyDown, bOnKeyUp		

	LOCAL edtNombre := "jamaj corporation", data := date(), edtLog := Space(100), salary := 12345678.34

	SET DATE TO BRITISH
	SET CENTURY ON 

  CREATE DIALOG oDlg ;
         WIDTH 640 HEIGHT 400 ;
         TITLE "Text Sample"

	BEGIN BOXSIZER VERTICAL 
		BEGIN BOXSIZER VERTICAL ALIGN EXPAND STRETCH
			BEGIN BOXSIZER HORIZONTAL ALIGN EXPAND STRETCH
				@ SAY "Your Name is:" 
				oTextCtrl := TEditGet():New( oDlg, 123, "get1", edtNombre, {|_v_| IIF(pcount() > 0, edtNombre := _v_, edtNombre)  } ,"@!", bAction )
				containerObj():SetLastChild( oTextCtrl )
		  END SIZER
			BEGIN BOXSIZER HORIZONTAL ALIGN EXPAND STRETCH
				@ SAY "Your birthday is:" 
				oTextCtrl1 := TEditGet():New( oDlg, 124, "get2", data, {|_v_| IIF(pcount() > 0, data := _v_, data)  } ,"99/99/9999", bAction )
				oTextCtrl1:SetToolTip( "birthday" )	
				containerObj():SetLastChild( oTextCtrl1 )
		  END SIZER
			BEGIN BOXSIZER HORIZONTAL ALIGN EXPAND STRETCH
				@ SAY "Your salary is:" 
				oTextCtrl2 := TEditGet():New( oDlg, 124, "get2", salary, {|_v_| IIF(pcount() > 0, salary := _v_, salary)  } ,"@E 999,999,999.99", bAction )
				oTextCtrl2:SetToolTip( "salary" )	
				containerObj():SetLastChild( oTextCtrl2 )
		  END SIZER
		  @ SAY "Multi Line:" GET edtLog NAME "Multi" MULTILINE STYLE wxTE_PROCESS_ENTER //SIZERINFO STRETCH
		END SIZER
		@ BUTTON ID wxID_OK ACTION oDlg:Close()
	END SIZER

	SHOW WINDOW oDlg MODAL CENTRE
  oDlg:Destroy()

	? "Variable's data:"
  ? "edtNombre:", edtNombre
  ? "birthday:", data
  ? "salary:", salary 

RETURN .T.

CLASS TEditGet FROM THackGet,wxTextCtrl
PRIVATE:
	DATA 	bAction  	
	DATA	bOnGFocus	
	DATA	bOnLFocus	
	DATA	bOnChar	
	DATA	bOnKeyDown	
	DATA	bOnKeyUp		
	DATA  g
PROTECTED:
PUBLIC:
		DATA  plvl
		METHOD New( parent, id, name, var, block, picture, bAction, bOnGFocus, bOnLFocus, bOnChar, bOnKeyDown, bOnKeyUp  ) CONSTRUCTOR
		METHOD display()
PUBLISHED:
ENDCLASS


METHOD New( parent, id, name, var, block, picture, bAction, bOnGFocus, bOnLFocus, bOnChar, bOnKeyDown, bOnKeyUp  ) CLASS TEditGet
			::wxTextCtrl:New( parent, id, var, NIL, NIL, wxTE_PROCESS_ENTER, NIL, name )
			::g := ::THackGet:New( 10, 10, block, var, picture , "W/B+" )

			DEFAULT bAction  	TO { | event | OnAction(SELF,event) }
			DEFAULT bOnGFocus	TO { | event | OnGFocus(SELF,event) }
			DEFAULT bOnLFocus	TO { | event | OnLFocus(SELF,event) }
			DEFAULT bOnChar		TO { | event | OnChar(SELF, event)   }		
			DEFAULT bOnKeyDown	TO { | event | OnKeyDown(SELF, event) }		
			DEFAULT bOnKeyUp		TO { | event | OnKeyUp(SELF, event)   }		

			::bAction		 := bAction
			::bOnGFocus	 := bOnGFocus
			::bOnLFocus	 := bOnLFocus
			::bOnChar		 := bOnChar 
			::bOnKeyDown := bOnKeyDown
			::bOnKeyUp   := bOnKeyDown
			
			::ConnectFocusEvt( ::GetId(), wxEVT_KILL_FOCUS,   ::bOnLFocus )
			::ConnectFocusEvt( ::GetId(), wxEVT_SET_FOCUS, 	  ::bOnGFocus )
			::ConnectKeyEvt( 	 ::GetId(), wxEVT_KEY_DOWN, 		::bOnKeyDown )
			::ConnectKeyEvt( 	 ::GetId(), wxEVT_KEY_UP, 			::bOnKeyUp )
			::ConnectKeyEvt( 	 ::GetId(), wxEVT_CHAR, 				::bOnChar	 )

			::setfocus()
			::updatebuffer()
			IIF(HB_ISSTRING(::buffer),::setValue(::buffer),NIL)

RETURN Self


METHOD display() CLASS TEditGet
		LOCAL nCurPos := (::GetInsertionPoint())
		? "TEditGet:Display() =>" , " Buffer: " , ::buffer , " Len(Buffer) = " , IIF(HB_ISSTRING(::buffer), Alltrim(Str(Len(::buffer))),0) , " Cursor: " , Alltrim(Str(::pos)) , "/" , Alltrim(Str(nCurPos))
		// SUPER:display() => Would call THackGet():display()
RETURN Self


FUNCTION OnAction(event)	
	LOCAL lRet := .t.
//	LOCAL window := event:GetWindow()
	? "OnAction" 
	event:skip()
RETURN lRet

FUNCTION OnGFocus(SELF,event)
	LOCAL lRet := .t.
	LOCAL window := event:GetWindow()
	LOCAL nCurPos := (::GetInsertionPoint())
	::SetFocus()
	::updatebuffer()
	IIF(HB_ISSTRING(::buffer),::setValue(::buffer),NIL)
	IIF(HB_ISSTRING(::buffer),::SetMaxLength(len(::buffer)),NIL)
	? "OnGFocus", " Buffer: " , ::buffer , " Len(Buffer) = " , IIF(HB_ISSTRING(::buffer), Alltrim(Str(Len(::buffer))),0) , " Cursor: " , Alltrim(Str(::pos)) , "/" , Alltrim(Str(nCurPos))
	event:skip()
RETURN lRet

FUNCTION OnLFocus(SELF,event)
	LOCAL lRet := .t.
//	LOCAL window := event:GetWindow()
	LOCAL nCurPos := (::GetInsertionPoint())

	::ChangeValue( ::buffer )
	::assign()
	::killfocus()
	::Display()
	? "OnLFocus" , " Buffer: " , ::buffer , " Len(Buffer) = " , IIF(HB_ISSTRING(::buffer), Alltrim(Str(Len(::buffer))),0) , " Cursor: " , Alltrim(Str(::pos)) , "/" , Alltrim(Str(nCurPos))
	event:skip(.f.)
RETURN lRet

FUNCTION OnChar(SELF,event)
	LOCAL lRet := .t., lSkip
	LOCAL keycode := event:GetKeyCode()
	LOCAL ctrlDown := event:ControlDown()
	//altd()
	? ("OnChar key=" + Str(keycode) + "-" + GetKeyName(keycode) + " " + "UnicodeKey=" + Str(event:GetUnicodeKey()))
	lSkip := Typer(SELF,event)
	event:skip(lSkip)
  IF(!lSkip)
		::ChangeValue( ::buffer )
		::SetInsertionPoint(::pos-1)
		::plvl := event:StopPropagation()
	ELSE
		::ChangeValue( ::buffer )
		::SetInsertionPoint(::pos-1)
		IF(HB_ISNUMERIC(::plvl))
			event:ResumePropagation(::plvl)
		ENDIF
	ENDIF	

RETURN lRet

FUNCTION OnKeyDown(SELF,event)
	LOCAL lRet := .t.
	LOCAL keycode := event:GetKeyCode()
	LOCAL ctrlDown := event:ControlDown()
	? ("OnKeyDown key=" + Str(keycode) + "-" + GetKeyName(keycode) +" " + "UnicodeKey=" + Str(event:GetUnicodeKey()))
	event:skip()
RETURN lRet

FUNCTION OnKeyUp(SELF,event)
	LOCAL lRet := .t.
	LOCAL keycode := event:GetKeyCode()
	LOCAL ctrlDown := event:ControlDown()
	//LOCAL shiftDown := event:ShiftDown() => Not yet implemented in wxharbour
	//LOCAL altDown := event:AltDown()		=> Not yet implemented in wxharbour	
	? ("OnKeyUp key=" + Str(keycode) + "-" + IIF(ctrlDown,"CTRL+","") + GetKeyName(keycode) +" " + "UnicodeKey=" + Str(event:GetUnicodeKey()) )
	event:skip()
RETURN lRet


FUNCTION GetKeyName(keycode)
	LOCAL cKey :=  ""

	SWITCH keycode
		case WXK_BACK
			cKey +=("BACK")
			EXIT
		case WXK_TAB
			cKey +=("TAB")
			EXIT
		case WXK_RETURN 
			cKey +=("RETURN") 
			EXIT
		case WXK_ESCAPE   
			cKey +=("ESCAPE") 
			EXIT
		case WXK_SPACE   
			cKey +=("SPACE") 
			EXIT
		case WXK_DELETE   
			cKey +=("DELETE") 
			EXIT
		case WXK_START   
			cKey +=("START") 
			EXIT
		case WXK_LBUTTON   
			cKey +=("LBUTTON") 
			EXIT
		case WXK_RBUTTON   
			cKey +=("RBUTTON") 
			EXIT
		case WXK_CANCEL   
			cKey +=("CANCEL") 
			EXIT
		case WXK_MBUTTON   
			cKey +=("MBUTTON") 
			EXIT
		case WXK_CLEAR   
			cKey +=("CLEAR") 
			EXIT
		case WXK_SHIFT   
			cKey +=("SHIFT") 
			EXIT
		case WXK_ALT   
			cKey +=("ALT") 
			EXIT
		case WXK_CONTROL   
			cKey +=("CONTROL") 
			EXIT
		case WXK_MENU   
			cKey +=("MENU") 
			EXIT
		case WXK_PAUSE   
			cKey +=("PAUSE") 
			EXIT
		case WXK_CAPITAL   
			cKey +=("CAPITAL") 
			EXIT
		case WXK_END   
			cKey +=("END") 
			EXIT
		case WXK_HOME   
			cKey +=("HOME") 
			EXIT
		case WXK_LEFT   
			cKey +=("LEFT") 
			EXIT
		case WXK_UP   
			cKey +=("UP") 
			EXIT
		case WXK_RIGHT   
			cKey +=("RIGHT") 
			EXIT
		case WXK_DOWN   
			cKey +=("DOWN") 
			EXIT
		case WXK_SELECT   
			cKey +=("SELECT") 
			EXIT
		case WXK_PRINT   
			cKey +=("PRINT") 
			EXIT
		case WXK_EXECUTE   
			cKey +=("EXECUTE") 
			EXIT
		case WXK_SNAPSHOT   
			cKey +=("SNAPSHOT") 
			EXIT
		case WXK_INSERT   
			cKey +=("INSERT") 
			EXIT
		case WXK_HELP   
			cKey +=("HELP") 
			EXIT
		case WXK_NUMPAD0   
			cKey +=("NUMPAD0") 
			EXIT
		case WXK_NUMPAD1   
			cKey +=("NUMPAD1") 
			EXIT
		case WXK_NUMPAD2   
			cKey +=("NUMPAD2") 
			EXIT
		case WXK_NUMPAD3   
			cKey +=("NUMPAD3") 
			EXIT
		case WXK_NUMPAD4   
			cKey +=("NUMPAD4") 
			EXIT
		case WXK_NUMPAD5   
			cKey +=("NUMPAD5") 
			EXIT
		case WXK_NUMPAD6   
			cKey +=("NUMPAD6") 
			EXIT
		case WXK_NUMPAD7   
			cKey +=("NUMPAD7") 
			EXIT
		case WXK_NUMPAD8   
			cKey +=("NUMPAD8") 
			EXIT
		case WXK_NUMPAD9   
			cKey +=("NUMPAD9") 
			EXIT
		case WXK_MULTIPLY   
			cKey +=("MULTIPLY") 
			EXIT
		case WXK_ADD   
			cKey +=("ADD") 
			EXIT
		case WXK_SEPARATOR   
			cKey +=("SEPARATOR") 
			EXIT
		case WXK_SUBTRACT   
			cKey +=("SUBTRACT") 
			EXIT
		case WXK_DECIMAL   
			cKey +=("DECIMAL") 
			EXIT
		case WXK_DIVIDE   
			cKey +=("DIVIDE") 
			EXIT
		case WXK_F1   
			cKey +=("F1") 
			EXIT
		case WXK_F2   
			cKey +=("F2") 
			EXIT
		case WXK_F3   
			cKey +=("F3") 
			EXIT
		case WXK_F4   
			cKey +=("F4") 
			EXIT
		case WXK_F5   
			cKey +=("F5") 
			EXIT
		case WXK_F6   
			cKey +=("F6") 
			EXIT
		case WXK_F7   
			cKey +=("F7") 
			EXIT
		case WXK_F8   
			cKey +=("F8") 
			EXIT
		case WXK_F9   
			cKey +=("F9") 
			EXIT
		case WXK_F10   
			cKey +=("F10") 
			EXIT
		case WXK_F11   
			cKey +=("F11") 
			EXIT
		case WXK_F12   
			cKey +=("F12") 
			EXIT
		case WXK_F13   
			cKey +=("F13") 
			EXIT
		case WXK_F14   
			cKey +=("F14") 
			EXIT
		case WXK_F15   
			cKey +=("F15") 
			EXIT
		case WXK_F16   
			cKey +=("F16") 
			EXIT
		case WXK_F17   
			cKey +=("F17") 
			EXIT
		case WXK_F18   
			cKey +=("F18") 
			EXIT
		case WXK_F19   
			cKey +=("F19") 
			EXIT
		case WXK_F20   
			cKey +=("F20") 
			EXIT
		case WXK_F21   
			cKey +=("F21") 
			EXIT
		case WXK_F22   
			cKey +=("F22") 
			EXIT
		case WXK_F23   
			cKey +=("F23") 
			EXIT
		case WXK_F24   
			cKey +=("F24") 
			EXIT
		case WXK_NUMLOCK   
			cKey +=("NUMLOCK") 
			EXIT
		case WXK_SCROLL   
			cKey +=("SCROLL") 
			EXIT
		case WXK_PAGEUP   
			cKey +=("PAGEUP") 
			EXIT
		case WXK_PAGEDOWN   
			cKey +=("PAGEDOWN") 
			EXIT
		case WXK_NUMPAD_SPACE   
			cKey +=("NUMPAD_SPACE") 
			EXIT
		case WXK_NUMPAD_TAB   
			cKey +=("NUMPAD_TAB") 
			EXIT
		case WXK_NUMPAD_ENTER   
			cKey +=("NUMPAD_ENTER") 
			EXIT
		case WXK_NUMPAD_F1   
			cKey +=("NUMPAD_F1") 
			EXIT
		case WXK_NUMPAD_F2   
			cKey +=("NUMPAD_F2") 
			EXIT
		case WXK_NUMPAD_F3   
			cKey +=("NUMPAD_F3") 
			EXIT
		case WXK_NUMPAD_F4   
			cKey +=("NUMPAD_F4") 
			EXIT
		case WXK_NUMPAD_HOME   
			cKey +=("NUMPAD_HOME") 
			EXIT
		case WXK_NUMPAD_LEFT   
			cKey +=("NUMPAD_LEFT") 
			EXIT
		case WXK_NUMPAD_UP   
			cKey +=("NUMPAD_UP") 
			EXIT
		case WXK_NUMPAD_RIGHT   
			cKey +=("NUMPAD_RIGHT") 
			EXIT
		case WXK_NUMPAD_DOWN   
			cKey +=("NUMPAD_DOWN") 
			EXIT
		case WXK_NUMPAD_PAGEUP   
			cKey +=("NUMPAD_PAGEUP") 
			EXIT
		case WXK_NUMPAD_PAGEDOWN   
			cKey +=("NUMPAD_PAGEDOWN") 
			EXIT
		case WXK_NUMPAD_END   
			cKey +=("NUMPAD_END") 
			EXIT
		case WXK_NUMPAD_BEGIN   
			cKey +=("NUMPAD_BEGIN") 
			EXIT
		case WXK_NUMPAD_INSERT   
			cKey +=("NUMPAD_INSERT") 
			EXIT
		case WXK_NUMPAD_DELETE   
			cKey +=("NUMPAD_DELETE") 
			EXIT
		case WXK_NUMPAD_EQUAL   
			cKey +=("NUMPAD_EQUAL") 
			EXIT
		case WXK_NUMPAD_MULTIPLY   
			cKey +=("NUMPAD_MULTIPLY") 
			EXIT
		case WXK_NUMPAD_ADD   
			cKey +=("NUMPAD_ADD") 
			EXIT
		case WXK_NUMPAD_SEPARATOR   
			cKey +=("NUMPAD_SEPARATOR") 
			EXIT
		case WXK_NUMPAD_SUBTRACT   
			cKey +=("NUMPAD_SUBTRACT") 
			EXIT
		case WXK_NUMPAD_DECIMAL   
			cKey +=("NUMPAD_DECIMAL") 
			EXIT
		OTHERWISE
		   IF ( wxIsprint(keycode) )
				 cKey :=  "'" + CHR(keycode) + "'"
		   ELSEIF ( keycode > 0 .and. keycode < 27 )
				 cKey :=  "'" + "Ctrl-" + CHR( ASC( "A" )+keycode-1 ) + "'"
		   ELSE
				 cKey :=  "unknown ("+ Alltrim(Str(keycode)) +")"
			ENDIF
	END
RETURN (cKey)

CLASS THackGet FROM GET
	METHOD New( nRow, nCol, bVarBlock, cVarName, cPicture, cColorSpec ) CONSTRUCTOR
	METHOD display() 
ENDCLASS

METHOD New( nRow, nCol, bVarBlock, cVarName, cPicture, cColorSpec ) CLASS THackGet
	Super:New( nRow, nCol, bVarBlock, cVarName, cPicture, cColorSpec )
RETURN Self

METHOD display() CLASS THackGet
	? "THackGet:Display() =>" + "Buffer: " + ::buffer + " Len(Buffer) = " + Alltrim(Str(Len(::buffer))) + " Cursor: " + Alltrim(Str(::pos))
RETURN Self


FUNCTION Typer(g,event)
	LOCAL lSkip:=.f., cValue, lInsert := .t., cKey, bExit, lValidOk, lExitRequest := .f.
	LOCAL nCurPos 
	LOCAL nKey := event:GetKeyCode()
	LOCAL ctrlDown := event:ControlDown()
	bExit := { |nKey| .f. }
  //altd()
	g:SetFocus()

	nCurPos := (g:GetInsertionPoint())	
	? "Typer(A): GET pos= " + alltrim(str(g:pos)) + " " + "EDIT pos=" + alltrim(str(nCurPos))

	do case
		case ( nKey == K_ENTER  )
		case ( nKEY == WXK_TAB )
			if ( ValType( eval(g:block) ) == "D" )
				cValue := g:Buffer
				lValidOk := ( DtoC( CtoD( cValue ) ) == cValue )
			else
				lValidOk := .t.
			endif
			lSkip := lValidOk
		case ( nKey == WXK_ESCAPE  )
			lExitRequest := .t.
			lSkip := .t.
		case ( nKEY == K_CTRL_U )
			g:Undo()
		case ( nKey == WXK_INSERT )
			lInsert := !lInsert
			Set( _SET_INSERT, lInsert )
		case ( nKey == WXK_HOME )
			g:Home()
		case ( nKey == WXK_END )
			g:End()
		case ( nKey == WXK_RIGHT .and. !ctrlDown )
			g:Right()
		case ( nKey == WXK_LEFT .and. !ctrlDown)
			g:Left()
		case ( nKey == WXK_RIGHT .and. ctrlDown )
			g:WordRight()
		case ( nKey == WXK_LEFT .and. ctrlDown)
			g:WordLeft()
		case ( nKey == WXK_BACK )
			g:backSpace()
		case ( nKey == WXK_DELETE )
			g:delete()
		case ( nKey == K_CTRL_T )
			g:DelWordRight()
		case ( nKey == K_CTRL_Y )
			g:DelEnd()
		otherwise
			if ( wxIsprint(nKey) )
				// data key
				cKey := Chr( nKey )
				if ( g:Type == "N" .and. ;
					( cKey == "." .or. cKey == "," ) )
					// go to decimal point
					g:ToDecPos()
				else
					// send it to the get
					if ( lInsert )
						g:Insert( cKey )
					else
						g:Overstrike( cKey )
					end
					lSkip := .f.
				end
			elseif ( nKey != 0 )
					lExitRequest := ( lExitRequest .or. Eval( bExit, nKey ) )
			end
		endcase
		nCurPos := (g:GetInsertionPoint())	
		? "Typer(A): GET pos= " + alltrim(str(g:pos)) + " " + "EDIT pos=" + alltrim(str(nCurPos))
RETURN (lSkip)

