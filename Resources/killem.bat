cd C:\NoxEmulator\Nox\bin
adb shell am force-stop com.bandainamcoent.saoifww
adb shell pm clear com.bandainamcoent.saoifww
adb shell monkey -p com.bandainamcoent.saoifww -c android.intent.category.LAUNCHER 1