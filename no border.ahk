﻿; Settings
#NoEnv
#Persistent
#SingleInstance Force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Create ListView
Gui, Add, ListView, x5 y5 w690 h290 gListSubroutine, Title|Process|id
LV_ModifyCol(1, 550)
LV_ModifyCol(2, 136)
LV_ModifyCol(3, 0) ; Hide column id from user

; Find all Windows and add them to ListView
WinGet,Windows,List
Loop,%Windows%
{
	id := "ahk_id " . Windows%A_Index%
	WinGetTitle, title, % id
	WinGet, exe, ProcessName, % title
	
	; Only add windows the user can identify
	if (title or exe) {
		LV_Add(,title,exe,id)
	}
}
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