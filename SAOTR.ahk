#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force
#Persistent
Menu, tray, add
Menu, tray, add, WhereAmI
Menu, tray, add, RestartGame
Menu, tray, add, CloseClearnGo
Gui, Add, Picture, x0 y0 h380 w210, Resources\Extras\bg.jpg 
Gui, font,bold
gui, font,, Verdana
gui, font, s8
Gui, font, c0078D7
Gui, Add, Text, x5 y2 w130 h20 +BackgroundTrans, SAOIF ToonRoller
Gui, Add, Text, x180 y2 w40 h20 +BackgroundTrans, v1.0
Gui, font,norm
Gui, font, cBlack
gui, font, s7
Gui, Add, Text, x5 y22 w120 h20 +BackgroundTrans, DoubleCheck Delay
Gui, Add, Edit, x112 y19 w60 h20 vGUI_ItsOkay,
Gui, Add, Text, x177 y22 w30 h20 +BackgroundTrans, ms
gui, font, s8
Gui, font,bold
Gui, font, c0078D7 s7
Gui, Add, Text, x5 y43 w200 h20 +BackgroundTrans vGUI_Username, ROLLING:
Gui, font,norm
Gui, font, cBlack
Gui, Add, Text, x5 y59 w200 h180 +BackgroundTrans vGUI_Status
gui, font, s8
gui, font,
Gui, font,bold
Gui, font, c0078D7
Gui, Add, Text, x5 y249 w40 h20 +BackgroundTrans, Action:
Gui, font,norm
Gui, font, cBlack
gui, font, s7
Gui, Add, Text, x50 y249 w250 h20 +BackgroundTrans vGUI_Looking,
gui, font, s8
Gui, Add, Progress, x5 y270 w200 h10 vProgression, 
Gui, Add, Button, x5 y289 w200 h20 gWhereAmI, START LOOKING
Gui, Add, Button, x5 y311 w200 h20 gCloseClearnGo, CLEAR N RESTART
Gui, Add, Button, x5 y333 w200 h20 gRestartGame, RESTART GAME
Gui, font, c0078D7 Bold
Gui, Add, Text, x40 y360 w160 h20 +BackgroundTrans, CREATED BY INIXUITY
Gui, Show, x1353 y185 h380 w210, SAOTR
GoSub, ResetSequenceMarkers
Return

ResetSequenceMarkers:
GoSub, GenerateUserName
GoSub, GenerateUID
itsokaydelay = 2000
GuiControl,, GUI_ItsOkay, %itsokaydelay%
; RESET ALL SEQUENCE-COMPLETE MARKERS
tosclicked = 0
homescreenclicked = 0
transferidmade = 0
tooncreated = 0
girlclicked = 0
defeatedmonster = 0
lookforpartner = 0
practiceontheplanes1 = 0
practiceontheplanes2 = 0
practiceontheplanes3 = 0
quickchangeclicked = 0
finalguyclicked = 0
reachedtown = 0
rewardcollected = 0
rewardredeemed = 0
reboot = 0
transferidmade = 0
FormatTime, Time,, Time
Return

WhereAmI:
if reboot = 0
FormatTime, Time,, Time

GuiControl,, GUI_Username, ROLLING: %Username% @ %Time%
ProgressbarMax = 0
Gui, Submit, NoHide
LoopCount = 0

Loop,
{
TotalSearches = 0

; LOOK FOR DIALOG AND NEXT BUTTONS
GoSub, CheckForDialog
GoSub, NextandEnd
GoSub, CrashCheck

; LOOK FOR TOS
if(tosclicked = 0)
{
lookingfor = Terms of Service
Image = Resources\Main\tos.bmp
variation = *2
GoSub, SearchImageNoClick
If(Clicked=1)
Click 795, 639
}

; LOOK FOR HOMESCREEN
if(homescreenclicked = 0)
{
lookingfor = Homescreen
Image = Resources\Main\homescreen.bmp
variation = *2
GoSub, SearchImageNoClick
If(Clicked = 1)
{
variation = *2
GoSub, MakeSureItsOkay
If(ItsOkay = 1)
{
tosclicked++ ; TOS must have been clicked otherwise wouldn't be here
if(transferidmade = 0)
GoSub, CreateTransferID
else
GoSub, SearchImage
}
}
}

; LOOK FOR CHAR CREATION SCREEN
if(tooncreated = 0)
{
lookingfor = Character Creation
Image = Resources\Main\gender.bmp
variation = *2
GoSub, SearchImageNoClick
If(Clicked=1)
{
homescreenclicked++ ; homescreen must have been clicked otherwise wouldn't be here
Click 1114, 692
Sleep, 600
Click 768, 554
Sleep, 600
}
}

; LOOK FOR USERNAME INPUT BOX
if(tooncreated = 0)
{
Image = Resources\Dialogue\entername.bmp
GoSub, SearchImage
If(Clicked=1)
GoSub, EnterUsername
}

; LOOK FOR TALK TO GIRL TUTORIAL
if(girlclicked = 0)
{
lookingfor = Talk to the Girl
Image = Resources\Main\talktothegirl.bmp
variation = *2
GoSub, SearchImageNoClick
If(Clicked=1)
{
tooncreated++ ; Toon must have been created otherwise wouldn't be here
Click 644, 236
}
}

; LOOK FOR MONSTER DEFEAT TUTORIAL
if(defeatedmonster = 0){
lookingfor = Defeat a Monster
Image = Resources\Main\defeatamonster.bmp
variation = *2
GoSub, SearchImageNoClick
If(Clicked=1)
{
girlclicked++ ; Girl must have been clicked to get here
GoSub, DefeatMonster
}
}

; LOOK FOR PARTNER FIND TUTORIAL
if(lookforpartner = 0)
{
lookingfor = Look for Your Partner
Image = Resources\Main\lookforyourpartner.bmp
variation = *2
GoSub, SearchImageNoClick
If(Clicked=1)
{
defeatedmonster++ ; Must have defeated first FrenzyBoar to get here
Send, {s down}
Sleep, 6000
Send, {s up}
}
}

; LOOK FOR PRACTICE ON PLANES TUTORIALS
if(practiceontheplanes1 = 0)
{
lookingfor = Practice on The Planes
Image = Resources\Main\practiceontheplanes.bmp
variation = *2
GoSub, SearchImageNoClick
If(Clicked=1)
{
Loop, 6
{
Send, {w down}
Sleep, 2000
Send, {w up}
}
lookforpartner++ ; Must have found partner in order to get here
}
}

if(practiceontheplanes2 = 0)
{
lookingfor = Defeat a Monster
Image = Resources\Main\practiceontheplanes2.bmp
variation = *2
GoSub, SearchImageNoClick
If(Clicked=1)
{
variation = *2
GoSub, MakeSureItsOkay
If(ItsOkay = 1)
{
practiceontheplanes1++ ; must have completed first planes to get here
GoSub, KillBore
}
}
}

if(practiceontheplanes3 = 0)
{
lookingfor = Defeat All of the Monsters
Image = Resources\Main\practiceontheplanes3.bmp
variation = *2
GoSub, SearchImageNoClick
If(Clicked=1)
{
variation = *2
GoSub, MakeSureItsOkay
If(ItsOkay = 1)
{
practiceontheplanes2++ ; must have completed second planes to get here
GoSub, KillBore
GoSub, KillWasp
}
}
}


; LOOK FOR QUICKCHANGE TUTORIAL
if(quickchangeclicked = 0)
{
lookingfor = Try using Quick Change
Image = Resources\Main\quickchange.bmp
variation = *2
GoSub, SearchImageNoClick
If(Clicked=1)
{
variation = *2
GoSub, MakeSureItsOkay
If(ItsOkay = 1)
GoSub, KillRabbit
}
}

; LOOK FOR FINAL TUTORIAL GUY STANDING
if(finalguyclicked = 0)
{
lookingfor = Talk to Kirito
Image = Resources\Main\finaltest.bmp
variation = *2
GoSub, SearchImageNoClick
If(Clicked=1)
{
variation = *2
GoSub, MakeSureItsOkay
If(ItsOkay = 1)
{
tooncreated = 0 ; reset toon created so it can pass final char creation screen
Click 685, 195
}
}
}

; LOOK TO SEE IF YOU'RE IN TOWN AND A GIFT IS PRESENT
lookingfor = Reached Town
Image = Resources\Main\town.bmp
variation = *2
GoSub, SearchImageNoClick
If(Clicked=1)
{
variation = *2
GoSub, MakeSureItsOkay
If(ItsOkay = 1)
{
finalguyclicked++
Break
}
}
LoopCount++
ProgressbarMax = %TotalSearches%
}
GoTo, InTown
Return



CreateTransferID:
GoSub, NextandEnd
lookingfor = TransferID
Loop,
{
Image = Resources\TansferID\menu.bmp
GoSub, SearchImage
If(Clicked = 1)
{
Sleep, 700
GoSub, CrashCheck
Image = Resources\TansferID\transferid.bmp
GoSub, SearchImage
If(Clicked = 1)
Break
else
GoSub, SearchImage
}
}
Sleep, 700

Image = Resources\TansferID\transferid2.bmp
GoSub, MakeSureItsGone

Loop,
{
Image = Resources\TansferID\uidinput.bmp
GoSub, SearchImage
If(Clicked = 1)
Break
}
Sleep, 1200
Send, %UID%
Sleep, 1000
Loop,
{
Image = Resources\TansferID\setpassword.bmp
GoSub, SearchImage
If(clicked = 0)
{
MouseMove 650, 265
Send, {WheelDown}
}
else
Break
}

GoSub, MakeSureItsGone

Loop,
{
Image = Resources\TansferID\return.bmp
variation = *2
GoSub, SearchImageNoClick
If(Clicked = 1)
{
WinActivate, SAOIF_Player
RunWait, Resources\MiniCap\MiniCap.exe -captureactivewin -exit -save "%A_ScriptDir%\Accounts\TransferIDs\%Username%.jpg"
Break
}
}

Image = Resources\TansferID\return.bmp
variation = *2
GoSub, MakeSureItsGone

Loop,
{
Image = Resources\TansferID\menu.bmp
GoSub, SearchImage
If(Clicked = 1)
Break
}
transferidmade++
Return


SearchImage:
TotalSearches++
GoSub, ProgressBar
Clicked = 0
MouseMove 28, 176
WinActivate, SAOIF_Player
ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Image%
if ErrorLevel = 0
{
Click %FoundX%, %FoundY%
Clicked++
}
GoSub, UpdateGUI
Return

SearchImageNoClick:
TotalSearches++
GoSub, ProgressBar
Clicked = 0
MouseMove 28, 176
WinActivate, SAOIF_Player
ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight,%variation% %Image%
if ErrorLevel = 0
Clicked++
variation =
GoSub, UpdateGUI
Return

UpdateGUI:
tosclicked_gui = Looking
transferidmade_gui = Looking
homescreenclicked_gui = Looking
tooncreated_gui = Looking
girlclicked_gui = Looking
defeatedmonster_gui = Looking
lookforpartner_gui = Looking
practiceontheplanes1_gui = Looking
practiceontheplanes2_gui = Looking
practiceontheplanes3_gui = Looking
quickchangeclicked_gui = Looking
finalguyclicked_gui = Looking
reachedtown_gui = Looking
rewardcollected_gui = Looking
rewardredeemed_gui = Looking

if(tosclicked > 0)
tosclicked_gui = Completed
if(transferidmade > 0)
transferidmade_gui = Completed
if(homescreenclicked > 0)
homescreenclicked_gui = Completed
if(tooncreated > 0)
tooncreated_gui = Completed
if(girlclicked > 0)
girlclicked_gui = Completed
if(defeatedmonster > 0)
defeatedmonster_gui = Completed
if(lookforpartner > 0)
lookforpartner_gui = Completed
if(practiceontheplanes1 > 0)
practiceontheplanes1_gui = Completed
if(practiceontheplanes2 > 0)
practiceontheplanes2_gui = Completed
if(practiceontheplanes3 > 0)
practiceontheplanes3_gui = Completed
if(quickchangeclicked > 0)
quickchangeclicked_gui = Completed
if(finalguyclicked > 0)
finalguyclicked_gui = Completed
if(reachedtown > 0)
reachedtown_gui = Completed
if(rewardcollected > 0)
rewardcollected_gui = Completed
if(rewardredeemed > 0)
rewardredeemed_gui = Completed

GuiControl,, GUI_Status, Terms of Service: %tosclicked_gui%`nTransferID Made: %transferidmade_gui%`nHomescreen: %homescreenclicked_gui%`nCharacter Creation: %tooncreated_gui%`nTalk to the Girl: %girlclicked_gui%`nDefeat a Monster: %defeatedmonster_gui%`nLook for Your Partner: %lookforpartner_gui%`nPractice on The Planes: %practiceontheplanes1_gui%`nDefeat a Monster: %practiceontheplanes2_gui%`nDefeat All of the Monsters: %practiceontheplanes3_gui%`nTry using Quick Change: %quickchangeclicked_gui%`nTalk to Kirito: %finalguyclicked_gui%`nReached Town: %reachedtown_gui%`nReward Collected: %rewardcollected_gui%`nReward Redeemed: %rewardredeemed_gui%`nTIMES SEARCHED: %LoopCount%`n
GuiControl,, GUI_Looking, %lookingfor%
Return

ProgressBar:
If(ProgressbarMax > 0)
{
Increase := (100 / ProgressbarMax)
TotalIncrease := Floor(Increase * TotalSearches)
GuiControl,, Progression, %TotalIncrease%
}
Return

NextandEnd:
if(tooncreated = 0)
{
lookingfor = Username
Image = Resources\Dialogue\entername.bmp
GoSub, SearchImage
If(Clicked != 1)
{
lookingfor = Input Prompts
Loop,
{
if(homescreenclicked = 0)
{
Image = Resources\Dialogue\next.bmp
GoSub, SearchImage
Clicked1 = %Clicked%
}
Image = Resources\Dialogue\next2.bmp
GoSub, SearchImage
Clicked2 = %Clicked%

Image = Resources\Dialogue\end.bmp
GoSub, SearchImage
Clicked3 = %Clicked%

If(Clicked1 == 0 && Clicked2 == 0 && Clicked3 == 0)
Break
else
Sleep, 200
}
}
}
else ; ELSE ON IF TOON CREATED
{
lookingfor = Input Prompts
Loop,
{
if(homescreenclicked = 0)
{
Image = Resources\Dialogue\next.bmp
GoSub, SearchImage
Clicked1 = %Clicked%
}

Image = Resources\Dialogue\next2.bmp
GoSub, SearchImage
Clicked2 = %Clicked%

Image = Resources\Dialogue\end.bmp
GoSub, SearchImage
Clicked3 = %Clicked%

If(Clicked1 == 0 && Clicked2 == 0 && Clicked3 == 0)
Break
else
Sleep, 200
}
}
Return


CheckForDialog:
lookingfor = Storyline Prompts
Loop,
{
Image = Resources\Dialogue\skip.bmp
GoSub, SearchImage
Clicked1 = %Clicked%

Image = Resources\Dialogue\ok.bmp
GoSub, SearchImage
Clicked2 = %Clicked%

If(Clicked1 == 0 && Clicked2 == 0)
Break
}
Return

EnterUsername:
Sleep, 500
Send, %Username%
Sleep, 500
Click 774, 558
Sleep, 500
Click 774, 558
Return

DefeatMonster:
Loop, 3
{
Send {w down}
Sleep, 1500
Send {w up}
Loop, 6
{
Click 1185, 555
Sleep, 500
}
}
Return

InTown:
reachedtown++
GoSub, UpdateGUI
Loop,
{
; LOOK FOR GIFT ICON
lookingfor = Gift Retrevial

Image = Resources\Town\gift.bmp
GoSub, MakeSureItsGone
GoSub, CrashCheck

Image = Resources\Town\gift2.bmp
GoSub, MakeSureItsGone
GoSub, CrashCheck

Image = Resources\Town\collectall.bmp
GoSub, MakeSureItsGone
GoSub, CrashCheck

Image = Resources\Dialogue\ok.bmp
GoSub, MakeSureItsGone
GoSub, CrashCheck

Image = Resources\Town\close.bmp
GoSub, MakeSureItsGone
GoSub, CrashCheck

Image = Resources\Town\close.bmp
GoSub, MakeSureItsGone
GoSub, CrashCheck

rewardcollected++
lookingfor = Gift Redemption
Loop,
{
Image = Resources\Town\menu.bmp
GoSub, SearchImage
If(Clicked = 1)
{
Sleep, 1000
GoSub, CrashCheck
Image = Resources\Town\shop.bmp
GoSub, SearchImage
If(Clicked = 1)
Break
}
}

Loop,
{
GoSub, CrashCheck
Image = Resources\Town\order11.bmp
variation = *2
GoSub, SearchImageNoClick
If(Clicked = 1)
Break
}
GoSub, CrashCheck
Image = Resources\Town\order11.bmp
variation = *2
GoSub, MakeSureItsGone
GoSub, CrashCheck

Image = Resources\Dialogue\ok.bmp
variation = *2
GoSub, MakeSureItsGone

Sleep, 13000

Loop,
{
GoSub, CrashCheck
Image = Resources\Town\orderagain.bmp
variation = *2
GoSub, SearchImageNoClick
If(Clicked = 1)
Break
else
{
GoSub, CrashCheck
Click 1221, 101
Sleep, 1000
}
}
WinActivate, SAOIF_Player
RunWait, Resources\MiniCap\MiniCap.exe -captureactivewin -exit -save "%A_ScriptDir%\Accounts\Rosters\%Username%.jpg"

Image = Resources\Town\orderagain.bmp
variation = *2
GoSub, MakeSureItsGone
GoSub, CrashCheck

Image = Resources\Town\close2.bmp
GoSub, MakeSureItsGone
GoSub, CrashCheck

Image = Resources\Town\gift.bmp
GoSub, MakeSureItsGone
GoSub, CrashCheck

Image = Resources\Town\gift2.bmp
GoSub, MakeSureItsGone
GoSub, CrashCheck

Image = Resources\Town\collectall.bmp
GoSub, SearchImage
If(Clicked = 1)
{
Sleep, 1000
Image = Resources\Dialogue\ok.bmp
variation = *2
GoSub, MakeSureItsGone
}
rewardredeemed++
GoSub, UpdateGUI
GoTo, CloseClearnGo
Break
}
; Goto, CloseClearnGo
Return

MakeSureItsGone:
Loop,
{
GoSub, SearchImage
If Clicked = 0
Break
else
Sleep, 1000
}
Sleep, 2000
Return

MakeSureItsOkay:
ItsOkay = 0
Sleep, %GUI_ItsOkay%
GoSub, SearchImageNoClick
If(Clicked=1)
ItsOkay++
Return

KillRabbit:
enemyname = Kobold Henchman
enemyimage = Resources\Fight\rabbit.bmp
TargetColor = 0x181EFF
GoSub, LookForEnemy
GoSub, KillEnemy
quickchangeclicked++ ; Must have completed quickchange tutorial to get here
Return

KillBore:
enemyname = FrenzyBoar
enemyimage = Resources\Fight\bore.bmp
TargetColor = 0x967D67
GoSub, LookForEnemy
GoSub, KillEnemy
Return

KillWasp:
enemyname = Stabbing Wasp
enemyimage = Resources\Fight\wasp.bmp
TargetColor = 0x309EA1
GoSub, LookForEnemy
GoSub, KillEnemy
practiceontheplanes3++
Return

LookForEnemy:
EnemyKilled = 0
GuiControl,, GUI_Looking, Hunting %enemyname%
Loop,
{
WinActivate, SAOIF_Player
MouseMove 28, 176
Send {Right down}
PixelSearch, Px, Py, 0, 0, A_ScreenWidth, A_ScreenHeight, %TargetColor%, 5, Fast
if( (ErrorLevel = 0) && (Px > 150) && (Px < 950) && (Py < 500)  && (Py > 100) )
{
Send {Right up}
Sleep, 400
PixelSearch, Px, Py, 0, 0, A_ScreenWidth, A_ScreenHeight, %TargetColor%, 5, Fast
if( (ErrorLevel = 0) && (Px > 150) && (Px < 950) && (Py < 500)  && (Py > 100) )
{
; Move curser down slightly if FrenzyBoar
if(TargetColor = 0x967D67)
Py :=(Py+15)

; Move curser down slightly if Rabbit
if(TargetColor = 0x181EFF)
Py :=(Py+65)

Click %Px%, %Py%
Sleep, 500
ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %enemyimage%
if ErrorLevel = 0
Break
}
else
{
Send {w down}
Sleep, 500
Send {w up}
Sleep, 500
}
}
}
Return

KillEnemy:
GuiControl,, GUI_Looking, Attacking %enemyname%
Loop,
{
ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, %enemyimage%
if ErrorLevel = 0
{
Click 1182, 554
Sleep, 700
}
else
Break
}
EnemyKilled = 1
GuiControl,, GUI_Looking, Defeated %enemyname%
Return

GenerateUID:
my_array=a,b,c,d,e,1,2,3,4,5,6,7
Sort, my_array, Random D,
UID:=RegExReplace(my_array, ",")
Return

GenerateUserName:
Loop, Read, Resources\Extras\adjectives.txt
adjectives_lines = %A_Index%
Loop, Read, Resources\Extras\animals.txt
animals_lines = %A_Index%
Loop, Read, Resources\Extras\nouns.txt
nouns_lines = %A_Index%

Loop,
{
Random, Ra1, 1, %adjectives_lines%
Random, Ra2, 1, %animals_lines%
Random, Ra3, 1, %nouns_lines%
Random, Ra4, 1, 4

FileReadLine, adjective, Resources\Extras\adjectives.txt, %Ra1%
FileReadLine, animal, Resources\Extras\animals.txt, %Ra2%
FileReadLine, noun, Resources\Extras\nouns.txt, %Ra3%

If(Ra4 == 1)
Username = %adjective%%animal%
If(Ra4 == 2)
Username = %adjective%%noun%
If(Ra4 == 3)
Username = %noun%%animal%
If(Ra4 == 4)
Username = %noun%%adjective%

if ((StrLen(Username) <= 12) && (StrLen(Username) >= 5))
Break
}
Return

CrashCheck:
; CHECK IF GAME CRASHED
lookingfor = Game Crash Check
Image = Resources\Dialogue\crashed.bmp
variation = *2
GoSub, SearchImageNoClick
If(Clicked=1)
GoTo, RestartGame

; CHECK IF GAME CRASHED TO DESKTOP
Image = Resources\Dialogue\crashed-desktop.bmp
variation = *2
GoSub, SearchImageNoClick
If(Clicked=1)
{
variation = *2
GoSub, MakeSureItsOkay
If(ItsOkay = 1)
GoTo, RestartGame
}
Return

CloseClearnGo:
GuiControl,, GUI_Status, Ending Game`nClearing Game Cache`nRestarting Game
WinActivate, SAOIF_Player
RunWait, Resources\killem.bat
GoSub, ResetSequenceMarkers
Sleep, 2000
Goto, WhereAmI
Return

RestartGame:
GuiControl,, GUI_Status, Restarting Game
WinActivate, SAOIF_Player
RunWait, Resources\restart.bat
homescreenclicked = 0
Sleep, 2000
reboot++
Goto, WhereAmI
Return

GuiClose:
ExitApp

Numpad1::
GoTo, WhereAmI
Return

Numpad2::Reload

Numpad3::
Pause
Return