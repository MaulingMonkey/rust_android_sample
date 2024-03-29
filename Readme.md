# rust_android_sample

A "minimal" Rust + Android demo.  No, I'm not kidding, it's this gross.

# Requriements

| What                                                      | Why                                               |
| --------------------------------------------------------- | ------------------------------------------------- |
| [rustup](https://rustup.rs/)                              | Easy management of rust build tools               |
| [VS Code](https://code.visualstudio.com/)                 | Configured for builds, debugging, etc.            |
| [Android Studio](https://developer.android.com/studio)    | I'm weird... also it'll get you Android SDK bits. |

Several subcomponents of the above are also recommend or required - see `scripts\install-components.cmd`, or just run the `Install Components` task when you have VS Code launched.

# Useful Commands

## Host commands

| Command | What |
| ------- | ---- |
| `%LOCALAPPDATA%\Android\Sdk\...`      | ADB and other commands are scattered throughout here
| `adb`                                 | ...help text
| `adb devices`                         | Devices
| `adb logcat --clear && adb logcat`    | Device Logs
| `adb install path/to/the.apk`         | Install an APK
| `adb shell`                           | Interactive shell
| `adb shell [command]`                 | Run shell command on target

## Target commands

| Command | What |
| ------- | ---- |
| `adb shell am`                                                    | ...help text for Activity Manager
| `adb shell pm`                                                    | ...help text for Package Manager
| `adb shell pm list packages`                                      | List all installed packages (pipe through `findstr com.maulingmonkey` ?)
| `adb shell pm uninstall com.maulingmonkey.rust_android_sample`    | Fully uninstall package after uninstalling through apps borks the package
| `adb shell pm path com.maulingmonkey.rust_android_sample`         | Check installed path to see if it changed / actually installed
| `adb shell ls -l  pm path com.maulingmonkey.rust_android_sample`  | Check installed path to see if it changed / actually installed
| `adb shell ls -l /data/app/com.maulingmonkey.rust_.../base.apk`   | Check size/time
| `adb shell getprop`                                               | See device settings list
| `adb shell getprop ro.product.cpu.abilist`                        | Check device architecture
| `adb shell getprop ro.build.version.sdk`                          | Check device SDK version
| `adb shell setprop ...`                                           | Set device settings

```cmd
:: Screenshot
adb shell screencap -p /sdcard/screen.png
adb       pull         /sdcard/screen.png
adb shell rm           /sdcard/screen.png
```

# Devices

| Device    | [ro.product.cpu.abilist](https://developer.android.com/ndk/guides/abis) | [Android Ver.](https://developer.android.com/studio/releases/platforms) | [ro.build.version.sdk](https://developer.android.com/studio/releases/platforms) |
| --------- | ----------------------------------------------------------------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| [SM-T510](https://www.samsung.com/ca/tablets/galaxy-tab-a-2019-101/SM-T510NZDAXAC/)   | `armeabi-v7a,armeabi` | 9.0           | 28
| [SM-N900](https://www.sammobile.com/samsung/galaxy-note-3/specs/SM-N900/)             | ???                   | 5.0           | 21

# Still TODO

* Hook up GDB
  https://source.android.com/devices/tech/debug/gdb
  https://developer.android.com/studio/command-line/adb

# Workarounds and Android/Samsung Bugs

## App can't be reinstalled after uninstall

Uninstalling through the tablet apps list UI on my `SM-T510` leaves android packages in a partially uninstalled state
where the command line tools can't reinstall to the same package name afterwards, despite supposedly "succeeding" (they
won't show up in the app list nor in `adb shell pm list packages`).  To work around this bug, you can use adb to fully
uninstall with e.g. `adb shell pm uninstall com.maulingmonkey.rust_android_sample`, then reinstall normally.

## I keep ending up with stale builds

Flakey USB connections can cause `adb` to lie and say it successfully installed a package when it didn't.  If you want
to automatically detect this, parse the output of `adb shell pm path com.maulingmonkey.rust_android_sample` before and
after install.  If the path didn't change, it probably didn't redeploy.  You can doublecheck the file size and time
(again before/after install) if you want to eliminate false positives.  If the given path was
`package:/data/app/com.maulingmonkey.rust_android_sample-GmoQAziYbu5PsGZYuXfzUA==/base.apk` , you can then strip the
`package:` prefix and run: `adb shell ls -l /data/app/com.maulingmonkey.rust_android_sample-GmoQAziYbu5PsGZYuXfzUA==/base.apk` .
If that didn't change either, the package almost certainly failed to reinstall.

## My APK is too large (>100MB!)

For the google store, you need to use <a href="https://developer.android.com/google/play/expansion-files">APK Expansion Files</a>.
For the amazon store, larger APKs are supported.

## I can't read my `.obb` expansion files

Earlier versions of the Downloader Library failed to request the proper storage permissions at runtime, although
[apkx_sample](https://github.com/google/play-apk-expansion/blob/master/apkx_sample/src/com/example/google/play/apkx/SampleDownloaderActivity.java#L446-L514)
looks like it might be requesting everything now?  I can't find the old bug report either... the worst part is
that *sometimes* access would work, sometimes not!
