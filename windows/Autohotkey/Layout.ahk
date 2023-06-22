; Note: Can potentially use e.g. SM_CXMAXIMIZED, but still doesn't get us the origin. For now, just hack it (taskbar is 30px)
DesktopScreenCoordinates(byref x_min, byref y_min, byref x_max, byref y_max) {
  SysGet, x_min, 76  ; XVirtualScreenleft   ; left side of virtual screen
  SysGet, y_min, 77 ; YVirtualScreenTop  ; Top side of virtual screen
  taskbar_height = 30
  y_min += taskbar_height

  SysGet, VirtualScreenWidth, 78
  SysGet, VirtualScreenHeight, 79

  x_max := x_min + VirtualScreenWidth
  y_max := y_min + VirtualScreenHeight - taskbar_height
  return
}

MoveTopCenter(byref win, byref width, byref height, byref h_offset) {
  DesktopScreenCoordinates(x_min, y_min, x_max, y_max)
  win_x := (x_max - x_min - width) / 2 + h_offset
  win_y := y_min
  WinMove, ahk_id %win%,, win_x, win_y, width, height
}

MoveEachTopCenter(byref query, byref width, byref height, byref h_offset) {
  WinGet, active_ids, list, %query%
  Loop, %active_ids% {
    val := active_ids%A_Index%
    MoveTopCenter(val, width, height, h_offset)
  }
}

MoveTopRight(byref win, byref width, byref height) {
  DesktopScreenCoordinates(x_min, y_min, x_max, y_max)
  win_x := x_max - width
  win_y := y_min
  WinMove, ahk_id %win%,, win_x, win_y, width, height
}

MoveEachTopRight(byref query, byref width, byref height) {
  WinGet, active_ids, list, %query%
  Loop, %active_ids% {
    val := active_ids%A_Index%
    MoveTopRight(val, width, height)
  }
}

^#X::
MoveEachTopCenter("ahk_exe nvim-qt.exe", 1186, 963, -156)
; MoveEachTopCenter("ahk_exe firefox.exe", 1360, 1024, 0)
MoveEachTopCenter("ahk_exe firefox.exe", 1450, 1050, 0)
; OneNote slightly changes the window sizes
MoveEachTopCenter("ahk_exe onenote.exe", 1350, 1018, 0)
MoveEachTopRight("ahk_exe discord.exe", 1164, 780)
MoveEachTopCenter("ahk_exe ConEmu64.exe ahk_class VirtualConsoleClass", 992, 959, 0)
; WinGet, active_ids, list, ahk_exe nvim-qt.exe
; MoveEachTopCenter(active_ids, 1186, 963, -156)
; Loop, %active_ids% {
;   val := active_ids%A_Index%
;   MoveTopCenter(val, 1186, 963, -156)
;   ; MsgBox, % "ahk_id" active_ids%A_Index%
; }
; List := [1, 2, 3]
; for key, val in List
;   MsgBox %val%

; Loop, %active_ids% {
  ; MoveTopCenter(% active_ids%A_Index%, 1280, 1024, 0)
; }
; {
; 	WinActivate, % "ahk_id" myList%A_Index%
; }
; WinGet, active_id, ID, ahk_exe nvim-qt.exe
; MoveTopCenter(active_id, 1280, 1024, 0)
return
