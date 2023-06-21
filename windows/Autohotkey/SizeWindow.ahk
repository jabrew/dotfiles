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

action = %1%


; start C:\Users\Brew\Documents\Autohotkey\SizeWindow.ahk windowPosition cur center top 300 600
if (action = "windowPosition") {
  target = %2%
  h_pos = %3%
  v_pos = %4%
  width = %5%
  height = %6%
  h_offset = %7%
  if (target != "cur") {
    MsgBox "Only support current window"
    Exit -1
  }

  if (h_pos != "center") {
    MsgBox "Only support h_pos center"
    Exit -1
  }
  if (v_pos != "top") {
    MsgBox "Only support v_pos top"
    Exit -1
  }

  DesktopScreenCoordinates(x_min, y_min, x_max, y_max)
  win_x := (x_max - x_min - width) / 2 + h_offset
  win_y := y_min
  WinMove, A,, win_x, win_y, width, height
  ; MsgBox Moved %win_x% %win_y%
} else if (action = "windowInfo") {
  target = %2%
  if (target != "cur") {
    MsgBox "Only support current window"
    Exit -1
  }

  WinGetPos, pos_x, pos_y, width, height, A
  WinGetTitle, title, A
  MsgBox Active window '%title%' at (%pos_x%`, %pos_y%) size (%width%`, %height%)
} else if (action = "desktopInfo") {
  DesktopScreenCoordinates(x_min, y_min, x_max, y_max)
  MsgBox Desktop min: (%x_min%`, %y_min%)`, max: (%x_max%`, %y_max%)
} else if (action = "tmp_ignore") {
  MsgBox Unrecognized action %action%
  Exit -1
} else {
  MsgBox Unrecognized action %action%
  Exit -1
}
; nnoremap <silent> <Leader>wn :silent !hs -c "windowPosition('cur', 'center', 'top', 1057, 824, -139)"<CR>
