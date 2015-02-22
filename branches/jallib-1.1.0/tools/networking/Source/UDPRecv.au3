;;This is the UDP Server
;;Start this first

#Include <Array.au3>
HotKeySet("{ESC}", "quit")

; Start The UDP Services
;==============================================
UDPStartup()

; Register the cleanup function.
OnAutoItExitRegister("Cleanup")

; Bind to a SOCKET
;==============================================
$Socket = UDPBind(@IPAddress1, 251)

dim $x = 0
While 1
	;get UDP data from client
    $Data = UDPRecv($Socket, 50,3)
	
    If IsArray($Data) Then
		
		;print a message to console
		ConsoleWrite("#" & $x & " ")
		ConsoleWrite("Received: " & BinaryToString($Data[0]))
		ConsoleWrite(@CRLF)
		$x = $x + 1
		
		;create temp socket from incomming IP/PORT
		$SocketIn = UDPOpen($Data[1], $Data[2])
				
		;print a message to console and send a reply message
		ConsoleWrite("Sending reply: Hello Client!")
		$status = UDPSend($SocketIn, "Hello Client!     ") 
		If $status = 0 then
			MsgBox(0, "ERROR", "Error while sending UDP message: " & @error)
			Exit
		EndIf
		
		;remove temp socket
		UDPCloseSocket($SocketIn)
		$Data[0] = 0
		
		ConsoleWrite(@CRLF)
		ConsoleWrite(@CRLF)
    EndIf
    sleep(100)
WEnd

Func quit()
    UDPCloseSocket($Socket)
    UDPShutdown()
	exit
EndFunc


