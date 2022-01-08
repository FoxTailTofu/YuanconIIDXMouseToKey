#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; default: 
; enable => press F9
; toggle on/off => press F8
; you can change keybinds by youself, I think you can figure it out :)

; how long it need to wait before scratch from same direction can be triggered again (ms)
global DEBOUNCE_TIMER := 16
global KEY_PRESS_1 := "o"
global KEY_PRESS_2 := "p"

global timer := 0
F9::
    MouseGetPos, X2, 
    premark := DX > 0 ? 1 : DX < 0 ? -1 : 0
    while ( true ) {
        MouseGetPos, X1, Y1
        DX := X1-X2
        mark := DX > 0 ? 1 : DX < 0 ? -1 : 0

        if (mark <> premark) {
            if (DX > 0 ) {
                PressKey(KEY_PRESS_1)
            } else if (DX < 0 ) {
                PressKey(KEY_PRESS_2)
            } else {
                PressKey("no")
            }
        }

        premark := mark
        X2 := X1
        timer := timer - 1
        Sleep 1
    }

Return

F8::
    pause
    suspend
Return

PressKey(Key := "no")
{
    static press := "no"
    static prePress := "no"
    if (Key <> "no") {
        if ( press <> "no" ) {
            Send, {%press% up}
			Sleep, 1
        }
        if (prePress = Key and timer > 0) {
            Return
        }
        Send, {%Key% down}
        timer := DEBOUNCE_TIMER 
        prePress := Key
    } else {
        Send, {%press% up}
    }

    press := key
}

