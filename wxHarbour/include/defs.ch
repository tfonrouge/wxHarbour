/*
  wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2006 Teo Fonrouge

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

  (C) 2006 Teo Fonrouge <teo@windtelsoft.com>
*/

/*
  defs.ch
  Teo. Mexico 2006
*/

#ifndef _WX_DEFS_H_
#define _WX_DEFS_H_

/*  ---------------------------------------------------------------------------- */
/*  standard IDs */
/*  ---------------------------------------------------------------------------- */

/*  Standard menu IDs */
    /* no id matches this one when compared to it */
#define wxID_NONE       -3

    /*  id for a separator line in the menu (invalid for normal item) */
#define wxID_SEPARATOR  -2

    /* any id: means that we don't care about the id, whether when installing
     * an event handler or when creating a new window */
#define wxID_ANY        -1


    /* all predefined ids are between wxID_LOWEST and wxID_HIGHEST */
#define wxID_LOWEST     4999

#define wxID_OPEN               wxID_LOWEST + 1
#define wxID_CLOSE              wxID_LOWEST + 2
#define wxID_NEW                wxID_LOWEST + 3
#define wxID_SAVE               wxID_LOWEST + 4
#define wxID_SAVEAS             wxID_LOWEST + 5
#define wxID_REVERT             wxID_LOWEST + 6
#define wxID_EXIT               wxID_LOWEST + 7
#define wxID_UNDO               wxID_LOWEST + 8
#define wxID_REDO               wxID_LOWEST + 9
#define wxID_HELP               wxID_LOWEST + 10
#define wxID_PRINT              wxID_LOWEST + 11
#define wxID_PRINT_SETUP        wxID_LOWEST + 12
#define wxID_PAGE_SETUP         wxID_LOWEST + 13
#define wxID_PREVIEW            wxID_LOWEST + 14
#define wxID_ABOUT              wxID_LOWEST + 15
#define wxID_HELP_CONTENTS      wxID_LOWEST + 16
#define wxID_HELP_INDEX         wxID_LOWEST + 17
#define wxID_HELP_SEARCH        wxID_LOWEST + 18
#define wxID_HELP_COMMANDS      wxID_LOWEST + 19
#define wxID_HELP_PROCEDURES    wxID_LOWEST + 20
#define wxID_HELP_CONTEXT       wxID_LOWEST + 21
#define wxID_CLOSE_ALL          wxID_LOWEST + 22
#define wxID_PREFERENCES        wxID_LOWEST + 23

#define wxID_EDIT               5030
#define wxID_CUT                wxID_EDIT + 1
#define wxID_COPY               wxID_EDIT + 2
#define wxID_PASTE              wxID_EDIT + 3
#define wxID_CLEAR              wxID_EDIT + 4
#define wxID_FIND               wxID_EDIT + 5
#define wxID_DUPLICATE          wxID_EDIT + 6
#define wxID_SELECTALL          wxID_EDIT + 7
#define wxID_DELETE             wxID_EDIT + 8
#define wxID_REPLACE            wxID_EDIT + 9
#define wxID_REPLACE_ALL        wxID_EDIT + 10
#define wxID_PROPERTIES         wxID_EDIT + 11

#define wxID_VIEW_DETAILS       wxID_EDIT + 12
#define wxID_VIEW_LARGEICONS    wxID_EDIT + 13
#define wxID_VIEW_SMALLICONS    wxID_EDIT + 14
#define wxID_VIEW_LIST          wxID_EDIT + 15
#define wxID_VIEW_SORTDATE      wxID_EDIT + 16
#define wxID_VIEW_SORTNAME      wxID_EDIT + 17
#define wxID_VIEW_SORTSIZE      wxID_EDIT + 18
#define wxID_VIEW_SORTTYPE      wxID_EDIT + 19

#define wxID_FILE               5050
#define wxID_FILE1              wxID_FILE + 1
#define wxID_FILE2              wxID_FILE + 2
#define wxID_FILE3              wxID_FILE + 3
#define wxID_FILE4              wxID_FILE + 4
#define wxID_FILE5              wxID_FILE + 5
#define wxID_FILE6              wxID_FILE + 6
#define wxID_FILE7              wxID_FILE + 7
#define wxID_FILE8              wxID_FILE + 8
#define wxID_FILE9              wxID_FILE + 9

    /*  Standard button and menu IDs */
#define wxID_OK                 5100
#define wxID_CANCEL             wxID_OK + 1
#define wxID_APPLY              wxID_OK + 2
#define wxID_YES                wxID_OK + 3
#define wxID_NO                 wxID_OK + 4
#define wxID_STATIC             wxID_OK + 5
#define wxID_FORWARD            wxID_OK + 6
#define wxID_BACKWARD           wxID_OK + 7
#define wxID_DEFAULT            wxID_OK + 8
#define wxID_MORE               wxID_OK + 9
#define wxID_SETUP              wxID_OK + 10
#define wxID_RESET              wxID_OK + 11
#define wxID_CONTEXT_HELP       wxID_OK + 12
#define wxID_YESTOALL           wxID_OK + 13
#define wxID_NOTOALL            wxID_OK + 14
#define wxID_ABORT              wxID_OK + 15
#define wxID_RETRY              wxID_OK + 16
#define wxID_IGNORE             wxID_OK + 17
#define wxID_ADD                wxID_OK + 18
#define wxID_REMOVE             wxID_OK + 19

#define wxID_UP                 wxID_OK + 20
#define wxID_DOWN               wxID_OK + 21
#define wxID_HOME               wxID_OK + 22
#define wxID_REFRESH            wxID_OK + 23
#define wxID_STOP               wxID_OK + 24
#define wxID_INDEX              wxID_OK + 25

#define wxID_BOLD               wxID_OK + 26
#define wxID_ITALIC             wxID_OK + 27
#define wxID_JUSTIFY_CENTER     wxID_OK + 28
#define wxID_JUSTIFY_FILL       wxID_OK + 29
#define wxID_JUSTIFY_RIGHT      wxID_OK + 30
#define wxID_JUSTIFY_LEFT       wxID_OK + 31
#define wxID_UNDERLINE          wxID_OK + 32
#define wxID_INDENT             wxID_OK + 33
#define wxID_UNINDENT           wxID_OK + 34
#define wxID_ZOOM_100           wxID_OK + 35
#define wxID_ZOOM_FIT           wxID_OK + 36
#define wxID_ZOOM_IN            wxID_OK + 37
#define wxID_ZOOM_OUT           wxID_OK + 38
#define wxID_UNDELETE           wxID_OK + 39
#define wxID_REVERT_TO_SAVED    wxID_OK + 40

    /*  System menu IDs (used by wxUniv): */
#define wxID_SYSTEM_MENU        5200
#define wxID_CLOSE_FRAME        wxID_SYSTEM_MENU + 1
#define wxID_MOVE_FRAME         wxID_SYSTEM_MENU + 2
#define wxID_RESIZE_FRAME       wxID_SYSTEM_MENU + 3
#define wxID_MAXIMIZE_FRAME     wxID_SYSTEM_MENU + 4
#define wxID_ICONIZE_FRAME      wxID_SYSTEM_MENU + 5
#define wxID_RESTORE_FRAME      wxID_SYSTEM_MENU + 6

    /*  IDs used by generic file dialog (13 consecutive starting from this value) */
#define wxID_FILEDLGG           5900

#define wxID_HIGHEST            5999

/*
*/
#define wxITEM_SEPARATOR     -1
#define wxITEM_NORMAL         0
#define wxITEM_CHECK          1
#define wxITEM_RADIO          2
#define wxITEM_MAX            3

// Orientation
#define wxHORIZONTAL    0x0004
#define wxVERTICAL      0x0008
#define wxBOTH          HB_BITOR( wxVERTICAL, wxHORIZONTAL )

// wxDirection
#define wxLEFT    0x0010
#define wxRIGHT   0x0020
#define wxUP      0x0040
#define wxDOWN    0x0080

#define wxTOP     wxUP
#define wxBOTTON  wxDOWN

#define wxNORTH   wxUP
#define wxSOUTH   wxDOWN
#define wxWEST    wxLEFT
#define wxEAST    wxRIGHT

#define wxALL     HB_BITOR( wxUP, wxDOWN, wxRIGHT, wxLEFT )

// wxAlignment
#define wxALIGN_NOT                 0x0000
#define wxALIGN_CENTER_HORIZONTAL   0x0100
#define wxALIGN_CENTRE_HORIZONTAL   wxALIGN_CENTER_HORIZONTAL
#define wxALIGN_LEFT                wxALIGN_NOT
#define wxALIGN_TOP                 wxALIGN_NOT
#define wxALIGN_RIGHT               0x0200
#define wxALIGN_BOTTOM              0x0400
#define wxALIGN_CENTER_VERTICAL     0x0800
#define wxALIGN_CENTRE_VERTICAL     wxALIGN_CENTER_VERTICAL

#define wxALIGN_CENTER              HB_BITOR( wxALIGN_CENTER_HORIZONTAL, wxALIGN_CENTER_VERTICAL )
#define wxALIGN_CENTRE              wxALIGN_CENTER

#define wxALIGN_MASK                0x0f00

// wxStretch
#define wxSTRETCH_NOT     0x0000
#define wxSHRINK          0x1000
#define wxGROW            0x2000
#define wxEXPAND          wxGROW
#define wxSHAPED          0x4000
#define wxFIXED_MINSIZE   0x8000
#define wxTILE            0xc000

// wxBorder

#define wxBORDER_NONE     0x00200000
#define wxBORDER_STATIC   0x01000000
#define wxBORDER_SIMPLE   0x02000000
#define wxBORDER_RAISED   0x04000000
#define wxBORDER_SUNKEN   0x08000000
#define wxBORDER_DOUBLE   0x10000000

#define wxBORDER_MASK     0x1f200000

/*  Window style flags */
#define wxVSCROLL         0x80000000
#define wxHSCROLL         0x40000000
#define wxCAPTION         0x20000000

/* New styles */
#define wxDOUBLE_BORDER   wxBORDER_DOUBLE
#define wxSUNKEN_BORDER   wxBORDER_SUNKEN
#define wxRAISED_BORDER   wxBORDER_RAISED
#define wxBORDER          wxBORDER_SIMPLE
#define wxSIMPLE_BORDER   wxBORDER_SIMPLE
#define wxSTATIC_BORDER   wxBORDER_STATIC
#define wxNO_BORDER       wxBORDER_NONE

#define wxTAB_TRAVERSAL   0x00080000

/*
 * extended dialog specifiers. these values are stored in a different
 * flag and thus do not overlap with other style flags. note that these
 * values do not correspond to the return values of the dialogs (for
 * those values, look at the wxID_XXX defines).
 */

/*  wxCENTRE already defined as  0x00000001 */
#define wxYES                   0x00000002
#define wxOK                    0x00000004
#define wxNO                    0x00000008
#define wxYES_NO                HB_BITOR(wxYES,wxNO)
#define wxCANCEL                0x00000010

#define wxYES_DEFAULT           0x00000000  /*  has no effect (default) */
#define wxNO_DEFAULT            0x00000080

#define wxICON_EXCLAMATION      0x00000100
#define wxICON_HAND             0x00000200
#define wxICON_WARNING          wxICON_EXCLAMATION
#define wxICON_ERROR            wxICON_HAND
#define wxICON_QUESTION         0x00000400
#define wxICON_INFORMATION      0x00000800
#define wxICON_STOP             wxICON_HAND
#define wxICON_ASTERISK         wxICON_INFORMATION
#define wxICON_MASK             (0x00000100|0x00000200|0x00000400|0x00000800)

#define  wxFORWARD              0x00001000
#define  wxBACKWARD             0x00002000
#define  wxRESET                0x00004000
#define  wxHELP                 0x00008000
#define  wxMORE                 0x00010000
#define  wxSETUP                0x00020000

/*
 * wxScrollBar flags
 */
#define wxSB_HORIZONTAL      wxHORIZONTAL
#define wxSB_VERTICAL        wxVERTICAL

/*
 * wxStaticLine flags
 */
#define wxLI_HORIZONTAL         wxHORIZONTAL
#define wxLI_VERTICAL           wxVERTICAL

/*  Virtual keycodes */
#define WXK_BACK                8
#define WXK_TAB                 9
#define WXK_RETURN              13
#define WXK_ESCAPE              27
#define WXK_SPACE               32
#define WXK_DELETE              127

    /* These are, by design, not compatible with unicode characters.
       If you want to get a unicode character from a key event, use
       wxKeyEvent::GetUnicodeKey instead.                           */
#define WXK_START               300
#define WXK_LBUTTON             WXK_START + 1
#define WXK_RBUTTON             WXK_START + 2
#define WXK_CANCEL              WXK_START + 3
#define WXK_MBUTTON             WXK_START + 4
#define WXK_CLEAR               WXK_START + 5
#define WXK_SHIFT               WXK_START + 6
#define WXK_ALT                 WXK_START + 7
#define WXK_CONTROL             WXK_START + 8
#define WXK_MENU                WXK_START + 9
#define WXK_PAUSE               WXK_START + 10
#define WXK_CAPITAL             WXK_START + 11
#define WXK_END                 WXK_START + 12
#define WXK_HOME                WXK_START + 13
#define WXK_LEFT                WXK_START + 14
#define WXK_UP                  WXK_START + 15
#define WXK_RIGHT               WXK_START + 16
#define WXK_DOWN                WXK_START + 17
#define WXK_SELECT              WXK_START + 18
#define WXK_PRINT               WXK_START + 19
#define WXK_EXECUTE             WXK_START + 20
#define WXK_SNAPSHOT            WXK_START + 21
#define WXK_INSERT              WXK_START + 22
#define WXK_HELP                WXK_START + 23
#define WXK_NUMPAD0             WXK_START + 24
#define WXK_NUMPAD1             WXK_START + 25
#define WXK_NUMPAD2             WXK_START + 26
#define WXK_NUMPAD3             WXK_START + 27
#define WXK_NUMPAD4             WXK_START + 28
#define WXK_NUMPAD5             WXK_START + 29
#define WXK_NUMPAD6             WXK_START + 30
#define WXK_NUMPAD7             WXK_START + 31
#define WXK_NUMPAD8             WXK_START + 32
#define WXK_NUMPAD9             WXK_START + 33
#define WXK_MULTIPLY            WXK_START + 34
#define WXK_ADD                 WXK_START + 35
#define WXK_SEPARATOR           WXK_START + 36
#define WXK_SUBTRACT            WXK_START + 37
#define WXK_DECIMAL             WXK_START + 38
#define WXK_DIVIDE              WXK_START + 39
#define WXK_F1                  WXK_START + 40
#define WXK_F2                  WXK_START + 41
#define WXK_F3                  WXK_START + 42
#define WXK_F4                  WXK_START + 43
#define WXK_F5                  WXK_START + 44
#define WXK_F6                  WXK_START + 45
#define WXK_F7                  WXK_START + 46
#define WXK_F8                  WXK_START + 47
#define WXK_F9                  WXK_START + 48
#define WXK_F10                 WXK_START + 49
#define WXK_F11                 WXK_START + 50
#define WXK_F12                 WXK_START + 51
#define WXK_F13                 WXK_START + 52
#define WXK_F14                 WXK_START + 53
#define WXK_F15                 WXK_START + 54
#define WXK_F16                 WXK_START + 55
#define WXK_F17                 WXK_START + 56
#define WXK_F18                 WXK_START + 57
#define WXK_F19                 WXK_START + 58
#define WXK_F20                 WXK_START + 59
#define WXK_F21                 WXK_START + 60
#define WXK_F22                 WXK_START + 61
#define WXK_F23                 WXK_START + 62
#define WXK_F24                 WXK_START + 63
#define WXK_NUMLOCK             WXK_START + 64
#define WXK_SCROLL              WXK_START + 65
#define WXK_PAGEUP              WXK_START + 66
#define WXK_PAGEDOWN            WXK_START + 67

#ifdef WXWIN_COMPATIBILITY_2_6
#define WXK_PRIOR               WXK_PAGEUP
#define WXK_NEXT                WXK_PAGEDOWN
#endif

#define WXK_NUMPAD_SPACE        WXK_START + 68
#define WXK_NUMPAD_TAB          WXK_START + 69
#define WXK_NUMPAD_ENTER        WXK_START + 70
#define WXK_NUMPAD_F1           WXK_START + 71
#define WXK_NUMPAD_F2           WXK_START + 72
#define WXK_NUMPAD_F3           WXK_START + 73
#define WXK_NUMPAD_F4           WXK_START + 74
#define WXK_NUMPAD_HOME         WXK_START + 75
#define WXK_NUMPAD_LEFT         WXK_START + 76
#define WXK_NUMPAD_UP           WXK_START + 77
#define WXK_NUMPAD_RIGHT        WXK_START + 78
#define WXK_NUMPAD_DOWN         WXK_START + 79
#define WXK_NUMPAD_PAGEUP       WXK_START + 80
#define WXK_NUMPAD_PAGEDOWN     WXK_START + 81

#ifdef WXWIN_COMPATIBILITY_2_6
#define WXK_NUMPAD_PRIOR        WXK_NUMPAD_PAGEUP
#define WXK_NUMPAD_NEXT         WXK_NUMPAD_PAGEDOWN
#endif

#define WXK_NUMPAD_END           WXK_START + 82
#define WXK_NUMPAD_BEGIN         WXK_START + 83
#define WXK_NUMPAD_INSERT        WXK_START + 84
#define WXK_NUMPAD_DELETE        WXK_START + 85
#define WXK_NUMPAD_EQUAL         WXK_START + 86
#define WXK_NUMPAD_MULTIPLY      WXK_START + 87
#define WXK_NUMPAD_ADD           WXK_START + 88
#define WXK_NUMPAD_SEPARATOR     WXK_START + 89
#define WXK_NUMPAD_SUBTRACT      WXK_START + 90
#define WXK_NUMPAD_DECIMAL       WXK_START + 91
#define WXK_NUMPAD_DIVIDE        WXK_START + 92

#define WXK_WINDOWS_LEFT         WXK_START + 93
#define WXK_WINDOWS_RIGHT        WXK_START + 94
#define WXK_WINDOWS_MENU         WXK_START + 95
#define WXK_COMMAND              WXK_START + 96

    /* Hardware-specific buttons */
#define WXK_SPECIAL1            193
#define WXK_SPECIAL2            WXK_SPECIAL1 + 1
#define WXK_SPECIAL3            WXK_SPECIAL1 + 2
#define WXK_SPECIAL4            WXK_SPECIAL1 + 3
#define WXK_SPECIAL5            WXK_SPECIAL1 + 4
#define WXK_SPECIAL6            WXK_SPECIAL1 + 5
#define WXK_SPECIAL7            WXK_SPECIAL1 + 6
#define WXK_SPECIAL8            WXK_SPECIAL1 + 7
#define WXK_SPECIAL9            WXK_SPECIAL1 + 8
#define WXK_SPECIAL10           WXK_SPECIAL1 + 9
#define WXK_SPECIAL11           WXK_SPECIAL1 + 10
#define WXK_SPECIAL12           WXK_SPECIAL1 + 11
#define WXK_SPECIAL13           WXK_SPECIAL1 + 12
#define WXK_SPECIAL14           WXK_SPECIAL1 + 13
#define WXK_SPECIAL15           WXK_SPECIAL1 + 14
#define WXK_SPECIAL16           WXK_SPECIAL1 + 15
#define WXK_SPECIAL17           WXK_SPECIAL1 + 16
#define WXK_SPECIAL18           WXK_SPECIAL1 + 17
#define WXK_SPECIAL19           WXK_SPECIAL1 + 18
#define WXK_SPECIAL20           WXK_SPECIAL1 + 19

/* This enum contains bit mask constants used in wxKeyEvent */
#define wxMOD_NONE      0x0000
#define wxMOD_ALT       0x0001
#define wxMOD_CONTROL   0x0002
#define wxMOD_ALTGR     HB_BITOR( wxMOD_ALT, wxMOD_CONTROL )
#define wxMOD_SHIFT     0x0004
#define wxMOD_META      0x0008
#define wxMOD_WIN       wxMOD_META
#if defined(__WXMAC__) .OR. defined(__WXCOCOA__)
#define wxMOD_CMD       wxMOD_META
#else
#define wxMOD_CMD       wxMOD_CONTROL
#endif
#define wxMOD_ALL       0xffff

#endif
