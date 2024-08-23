#Requires AutoHotkey v2
#SingleInstance force
#UseHook True
ProcessSetPriority "High"

keyReplacements := Map()
;keyReplacements["w"] := "NumpadUp"
;keyReplacements["a"] := "NumpadLeft"
;keyReplacements["s"] := "NumpadDown"
;keyReplacements["d"] := "NumpadRight"

;	returns alternate key if there is one assigned
GetAltKey(key){
	return keyReplacements.Has(key) ? keyReplacements[key] : key
}

processName := "cs2.exe"
;processPath := ProcessGetPath(processName)
;	if the game supports -hijack as a launch param, or something similar, try doing that instead of messing with keyinputs.

keysPressedFwd := Array()	;	This is for forwards and backwards
keysPressedSdw := Array()	;	This is for left and right

#HotIf WinActive("ahk_exe " processName)
~*w::KeyPressed(		GetAltKey("w"), keysPressedFwd)
~*w up::KeyReleased(	GetAltKey("w"), keysPressedFwd)

~*s::KeyPressed(		GetAltKey("s"), keysPressedFwd)
~*s up::KeyReleased(	GetAltKey("s"), keysPressedFwd)

~*a::KeyPressed(		GetAltKey("a"), keysPressedSdw)
~*a up::KeyReleased(	GetAltKey("a"), keysPressedSdw)

~*d::KeyPressed(		GetAltKey("d"), keysPressedSdw)
~*d up::KeyReleased(	GetAltKey("d"), keysPressedSdw)

;	called when a key is physically pressed
KeyPressed(key, keysPressed){
	if (FindKey(key, keysPressed) > 0){	;	the key has already been pressed, hotkey shitness
		return
	}
	;Sleep(Random(0, 3) * 10)	;	for cs2, avoids getting detected by anticheat
	
	ClearKeys(keysPressed)
	keysPressed.Push(key)
	SendKey(key)
}

;	called when a key is physically released
KeyReleased(key, keysPressed){
	ReleaseKey(key)
	
	keyIndex := FindKey(key, keysPressed)
	while (keyIndex > 0){
		keysPressed.RemoveAt(keyIndex)
		keyIndex := FindKey(key, keysPressed)
	}
	
	if (keysPressed.Length > 0){
		SendKeyEx(keysPressed.Get(keysPressed.Length))
	}
}

ClearKeys(keysPressed){
	for key in keysPressed{
		ReleaseKey(key)
	}
}

FindKey(key, keysPressed){
	for k in keysPressed
		if (k == key)
			return A_Index
	return 0
}

;	Extended functionality of SendKey that prevents the pressing of unheld keys & double pressing of keys.
SendKeyEx(key){
	if (GetKeyState(key)){
		return
	}
	SendKey(key)
}

SendKey(key){
	Send "{" key " down}"
}

ReleaseKey(key){
	Send "{" key " up}"
}
