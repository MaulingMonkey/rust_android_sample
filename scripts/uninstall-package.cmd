:: Uninstalling through the app launcher can leave the package in a half-uninstalled state where you can't see
:: the sample after reinstalling it.  Using adb shell pm uninstall seems to do the trick though.

@set JAVA_HOME=%ProgramFiles%\Android\Android Studio\jre\
@set PATH=%LOCALAPPDATA%\Android\Sdk\tools\bin\;%PATH%
adb shell pm uninstall com.maulingmonkey.rust_android_sample
