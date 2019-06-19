@setlocal
@set "GRADLE_ARGS=%~1"
@set "CONFIG=%~2"
@set "CARGO_ARGS=%~3"
@if not defined GRADLE_ARGS echo GRADLE_ARGS is required&& exit /b 1
@pushd "%~dp0.."

@setlocal
@set ANDROID_TOOLCHAIN_BIN=%LOCALAPPDATA:\=/%/Android/Sdk/ndk-bundle/toolchains/llvm/prebuilt/windows-x86_64/bin
@set ANDROID_TOOLCHAIN_BIN=%ANDROID_TOOLCHAIN_BIN:/=\\%
@set ANDROID_VER=21

@echo.# WARNING:  This file is auto-generated by scripts\build.cmd, do not manually modify.> "%~dp0\..\.cargo\config"

@echo.>>"%~dp0\..\.cargo\config"
@echo.[target.aarch64-linux-android]>> "%~dp0\..\.cargo\config"
@echo.ar = "%ANDROID_TOOLCHAIN_BIN%\\aarch64-linux-android-ar.cmd">>"%~dp0\..\.cargo\config"
@echo.linker = "%ANDROID_TOOLCHAIN_BIN%\\aarch64-linux-android%ANDROID_VER%-clang.cmd">>"%~dp0\..\.cargo\config"

@echo.>>"%~dp0\..\.cargo\config"
@echo.[target.armv7-linux-androideabi]>>"%~dp0\..\.cargo\config"
@echo.ar = "%ANDROID_TOOLCHAIN_BIN%\\armv7a-linux-androideabi-ar.cmd">>"%~dp0\..\.cargo\config"
@echo.linker = "%ANDROID_TOOLCHAIN_BIN%\\armv7a-linux-androideabi%ANDROID_VER%-clang.cmd">>"%~dp0\..\.cargo\config"

@echo.>>"%~dp0\..\.cargo\config"
@echo.[target.i686-linux-android]>>"%~dp0\..\.cargo\config"
@echo.ar = "%ANDROID_TOOLCHAIN_BIN%\\i686-linux-android-ar.cmd">>"%~dp0\..\.cargo\config"
@echo.linker = "%ANDROID_TOOLCHAIN_BIN%\\i686-linux-android%ANDROID_VER%-clang.cmd">>"%~dp0\..\.cargo\config"

@echo.>>"%~dp0\..\.cargo\config"
@echo.[target.x86_64-linux-android]>>"%~dp0\..\.cargo\config"
@echo.ar = "%ANDROID_TOOLCHAIN_BIN%\\x86_64-linux-android-ar.cmd">>"%~dp0\..\.cargo\config"
@echo.linker = "%ANDROID_TOOLCHAIN_BIN%\\x86_64-linux-android%ANDROID_VER%-clang.cmd">>"%~dp0\..\.cargo\config"

cargo build --target aarch64-linux-android   %CARGO_ARGS%
cargo build --target armv7-linux-androideabi %CARGO_ARGS%
cargo build --target i686-linux-android      %CARGO_ARGS%
cargo build --target x86_64-linux-android    %CARGO_ARGS%

@mkdir target\%CONFIG%\jnilibs\armeabi-v7a  >NUL 2>NUL
@mkdir target\%CONFIG%\jnilibs\arm64-v8a    >NUL 2>NUL
@mkdir target\%CONFIG%\jnilibs\x86          >NUL 2>NUL
@mkdir target\%CONFIG%\jnilibs\x86_64       >NUL 2>NUL

copy /Y target\aarch64-linux-android\%CONFIG%\librust_android_sample.so     target\%CONFIG%\jnilibs\arm64-v8a\librust_android_sample.so
copy /Y target\armv7-linux-androideabi\%CONFIG%\librust_android_sample.so   target\%CONFIG%\jnilibs\armeabi-v7a\librust_android_sample.so
copy /Y target\i686-linux-android\%CONFIG%\librust_android_sample.so        target\%CONFIG%\jnilibs\x86\librust_android_sample.so
copy /Y target\x86_64-linux-android\%CONFIG%\librust_android_sample.so      target\%CONFIG%\jnilibs\x86_64\librust_android_sample.so

@if not defined JAVA_HOME        set JAVA_HOME=%ProgramFiles%\Android\Android Studio\jre\
@if not defined ANDROID_SDK_ROOT set ANDROID_SDK_ROOT=%LOCALAPPDATA%\Android\Sdk

:: Don't use this gradle, it's a old version that doesn't work
::call "%ProgramFiles%\Android\Android Studio\plugins\android\lib\templates\gradle\wrapper\gradlew.bat" %GRADLE_ARGS%
call "%~dp0gradlew.bat" %GRADLE_ARGS%
@echo on

@popd
@endlocal
