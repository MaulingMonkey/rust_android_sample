@setlocal

:: Required for SDK Manager
@set JAVA_HOME=%ProgramFiles%\Android\Android Studio\jre\

:: SDK Manager
@set PATH=%LOCALAPPDATA%\Android\Sdk\tools\bin\;%PATH%

call sdkmanager --install ^
    build-tools;29.0.0 ^
    ndk-bundle ^
    platform-tools ^
    platforms;android-28 ^
    platforms;android-29 ^
    tools ^
    || exit /b 1

rustup target add ^
    aarch64-linux-android ^
    armv7-linux-androideabi ^
    i686-linux-android ^
    x86_64-linux-android ^
    || exit /b 1

code --install-extension rust-lang.rust

@endlocal
