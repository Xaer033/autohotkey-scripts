#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

F1::ToggleTerminal()

ShowAndPositionTerminal()
{

    activeMonitorIndex := MWAGetMonitorMouseIsIn() 
    ; SysGet, activeMonitor, Monitor, %activeMonitorIndex%
    SysGet, WorkArea, MonitorWorkArea, %activeMonitorIndex%

    monitorWidth := Abs(WorkAreaRight - WorkAreaLeft)
    monitorHeight := Abs(WorkAreaTop - WorkAreaBottom) 

    TerminalWidth := Min(monitorWidth * 0.80, 1900)



    xPos := WorkAreaLeft + (monitorWidth - TerminalWidth) / 2
    yPos := WorkAreaTop - 2
    tWidth := TerminalWidth
    tHeight := monitorHeight * 0.5


    WinShow ahk_class CASCADIA_HOSTING_WINDOW_CLASS
    WinMove, ahk_class CASCADIA_HOSTING_WINDOW_CLASS,, xPos, yPos, tWidth, tHeight
    WinActivate ahk_class CASCADIA_HOSTING_WINDOW_CLASS
    ; WinRestore, ahk_class CASCADIA_HOSTING_WINDOW_CLASS 
}

ToggleTerminal()
{
    WinMatcher := "ahk_class CASCADIA_HOSTING_WINDOW_CLASS"

    DetectHiddenWindows, On

    if WinExist(WinMatcher)
    ; Window Exists
    {
        DetectHiddenWindows, Off

        ; Check if its hidden
        if !WinExist(WinMatcher) || !WinActive(WinMatcher)
        {
            ShowAndPositionTerminal()
        }
        else if WinExist(WinMatcher)
        {
            ; Script sees it without detecting hidden windows, so..
            ; WinMinimize ahk_class CASCADIA_HOSTING_WINDOW_CLASS
            WinHide WinMatcher
            Send !{Esc}
        }
    }
    else
    {
        Run "wt.exe"
        Sleep, 1000
        ShowAndPositionTerminal()
    }
}

MWAGetMonitorMouseIsIn() ; we didn't actually need the "Monitor = 0"
{
	; get the mouse coordinates first
	Coordmode, Mouse, Screen	; use Screen, so we can compare the coords with the sysget information`
	MouseGetPos, Mx, My

	SysGet, MonitorCount, 80	; monitorcount, so we know how many monitors there are, and the number of loops we need to do
	Loop, %MonitorCount%
	{
		SysGet, mon%A_Index%, Monitor, %A_Index%	; "Monitor" will get the total desktop space of the monitor, including taskbars

		if ( Mx >= mon%A_Index%left ) && ( Mx < mon%A_Index%right ) && ( My >= mon%A_Index%top ) && ( My < mon%A_Index%bottom )
		{
			ActiveMon := A_Index
			break
		}
	}
	return ActiveMon
}