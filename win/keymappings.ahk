#SingleInstance, Force ;

; capslock is esc
Capslock::Esc
return

; å
RAlt & [::
Keywait, [
Send {U+00E5}
return

; ä
RAlt & '::
Keywait, ', D
Send {U+00E4}
return

; ö
RAlt & `;::
Keywait, `;, D
Send {U+00F6}
return


#If GetKeyState("RAlt", "P")
; Å
Shift & [::
Keywait, [, D
Send {U+00C5}
return

; Ä
Shift & '::
Keywait, ', D
Send {U+00C4}
return

; Ö
Shift & `;::
Keywait, `;, D
Send {U+00D6}
return

#if
