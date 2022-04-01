#SingleInstance Force

WinActivate, SAOIF_Player
ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, loading.bmp
if ErrorLevel = 0
Msgbox its there

exitapp