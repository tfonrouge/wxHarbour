/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  event.ch
  Teo. Mexico 2006
*/

#xcommand DECLARE_EVENT_TYPE( <evt>, <id> ) => ;
          #define <evt> <id>

#define wxEVT_COMMAND_BUTTON_CLICKED            wxEVT_FIRST(1)
#define wxEVT_COMMAND_CHECKBOX_CLICKED          wxEVT_FIRST(2)
#define wxEVT_COMMAND_CHOICE_SELECTED           wxEVT_FIRST(3)
#define wxEVT_COMMAND_LISTBOX_SELECTED          wxEVT_FIRST(4)
#define wxEVT_COMMAND_LISTBOX_DOUBLECLICKED     wxEVT_FIRST(5)
#define wxEVT_COMMAND_CHECKLISTBOX_TOGGLED      wxEVT_FIRST(6)
#define wxEVT_COMMAND_MENU_SELECTED             wxEVT_FIRST(7)

    // Mouse event types
DECLARE_EVENT_TYPE(wxEVT_LEFT_DOWN, 100)
DECLARE_EVENT_TYPE(wxEVT_LEFT_UP, 101)
DECLARE_EVENT_TYPE(wxEVT_MIDDLE_DOWN, 102)
DECLARE_EVENT_TYPE(wxEVT_MIDDLE_UP, 103)
DECLARE_EVENT_TYPE(wxEVT_RIGHT_DOWN, 104)
DECLARE_EVENT_TYPE(wxEVT_RIGHT_UP, 105)
DECLARE_EVENT_TYPE(wxEVT_MOTION, 106)
DECLARE_EVENT_TYPE(wxEVT_ENTER_WINDOW, 107)
DECLARE_EVENT_TYPE(wxEVT_LEAVE_WINDOW, 108)
DECLARE_EVENT_TYPE(wxEVT_LEFT_DCLICK, 109)
DECLARE_EVENT_TYPE(wxEVT_MIDDLE_DCLICK, 110)
DECLARE_EVENT_TYPE(wxEVT_RIGHT_DCLICK, 111)
DECLARE_EVENT_TYPE(wxEVT_SET_FOCUS, 112)
DECLARE_EVENT_TYPE(wxEVT_KILL_FOCUS, 113)
DECLARE_EVENT_TYPE(wxEVT_CHILD_FOCUS, 114)
DECLARE_EVENT_TYPE(wxEVT_MOUSEWHEEL, 115)

