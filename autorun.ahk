#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%

SetTitleMatchMode 2
DetectHiddenWindows On
DetectHiddenTexT On

Dir := "autorun"
Loop %Dir%\*.ahk
	If !WinExist(A_LoopFileName)
		Run % A_LoopFileFullPath