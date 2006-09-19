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

#define wxID_NONE            -3
#define wxID_SEPARATOR       -2
#define wxID_ANY             -1

#define wxID_LOWEST        4999
#define wxID_OPEN          5000
#define wxID_CLOSE         5001
#define wxID_NEW           5002
#define wxID_SAVE          5003
#define wxID_SAVEAS        5004
#define wxID_REVERT        5005
#define wxID_EXIT          5006

#define wxITEM_SEPARATOR     -1
#define wxITEM_NORMAL         0
#define wxITEM_CHECK          1
#define wxITEM_RADIO          2
#define wxITEM_MAX            3

// Orientation
#define wxHORIZONTAL    0x0004
#define wxVERTICAL      0x0008
#define wxBOTH          wxVERTICAL | wxHORIZONTAL

/* Standard button and menu IDs */
#define wxID_OK         5100
#define wxID_CANCEL     5101

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

#define wxALL     ( wxUP | wxDOWN | wxRIGHT | wxLEFT )

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

#define wxALIGN_CENTER              (wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL)
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



















