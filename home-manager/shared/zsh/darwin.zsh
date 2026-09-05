# stop mediaanaylisisd
killmedia() {
  killall -STOP mediaanalysisd mediaanalysisd-access
}

# Android Studio
export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_NDK=$HOME/Library/Android/sdk/ndk-bundle
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

export PATH="/opt/homebrew/bin:$PATH"

# Hide Homebrew environment hints
export HOMEBREW_NO_ENV_HINTS=1
