/*
 * $Id$
 */

/*
    wxHarbour: a portable GUI for [x]Harbour Copyright (C) 2009 Teo Fonrouge

    This library is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    (C) 2009 Teo Fonrouge <teo@windtelsoft.com>
*/

#include "hbclass.ch"
#include "property.ch"
#include "wx.ch"
#include "wxhevtdefs.h"

/*
    wxEvtHandler
    Teo. Mexico 2009
*/
CLASS wxEvtHandler FROM wxObject
PRIVATE:
    DATA FEventList INIT HB_HSetCaseMatch( {=>}, .F. )
    DATA FEventTypeValue
PROTECTED:
PUBLIC:
    METHOD ConnectActivateEvt( p1, p2, p3, p4 )
    METHOD ConnectCloseEvt( p1, p2, p3, p4 )
    METHOD ConnectCommandEvt( p1, p2, p3, p4 )
    METHOD ConnectFocusEvt( p1, p2, p3, p4 )
    METHOD ConnectGridEvt( p1, p2, p3, p4 )
    METHOD ConnectInitDialogEvt( p1, p2, p3, p4 )
    METHOD ConnectKeyEvt( p1, p2, p3, p4 )
    METHOD ConnectMenuEvt( p1, p2, p3, p4 )
    METHOD ConnectMouseEvt( p1, p2, p3, p4 )
    METHOD ConnectNotebookEvt( p1, p2, p3, p4 )
    METHOD ConnectSocketEvt( p1, p2, p3, p4 )
    METHOD ConnectTaskBarIconEvt( p1, p2, p3, p4 )
    METHOD ConnectTimerEvt( p1, p2, p3, p4 )
    METHOD ConnectUpdateUIEvt( p1, p2, p3, p4 )
PUBLISHED:
ENDCLASS

/*
    End Class wxEvtHandler
*/
