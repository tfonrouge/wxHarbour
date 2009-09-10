/*
 * $Id$
 */

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

#ifndef _WX_EVENT_H_
#define _WX_EVENT_H_

#define WXDLLIMPEXP_BASE        9953
#define WXDLLIMPEXP_ADV         8586

#xcommand DECLARE_EVENT_TYPE( <evt>, <value> ) ;
          => ;
          #define <evt>         wxh_TRANSLATE_EVT_DEFS( <value> )

#xcommand DECLARE_EXPORTED_EVENT_TYPE( <evtBase>, <evt>, <value> ) ;
          => ;
          #define <evt>         wxh_TRANSLATE_EVT_DEFS( <evtBase> + <value> )

    DECLARE_EVENT_TYPE(wxEVT_COMMAND_BUTTON_CLICKED, 1)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_CHECKBOX_CLICKED, 2)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_CHOICE_SELECTED, 3)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_LISTBOX_SELECTED, 4)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_LISTBOX_DOUBLECLICKED, 5)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_CHECKLISTBOX_TOGGLED, 6)
    // now they are in wx/textctrl.h
//#ifdef WXWIN_COMPATIBILITY_EVENT_TYPES
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_TEXT_UPDATED, 7)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_TEXT_ENTER, 8)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_TEXT_URL, 13)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_TEXT_MAXLEN, 14)
//#endif // WXWIN_COMPATIBILITY_EVENT_TYPES
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_MENU_SELECTED, 9)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_SLIDER_UPDATED, 10)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_RADIOBOX_SELECTED, 11)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_RADIOBUTTON_SELECTED, 12)

    // wxEVT_COMMAND_SCROLLBAR_UPDATED is now obsolete since we use
    // wxEVT_SCROLL... events

    DECLARE_EVENT_TYPE(wxEVT_COMMAND_SCROLLBAR_UPDATED, 13)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_VLBOX_SELECTED, 14)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_COMBOBOX_SELECTED, 15)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_TOOL_RCLICKED, 16)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_TOOL_ENTER, 17)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_SPINCTRL_UPDATED, 18)

        // Sockets and timers send events, too
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_BASE, wxEVT_SOCKET, 50)

    DECLARE_EVENT_TYPE(wxEVT_TIMER, 80)

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

        // Non-client mouse events
    DECLARE_EVENT_TYPE(wxEVT_NC_LEFT_DOWN, 200)
    DECLARE_EVENT_TYPE(wxEVT_NC_LEFT_UP, 201)
    DECLARE_EVENT_TYPE(wxEVT_NC_MIDDLE_DOWN, 202)
    DECLARE_EVENT_TYPE(wxEVT_NC_MIDDLE_UP, 203)
    DECLARE_EVENT_TYPE(wxEVT_NC_RIGHT_DOWN, 204)
    DECLARE_EVENT_TYPE(wxEVT_NC_RIGHT_UP, 205)
    DECLARE_EVENT_TYPE(wxEVT_NC_MOTION, 206)
    DECLARE_EVENT_TYPE(wxEVT_NC_ENTER_WINDOW, 207)
    DECLARE_EVENT_TYPE(wxEVT_NC_LEAVE_WINDOW, 208)
    DECLARE_EVENT_TYPE(wxEVT_NC_LEFT_DCLICK, 209)
    DECLARE_EVENT_TYPE(wxEVT_NC_MIDDLE_DCLICK, 210)
    DECLARE_EVENT_TYPE(wxEVT_NC_RIGHT_DCLICK, 211)

        // Character input event type
    DECLARE_EVENT_TYPE(wxEVT_CHAR, 212)
    DECLARE_EVENT_TYPE(wxEVT_CHAR_HOOK, 213)
    DECLARE_EVENT_TYPE(wxEVT_NAVIGATION_KEY, 214)
    DECLARE_EVENT_TYPE(wxEVT_KEY_DOWN, 215)
    DECLARE_EVENT_TYPE(wxEVT_KEY_UP, 216)
#ifdef wxUSE_HOTKEY
    DECLARE_EVENT_TYPE(wxEVT_HOTKEY, 217)
#endif
        // Set cursor event
    DECLARE_EVENT_TYPE(wxEVT_SET_CURSOR, 230)

        // wxScrollBar and wxSlider event identifiers
    DECLARE_EVENT_TYPE(wxEVT_SCROLL_TOP, 300)
    DECLARE_EVENT_TYPE(wxEVT_SCROLL_BOTTOM, 301)
    DECLARE_EVENT_TYPE(wxEVT_SCROLL_LINEUP, 302)
    DECLARE_EVENT_TYPE(wxEVT_SCROLL_LINEDOWN, 303)
    DECLARE_EVENT_TYPE(wxEVT_SCROLL_PAGEUP, 304)
    DECLARE_EVENT_TYPE(wxEVT_SCROLL_PAGEDOWN, 305)
    DECLARE_EVENT_TYPE(wxEVT_SCROLL_THUMBTRACK, 306)
    DECLARE_EVENT_TYPE(wxEVT_SCROLL_THUMBRELEASE, 307)
    DECLARE_EVENT_TYPE(wxEVT_SCROLL_CHANGED, 308)

        // Scroll events from wxWindow
    DECLARE_EVENT_TYPE(wxEVT_SCROLLWIN_TOP, 320)
    DECLARE_EVENT_TYPE(wxEVT_SCROLLWIN_BOTTOM, 321)
    DECLARE_EVENT_TYPE(wxEVT_SCROLLWIN_LINEUP, 322)
    DECLARE_EVENT_TYPE(wxEVT_SCROLLWIN_LINEDOWN, 323)
    DECLARE_EVENT_TYPE(wxEVT_SCROLLWIN_PAGEUP, 324)
    DECLARE_EVENT_TYPE(wxEVT_SCROLLWIN_PAGEDOWN, 325)
    DECLARE_EVENT_TYPE(wxEVT_SCROLLWIN_THUMBTRACK, 326)
    DECLARE_EVENT_TYPE(wxEVT_SCROLLWIN_THUMBRELEASE, 327)

        // System events
    DECLARE_EVENT_TYPE(wxEVT_SIZE, 400)
    DECLARE_EVENT_TYPE(wxEVT_MOVE, 401)
    DECLARE_EVENT_TYPE(wxEVT_CLOSE_WINDOW, 402)
    DECLARE_EVENT_TYPE(wxEVT_END_SESSION, 403)
    DECLARE_EVENT_TYPE(wxEVT_QUERY_END_SESSION, 404)
    DECLARE_EVENT_TYPE(wxEVT_ACTIVATE_APP, 405)
    // 406..408 are power events
    DECLARE_EVENT_TYPE(wxEVT_ACTIVATE, 409)
    DECLARE_EVENT_TYPE(wxEVT_CREATE, 410)
    DECLARE_EVENT_TYPE(wxEVT_DESTROY, 411)
    DECLARE_EVENT_TYPE(wxEVT_SHOW, 412)
    DECLARE_EVENT_TYPE(wxEVT_ICONIZE, 413)
    DECLARE_EVENT_TYPE(wxEVT_MAXIMIZE, 414)
    DECLARE_EVENT_TYPE(wxEVT_MOUSE_CAPTURE_CHANGED, 415)
    DECLARE_EVENT_TYPE(wxEVT_MOUSE_CAPTURE_LOST, 416)
    DECLARE_EVENT_TYPE(wxEVT_PAINT, 417)
    DECLARE_EVENT_TYPE(wxEVT_ERASE_BACKGROUND, 418)
    DECLARE_EVENT_TYPE(wxEVT_NC_PAINT, 419)
    DECLARE_EVENT_TYPE(wxEVT_PAINT_ICON, 420)
    DECLARE_EVENT_TYPE(wxEVT_MENU_OPEN, 421)
    DECLARE_EVENT_TYPE(wxEVT_MENU_CLOSE, 422)
    DECLARE_EVENT_TYPE(wxEVT_MENU_HIGHLIGHT, 423)
    DECLARE_EVENT_TYPE(wxEVT_CONTEXT_MENU, 424)
    DECLARE_EVENT_TYPE(wxEVT_SYS_COLOUR_CHANGED, 425)
    DECLARE_EVENT_TYPE(wxEVT_DISPLAY_CHANGED, 426)
    DECLARE_EVENT_TYPE(wxEVT_SETTING_CHANGED, 427)
    DECLARE_EVENT_TYPE(wxEVT_QUERY_NEW_PALETTE, 428)
    DECLARE_EVENT_TYPE(wxEVT_PALETTE_CHANGED, 429)
    DECLARE_EVENT_TYPE(wxEVT_JOY_BUTTON_DOWN, 430)
    DECLARE_EVENT_TYPE(wxEVT_JOY_BUTTON_UP, 431)
    DECLARE_EVENT_TYPE(wxEVT_JOY_MOVE, 432)
    DECLARE_EVENT_TYPE(wxEVT_JOY_ZMOVE, 433)
    DECLARE_EVENT_TYPE(wxEVT_DROP_FILES, 434)
    DECLARE_EVENT_TYPE(wxEVT_DRAW_ITEM, 435)
    DECLARE_EVENT_TYPE(wxEVT_MEASURE_ITEM, 436)
    DECLARE_EVENT_TYPE(wxEVT_COMPARE_ITEM, 437)
    DECLARE_EVENT_TYPE(wxEVT_INIT_DIALOG, 438)
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_BASE, wxEVT_IDLE, 439)
    DECLARE_EVENT_TYPE(wxEVT_UPDATE_UI, 440)
    DECLARE_EVENT_TYPE(wxEVT_SIZING, 441)
    DECLARE_EVENT_TYPE(wxEVT_MOVING, 442)
    DECLARE_EVENT_TYPE(wxEVT_HIBERNATE, 443)
    // more power events follow -- see wx/power.h

        // Clipboard events
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_TEXT_COPY, 444)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_TEXT_CUT, 445)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_TEXT_PASTE, 446)

        // Generic command events
        // Note: a click is a higher-level event than button down/up
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_LEFT_CLICK, 500)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_LEFT_DCLICK, 501)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_RIGHT_CLICK, 502)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_RIGHT_DCLICK, 503)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_SET_FOCUS, 504)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_KILL_FOCUS, 505)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_ENTER, 506)

        // Notebook events
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_NOTEBOOK_PAGE_CHANGED, 802)
    DECLARE_EVENT_TYPE(wxEVT_COMMAND_NOTEBOOK_PAGE_CHANGING, 803)

        // Help events
    DECLARE_EVENT_TYPE(wxEVT_HELP, 1050)
    DECLARE_EVENT_TYPE(wxEVT_DETAILED_HELP, 1051)

        // Grid events
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV, wxEVT_GRID_CELL_LEFT_CLICK, 1580)
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV, wxEVT_GRID_CELL_RIGHT_CLICK, 1581)
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV, wxEVT_GRID_CELL_LEFT_DCLICK, 1582)
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV, wxEVT_GRID_CELL_RIGHT_DCLICK, 1583)
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV, wxEVT_GRID_LABEL_LEFT_CLICK, 1584)
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV, wxEVT_GRID_LABEL_RIGHT_CLICK, 1585)
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV, wxEVT_GRID_LABEL_LEFT_DCLICK, 1586)
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV, wxEVT_GRID_LABEL_RIGHT_DCLICK, 1587)
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV, wxEVT_GRID_ROW_SIZE, 1588)
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV, wxEVT_GRID_COL_SIZE, 1589)
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV, wxEVT_GRID_RANGE_SELECT, 1590)
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV, wxEVT_GRID_CELL_CHANGE, 1591)
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV, wxEVT_GRID_SELECT_CELL, 1592)
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV, wxEVT_GRID_EDITOR_SHOWN, 1593)
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV, wxEVT_GRID_EDITOR_HIDDEN, 1594)
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV, wxEVT_GRID_EDITOR_CREATED, 1595)
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV, wxEVT_GRID_CELL_BEGIN_DRAG, 1596)
    DECLARE_EXPORTED_EVENT_TYPE(WXDLLIMPEXP_ADV, wxEVT_GRID_COL_MOVE, 1597)

#endif
