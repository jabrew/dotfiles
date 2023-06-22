#SingleInstance force

return

RAlt & E::Send (
RAlt & R::Send )
RAlt & C::Send {{}
RAlt & V::Send {}}
RAlt & G::Send ^U
RAlt & B::Send ^D
RAlt & D::Send ^P
RAlt & F::Send ^N
RAlt & T::Send ^\
Scrolllock & E::Send (
Scrolllock & R::Send )
Scrolllock & C::Send {{}
Scrolllock & V::Send {}}
Scrolllock & G::Send ^U
Scrolllock & B::Send ^D
Scrolllock & D::Send ^P
Scrolllock & F::Send ^N
Scrolllock & T::Send ^\

Scrolllock::RAlt

#J::Reload

is_down := false
got_key := false

; ; LWin::Send #n
; ; ~LWin::Send #n
; ; $LWin::
; ; KeyWait
; ; $LWin::
; ;     KeyWait, LWin, T0.15
; ;     If !ErrorLevel ; if you hold the LWin key for less than 200 miliseconds...
; ;         Send, #n ; ...send ctrl+alt+r[/color]
; ;     Else ; but if it is held for more than that...[/color]
; ;         Send, {LWin Down} ; ...hold LWin down[/color]
; ;     KeyWait, LWin ; and, in both cases, wait for it to be released[/color]
; ;     Send, {LWin Up}
; ; Return
;
; *LWin UP::
; is_down := false
; Input,
; If (ErrorLevel = 0) {
;   ; Terminated prior input
;   if (!got_key) {
;     OutputDebug, Up without key
;     Send, #n
;   } else {
;     OutputDebug, Up after key
;   }
;   Return
; } Else {
;   OutputDebug, Up no term
;   Return
; }
;
; *LWin::
; if (is_down) {
;   Return
; }
;
; is_down := true
; got_key := false
;
; OutputDebug, Down
; Loop {
;   Input, text, L1 T0.3
;   If (ErrorLevel = "NewInput") {
;     OutputDebug, Down term '%ErrorLevel%'
;     break
;   } Else If (ErrorLevel = "Timeout") {
;     ; Send, {LWin Down}
;     if (is_down) {
;       OutputDebug, Still down
;     } else {
;       OutputDebug, Down timeout
;       break
;     }
;   } Else {
;     got_key := true
;
;     OutputDebug, Down text '%text%'
;     OutputDebug, Down el '%ErrorLevel%'
;     if (text = "x") {
;       OutputDebug, Tx
;       Send #1
;     } else if (text = "s") {
;       OutputDebug, Ts
;       IfWinExist ahk_class Vim
;           WinActivate
;     } else {
;       OutputDebug, To
;       Send #%text%
;     }
;     ; break
;   }
; }
; Return

;
; Mouse wheel gestures
;

;RButton::
;; or WinActive("ahk_class MozillaWindowClass")
;if WinActive("ahk_class Chrome_WidgetWin_1") {
;
;} else {
;    Send {RButton Down}
;}
;return

;*WheelUp::
;GetKeyState, state, RButton, P
;if (state = D) {
;    SendInput ^{Tab}
;} else {
;    SendInput {WheelUp}
;}
;return

;RButton & WheelDown::
;SendInput ^{Tab}
;return
;
;RButton & WheelUp::
;SendInput ^+{Tab}
;return

;
; Window Manipulation
;

; Center the active window horizontally, put it at the top vertically
#PgDn::
SysGet, Desktop, MonitorWorkArea
;Desktop_Left, Right, Top, Bottom
WinGetPos, x, y, width, height, A
centerX := DesktopLeft + (DesktopRight / 2 - width / 2)
centerY := DesktopTop + (DesktopBottom / 2 - height / 2)
WinMove, A,, %centerX%, %DesktopTop%
return

#PgUp::
; Make the window 1280 pixels wide, center it (if the desktop is over 1280 pixels)
SysGet, Desktop, MonitorWorkArea
width := DesktopRight - DesktopLeft
if (width > 1280)
{
    height := DesktopBottom - DesktopTop

    centerX := DesktopLeft + (DesktopRight / 2 - 1280 / 2)
    centerY := DesktopTop + (DesktopBottom / 2 - height / 2)
    WinMove, A,, %centerX%, %DesktopTop%, 1280, %height%
}
return

#End::
; Make the window 1380 pixels wide, center it (if the desktop is over 1380 pixels)
SysGet, Desktop, MonitorWorkArea
width := DesktopRight - DesktopLeft
if (width > 1380)
{
    height := DesktopBottom - DesktopTop

    centerX := DesktopLeft + (DesktopRight / 2 - 1380 / 2)
    centerY := DesktopTop + (DesktopBottom / 2 - height / 2)
    WinMove, A,, %centerX%, %DesktopTop%, 1380, %height%
}
return

Capslock::Esc

;
; Programs
;

; <!a::MsgBox Test left alt
; >!a::MsgBox Test right alt

; LWin::SendEvent {Browser_Home}

#x::
>!x::
Send #1
return

#`::
>!`::
Send #2
return

#a::Send #+a

#S::
>!S::
; IfWinExist ahk_class Vim
;     WinActivate
; return
; IfWinExist ahk_class Qt5QWindowIcon
IfWinExist ahk_exe nvim-qt.exe
    WinActivate
return

#Q::
>!Q::
IfWinExist ahk_exe Discord.exe
    WinActivate
return

#Up::
SendInput, {WheelUp}
return

#Down::
SendInput, {WheelDown}
return

#Left::
SendInput, {MButton}
return

#Include Layout.ahk

; Games
; #G::Run, D:\Games\Guild Wars\Gw.exe                         ; Guild wars
; #H::Run, D:\Games\League of Legends Game\lol.launcher.exe   ; League of Legends
; #K::Run, D:\Programs\Internet\ventrilo-3.0.7-Windows-x64\Ventrilo.exe ; Vent
