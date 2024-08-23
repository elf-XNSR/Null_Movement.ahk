#Requires AutoHotkey v2
#SingleInstance force
#UseHook True
ProcessSetPriority "High"

keysPressedFwd := Array()	;	This is for forwards and backwards
keysPressedSdw := Array()	;	This is for left and right

#HotIf WinActive("ahk_exe cs2.exe")
*w::KeyPressed("w", keysPressedFwd)
*w up::KeyReleased("w", keysPressedFwd)
*s::KeyPressed("s", keysPressedFwd)
*s up::KeyReleased("s", keysPressedFwd)
*a::KeyPressed("a", keysPressedSdw)
*a up::KeyReleased("a", keysPressedSdw)
*d::KeyPressed("d", keysPressedSdw)
*d up::KeyReleased("d", keysPressedSdw)

;	called when a key is physically pressed
KeyPressed(key, keysPressed){
	if (FindKey(key, keysPressed) > 0){	;	the key has already been pressed, hotkey shitness
		return
	}
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
	if (!GetKeyState(key, "P") || GetKeyState(key)){
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
