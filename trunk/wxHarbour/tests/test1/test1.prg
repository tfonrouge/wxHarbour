
#include "hbclass.ch"

FUNCTION Main
  LOCAL i

  MyFunc1()

  FOR i:=1 TO 10000
  NEXT

  ? "Exiting..."

RETURN NIL

STATIC FUNCTION MyFunc1
  LOCAL ipv4
  LOCAL socketServer,socket
  LOCAL nsecs

  nsecs := 5

  ipv4 := wxIPV4Address():New()
//   ipv4:Hostname( "localhost" )
  ipv4:Service( "2000" )
  ? ipv4:IPAddress(), ipv4:Service()

  socketServer := wxSocketServer():New( ipv4 )

  ? "Waiting for a connection (" + LTrim( Str( nsecs ) ) +  ")"
  socketServer:SetTimeOut( nsecs )

  ? "Looping."

  socket := socketServer:Accept( .T. )

  IF socket != NIL
    ? "Connection made."
  ELSE
    ? "Connection failed."
  ENDIF

  ? socket:ClassName()

  Class1():New()

RETURN NIL

CLASS Class1
  DESTRUCTOR OnDestruct
ENDCLASS

PROCEDURE OnDestruct CLASS Class1
  ? "Destroying:",::ClassName()
RETURN
