/*
    $Id$
*/

#include "wxharbour.ch"

/*
	TBasicBrowse : a browse with basic features
*/
CLASS TBaseBrowse FROM wxhBrowse
PRIVATE:
PROTECTED:
PUBLIC:
	METHOD OnCreate()
PUBLISHED:
ENDCLASS

/*
	OnCreate
*/
METHOD PROCEDURE OnCreate() CLASS TBaseBrowse

	Super:OnCreate()
	
	::ConnectGridEvt( ::GetId(), wxEVT_GRID_LABEL_LEFT_DCLICK, {|gridEvent| gridEvent:GetEventObject():AutoSizeColumns( .F. )  } )

RETURN
