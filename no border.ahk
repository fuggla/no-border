/*
	no border.ahk
		Description:
			Changes a windowed program to borderless fullscreen
			<github.com/owlnical/no-border>

		Usage:
			Run a program in windowed mode. Run no border and double click on the program in the list.

		License:
			no border
			Copyright (C) 2017 Fred Uggla

			This program is free software; you can redistribute it and/or modify
			it under the terms of the GNU General Public License as published by
			the Free Software Foundation; either version 2 of the License, or
			(at your option) any later version.

			This program is distributed in the hope that it will be useful,
			but WITHOUT ANY WARRANTY; without even the implied warranty of
			MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
			GNU General Public License for more details.

			You should have received a copy of the GNU General Public License along
			with this program; if not, write to the Free Software Foundation, Inc.,
			51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/

; Settings
#NoEnv
#Persistent
#SingleInstance Force
Version := 0.2
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