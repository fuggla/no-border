; Settings
#NoEnv
#Persistent
#SingleInstance Force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
Version := 0.1
ScriptName = % A_ScriptName . " " Version

Menu, Tray, NoStandard
Menu, Tray, add, Exit, GuiTray

; Create ListView
Gui, Add, ListView, x5 y5 w690 h290 gListSubroutine, Title|Process|id
LV_ModifyCol(1, 550)
LV_ModifyCol(2, 136)
LV_ModifyCol(3, 0) ; Hide column id from user
FindWindows()
Gui, Show, w700 h300, % ScriptName
return

; Triggers on list interaction
ListSubroutine:
if (A_GuiEvent == "DoubleClick") {
	LV_GetText(id, A_EventInfo, 3)
	; Kill all the styles
	WinSet, Style, -0x00C00000L, % id
	WinSet, Style, -0x00040000L, % id
	WinSet, Style, -0x20000000L, % id
	WinSet, Style, -0x01000000L, % id
	WinSet, Style, -0x00080000L, % id
	WinSet, Style, -0x00000200L, % id
	WinSet, Style, -0x00020000L, % id
	WinSet, Style, -0x00000001L, % id
	WinMove,  % id, , 0, 0, % A_ScreenWidth, % A_ScreenHeight ; What about multiple monitors though?
	WinActivate, % id
}
return

GuiClose:
ExitApp

; Refresh window list
F5::
	FindWindows()
return

; Handle user input from tray menu
GuiTray(choice, position, menu) {
	if (choice = "Exit") {
		ExitApp
	}
	else if (choice == "Reload") {
		Reload
	}
}

; Find all Windows and add them to ListView
FindWindows() {
	LV_Delete()
	WinGet, Windows, List
	Loop, %Windows%
	{
		id := "ahk_id " . Windows%A_Index%
		WinGetTitle, title, % id
		WinGet, exe, ProcessName, % title

		; Only add windows the user can identify
		if (title or exe) {
			LV_Add(,title,exe,id)
		}
	}
}