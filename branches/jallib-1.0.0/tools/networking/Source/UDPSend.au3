;;This is the UDP Client
;;Start the server first

HotKeySet("{ESC}", "quit")

; Start The UDP Services
;==============================================
UDPStartup()

; Register the cleanup function.
OnAutoItExitRegister("quit")
 
; Open a "SOCKET"
;==============================================
;$socket = UDPOpen("192.168.2.1", 251) 
$socket = UDPOpen("192.168.0.60", 111) 
If @error <> 0 Then Exit

$n=0
While 1 
    Sleep(1000)
    $n = $n + 1

	;send some UDP data
	ConsoleWrite("Sending: Hello Server!")
	ConsoleWrite(@CRLF)
    $status = UDPSend($socket, "Hello Server!     " & $n) ;should be min of 18 bytes
	ToolTip($n)
    If $status = 0 then
        MsgBox(0, "ERROR", "Error while sending UDP message: " & @error)
        Exit
    EndIf
	
	;receive UDP data
    $data = UDPRecv($socket, 50)
    If $data <> "" Then
		ConsoleWrite("Received: " & $data)
	    ConsoleWrite(@CRLF)
    EndIf
	
	ConsoleWrite(@CRLF)
WEnd

Func Quit()
    UDPCloseSocket($socket)
    UDPShutdown()
	Exit
EndFunc
