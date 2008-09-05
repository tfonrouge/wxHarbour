/*
  xdoutils
  Teo. Mexico 2007
*/

#include "hbapi.h"
#include "hbdate.h"

/*
*/
HB_FUNC ( DATETIMESTAMPSTR )
{
  LONG lJulian = 0, lSeconds = 0;
  char szBuffer[24];

  if (hb_pcount() == 0 )
    hb_dateTimeStamp( &lJulian, &lSeconds );

  hb_dateTimeStampStr( szBuffer, lJulian, lSeconds );
  hb_retc( szBuffer );
}
