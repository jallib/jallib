;-- Title: Jallib Full Installer
;-- Author: Matthew Schinkel, copyright (c) 2009, all rights reserved.
;-- Adapted-by:
;--
;-- This file is part of jallib (http://jallib.googlecode.com)
;-- Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)
;--
;-- Description: Installs the jallib release package with JalEdit and the Jalv2 compiler.
;--
;-- Sources:
;--
;-- Notes: - Edit the first parameter of the FileInstall lines for the included files, then compile.
;-- 	   - Compile this with AutoIT.
;--

FileInstall(	"files\7z.exe"					,@tempdir & "\7z.exe",1)
FileInstall(	"files\jaledit0.9.0.9.zip"		,@tempdir & "\jaledit.zip",1)
FileInstall(	"files\jallib-1.0.0.zip"		,@tempdir & "\jallib.zip",1)
FileInstall(	"files\jalv24q3.zip"			,@tempdir & "\jalv2.zip",1)

;includes
#include <GUIConstantsEx.au3>
#include <WinAPI.au3>
#include <Date.au3>
#include <Array.au3>
#include <File.au3>

;On event mode when clicking widgets
Opt("GUIOnEventMode", 1) ; Change to OnEvent mode

;Globals
Global $Width = 600
Global $Height = 300
Global $Step = 1
Global $Folder = "C:\Jallib\"
Local Const $Font2 = "Arial"
Local Const $Font1 = "Comic Sans Ms"

;Create the gui
$Title = "Jallib Full Installer"
Local $hMainGUI = GUICreate($Title, $width, $height)

;Create the gui widgets
$Logo = GUICtrlCreatePic ( "images/jal_logo.jpg", 5, 8,190,242)

Local $Group1 = GUICtrlCreateGroup("", 200, 0, 395, $height - 50)
   Local $Label1 = GUICtrlCreateLabel("Welcome to the Jallib Setup Wizard", 220, 25,370)
   GUICtrlSetFont(-1, 10, 700, 4, $Font1)

   Local $Label2 = GUICtrlCreateLabel("This wizard will guide you through installation of JalV2, Jallib and Jaledit.", 220, 75, 370,100)
   GUICtrlSetFont(-1, 9, 400, 0, $Font2)
GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group

Local $Group2 = GUICtrlCreateGroup("", 200, 0, 395, $height - 50)
   Local $Label3 = GUICtrlCreateLabel("Please choose an installation directory.", 220, 25,370)
   GUICtrlSetFont(-1, 10, 700, 4, $Font1)

   Local $InstallFolderInput = GUICtrlCreateInput($Folder, 220,75,190)

   Local $BrowseButton = GUICtrlCreateButton("Browse", 420, 75 -3, 60)
   GUICtrlSetOnEvent(-1, "BrowseButton")

   GUICtrlSetState($BrowseButton ,$GUI_HIDE)
   GUICtrlSetState($Label3 ,$GUI_HIDE)
   GUICtrlSetState($InstallFolderInput ,$GUI_HIDE)
GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group

Local $Group3 = GUICtrlCreateGroup("", 200, 0, 395, $height - 50)
   Local $Label4 = GUICtrlCreateLabel("Choose the options you would like to install.", 220, 25,370)
   GUICtrlSetFont(-1, 10, 700, 4, $Font1)

   Local $Checkbox1 = GUICtrlCreateCheckbox("Jallib Libraries", 220, 75, 370)
   GUICtrlSetFont(-1, 9, 400, 0, $Font2)
   Local $Checkbox2 = GUICtrlCreateCheckbox("Jalv2 Compiler", 220, 100, 370)
   GUICtrlSetFont(-1, 9, 400, 0, $Font2)
   Local $Checkbox3 = GUICtrlCreateCheckbox("JalEdit", 220, 125, 370)
   GUICtrlSetFont(-1, 9, 400, 0, $Font2)

   GUICtrlSetState($Label4 ,$GUI_HIDE)
   GUICtrlSetState($Checkbox1 ,$GUI_HIDE)
   GUICtrlSetState($Checkbox2 ,$GUI_HIDE)
   GUICtrlSetState($Checkbox3 ,$GUI_HIDE)

   guictrlsetstate($Checkbox1,$GUI_Checked)
   guictrlsetstate($Checkbox2,$GUI_Checked)
   guictrlsetstate($Checkbox3,$GUI_Checked)
GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group

Local $Group4 = GUICtrlCreateGroup("", 200, 0, 395, $height - 50)
   Local $Label5 = GUICtrlCreateLabel("Installing, Please wait...", 220, 25,370)
   GUICtrlSetFont(-1, 10, 700, 4, $Font1)

   Local $Label6 = GUICtrlCreateLabel("Unzip provided by 7ZIP (www.7-zip.org)", 220, 75,370)
   GUICtrlSetFont(-1, 9, 400, 0, $Font2)

   Local $Checkbox4 = GUICtrlCreateCheckbox("Start JalEdit Now.", 220, 75, 370)
   GUICtrlSetFont(-1, 9, 400, 0, $Font2)

   Local $Checkbox5 = GUICtrlCreateCheckbox("Open Installation Directory?", 220, 100, 370)
   GUICtrlSetFont(-1, 9, 400, 0, $Font2)

   GUICtrlSetState($Label5 ,$GUI_HIDE)
   GUICtrlSetState($Checkbox4 ,$GUI_HIDE)
   GUICtrlSetState($Checkbox5 ,$GUI_HIDE)
   GUICtrlSetState($Label6 ,$GUI_HIDE)
GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group

;BOTTOM BUTTON WIDGETS
;Local $BackButton = GUICtrlCreateButton("Back", $width - 240, $height - 40, 60)
;GUICtrlSetOnEvent(-1, "BackButton")

Local $NextButton = GUICtrlCreateButton("Next", $width - 160, $height - 40, 60)
GUICtrlSetOnEvent(-1, "NextButton")

Local $CancelButton = GUICtrlCreateButton("Cancel", $width - 80, $height - 40, 60)
GUICtrlSetOnEvent($CancelButton, "CLOSEButton")

GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEButton")

;Show the GUI
GUISetState(@SW_SHOW, $hMainGUI)
GUICtrlSetState($NextButton, $GUI_FOCUS)
WinSetOnTop($hMainGUI, "", 1)

Main()

Func Main()
EndFunc

While 1
    Sleep(100) ; Sleep to reduce CPU usage
WEnd

Func NextButton()
   ;$Step 1

   If ($Step == 1) Then
	  GUICtrlSetState($Group1 ,$GUI_HIDE)
	  GUICtrlSetState($Label1 ,$GUI_HIDE)
	  GUICtrlSetState($Label2 ,$GUI_HIDE)

	  GUICtrlSetState($Label4 ,$GUI_SHOW)
	  GUICtrlSetState($Checkbox1 ,$GUI_SHOW)
	  GUICtrlSetState($Checkbox2 ,$GUI_SHOW)
	  GUICtrlSetState($Checkbox3 ,$GUI_SHOW)
   EndIf

   If ($Step == 2) Then

	  GUICtrlSetState($Label4 ,$GUI_HIDE)
	  GUICtrlSetState($Checkbox1 ,$GUI_HIDE)
	  GUICtrlSetState($Checkbox2 ,$GUI_HIDE)
	  GUICtrlSetState($Checkbox3 ,$GUI_HIDE)

	  GUICtrlSetState($Label3 ,$GUI_SHOW)
	  GUICtrlSetState($InstallFolderInput ,$GUI_SHOW)
	  GUICtrlSetState($BrowseButton ,$GUI_SHOW)
   EndIf

   If ($Step == 3) Then
	  Local $DirCreated = 0
	  Local $Continue = 0

	  $Folder = GUICtrlRead($InstallFolderInput)
	  If Not(FileExists($Folder)) Then
		 WinSetOnTop($hMainGUI, "", 0)
		 $Answer = MsgBox(4 + 0x40000,"Warning!", "The directory does not exist, would you like to create it?")

		 If $Answer == 6 Then ; If Yes
			DirCreate($Folder)
			$DirCreated = 1
			$Continue = 1
		 Else
			$DirCreated = 0
			$Continue = 0
			$Step = $Step - 1
		 EndIf
		 WinSetOnTop($hMainGUI, "", 1)
	  Else

		 If (FileExists($Folder & "sample")) Or (FileExists($Folder & "\sample")) Or (FileExists($Folder & "lib")) Or (FileExists($Folder & "\lib")) Then
			If $DirCreated == 0 Then
			   WinSetOnTop($hMainGUI, "", 0)
			   $Answer = MsgBox(4 + 0x40000,"Warning!", "An installation exists in this directory, are you sure you wish to overwrite your previous installation?")
			   If $Answer == 6 Then
				  $Continue = 1
			   Else
				  $Continue = 0
				  $Step = $Step - 1
			   EndIf
			   WinSetOnTop($hMainGUI, "", 1)
			Else
			   $Continue = 1
			EndIf

		 Else
			$Continue = 1
		 EndIf

	  EndIf

	  if $Continue == 1 Then
		 GUICtrlSetState($Label3 ,$GUI_HIDE)
		 GUICtrlSetState($InstallFolderInput ,$GUI_HIDE)
		 GUICtrlSetState($BrowseButton ,$GUI_HIDE)
		 GUICtrlSetState($Label5 ,$GUI_SHOW)
		 GUICtrlSetState($Label6 ,$GUI_SHOW)

		 if (GUICtrlRead($Checkbox2) == 1) Then
			RunWait(@tempdir & '\7z.exe x -y "' & @tempdir & '\jalv2.zip" -o"' & $Folder & "\compiler" & '"')
		 EndIf

		 if (GUICtrlRead($Checkbox1) == 1) Then
			RunWait(@tempdir & '\7z.exe x -y "' & @tempdir & '\jallib.zip" -o"' & $Folder & '"')
		 EndIf

		 if (GUICtrlRead($Checkbox3) == 1) Then
			RunWait(@tempdir & '\7z.exe x -y "' & @tempdir & '\jaledit.zip" -o"' & $Folder & "\jaledit" & '"')

			$libfolder = $Folder & "\lib"
			$libfolder = StringReplace($libfolder, "\\", "\")
			IniWrite($folder & "\jaledit\JALEdit.ini", "Compiler", "deLibPath_Text", $libfolder)

			$CompilerFolder = FindNewestFolder($Folder & "\compiler")
			if ($CompilerFolder == -1) Then
			   MsgBox(16, "Error", 'Failed to set the JalEdit compiler directory. You will need to set it manually in JalEdit at "Tools" -> "Environment Options"')
			EndIf
			IniWrite($folder & "\jaledit\JALEdit.ini", "Compiler", "feJALExe_Text", $Folder & "compiler\" & $CompilerFolder & "\bin\jalv2.exe")

		 ;add shortcuts
		 consolewrite (FileCreateShortcut($Folder & "\jaledit\jaledit.exe", @DesktopDir & "\JalEdit.lnk", $Folder & "\jaledit\"))
		 DirCreate(@StartMenuDir & "\JalEdit")
		 consolewrite (FileCreateShortcut($Folder & "\jaledit\jaledit.exe", @StartMenuDir & "\JalEdit\JalEdit.lnk", $Folder & "\jaledit\"))
		 EndIf

		 GUICtrlSetData($Label5, "Installation is complete!")
		 GUICtrlSetData($NextButton, "Finnish")
		 GUICtrlSetState($CancelButton ,$GUI_HIDE) ; hide the cancel button

		 if (GUICtrlRead($Checkbox3) == 1) Then
			guictrlsetstate($Checkbox4,$GUI_Checked)
			GUICtrlSetState($Checkbox4 ,$GUI_SHOW)
			GUICtrlSetState($Checkbox5 ,$GUI_SHOW)
			guictrlsetstate($Checkbox5,$GUI_Checked)
			GUICtrlSetState($Label6 ,$GUI_HIDE)
		 EndIf
	  EndIf

   EndIf

   If ($Step == 4) Then

	  if (GUICtrlRead($Checkbox4) == 1) Then
		 run($Folder & "\jaledit\jaledit.exe")
		 WinWaitActive("JAL Edit", "", 10)
	  EndIf
	  if (GUICtrlRead($Checkbox5) == 1) Then
		 run("Explorer.exe " & $Folder)
	  EndIf
	  Exit
   EndIf


   $Step = $Step + 1
EndFunc


Func BrowseButton()
   ;WinSetOnTop($hMainGUI, "", 1)
   $folder = FileSelectFolder("Select an Installation Directory", "", "", "",  $hMainGUI)
   GUICtrlSetData($InstallFolderInput, $folder)
   ;WinSetOnTop($hMainGUI, "", 1)
EndFunc

Func CLOSEButton()
    Exit
 EndFunc   ;==>CLOSEButton

 Func FindNewestFolder($Folder)
    $avFiles = _FileListToArray($Folder & "\", "*",2)
    If @Error<>0 Then
        Return
	 EndIf

    $iNewestTime = 11111111111111; YYYYMMDDhhmmss
    $iNewestIndex = 0; Array index of newest file

    For $p = 1 To $avFiles[0]
        $iFileTime2 = Number(FileGetTime($Folder & "\" & $avFiles[$p], 0, 1))
        If $iFileTime2 > $iNewestTime Then
            $iNewestTime = $iFileTime2
            $iNewestIndex = $p
        EndIf
    Next

    If Not($iNewestIndex > 0) Then
        return -1
	 EndIf

	 ConsoleWrite($avFiles[$iNewestIndex])
    return $avFiles[$iNewestIndex]
 EndFunc
