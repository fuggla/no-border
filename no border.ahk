; Settings
#NoEnv
#Persistent
#SingleInstance Force
Version := 0.1
Global ScriptName = % A_ScriptName . " " . Version

; Tray menu
Menu, Tray, NoStandard
Menu, Tray, Add, % ScriptName, GuiTray
Menu, Tray, Default, % ScriptName
Menu, Tray, Click, 1
Menu, Tray, Add, Exit, GuiTray

; Create and populate ListView
Gui, Add, ListView, x5 y5 w690 h290 gListSubroutine, Title|Process|id
LV_ModifyCol(1, 550)
LV_ModifyCol(2, 136)
LV_ModifyCol(3, 0) ; Hide third column (id) in gui
FindWindows()
Gui, Show, w700 h300, % ScriptName
return

; Removes styles when user doubleclicks a list entry
ListSubroutine:
if (A_GuiEvent == "DoubleClick") {
	LV_GetText(id, A_EventInfo, 3)
	RemoveStyles(id)
}
return

; Hide gui instead of closing
GuiClose:
	Gui, Hide
return

; Refresh window list with hotkey F5
F5::
	FindWindows()
return

; Handle user input from tray menu
GuiTray(choice, position, menu) {
	if (choice == "Exit") {
		ExitApp
	}
	else if (choice == ScriptName) {
		Reload
	}
}

; Find all Windows and add them to ListView
FindWindows() {
	LV_Delete()
	WinGet, windows, List
	Loop, % windows
	{
		id := "ahk_id " . windows%A_Index%
		WinGetTitle, title, % id
		WinGet, exe, ProcessName, % title

		; Don't add windows without title and exe name
		; Don't add this gui window
		if ((title or exe) and title != ScriptName) {
			LV_Add(,title,exe,id)
		}
	}
}

; Remove all the styles
RemoveStyles(id) {
	WinSet, Style, -0x00C00000L, % id
	WinSet, Style, -0x00040000L, % id
	WinSet, Style, -0x20000000L, % id
	WinSet, Style, -0x01000000L, % id
	WinSet, Style, -0x00080000L, % id
	WinSet, Style, -0x00000200L, % id
	WinSet, Style, -0x00020000L, % id
	WinSet, Style, -0x00000001L, % id
	WinMove,  % id, , 0, 0, % A_ScreenWidth, % A_ScreenHeight ; Not sure how this will affect multiple monitors
	WinActivate, % id
}