### alias
############

alias fpg="flutter pub get"
alias fprb="flutter pub run build_runner build"
alias fprbd="flutter pub run build_runner build --delete-conflicting-outputs"
alias fprw="flutter pub run build_runner watch"
alias fprwd="flutter pub run build_runner watch --delete-conflicting-outputs"
alias prune="git remote prune origin"
alias rc="open ~/.zshrc"

### flutter
############

# add flutter to the path 
export PATH=$PATH:/Users/nick/Documents/SDKs/flutter/bin

### dart 
############

# add flutter's dart/bin folder to the path 
export PATH=/Users/nick/Documents/SDKs/flutter/bin/cache/dart-sdk/bin:$PATH

# globally installed dart packages
export PATH="$PATH":"$HOME/.pub-cache/bin"

### npm 
############

# add globally installed npm packages to the path
export PATH=~/.npm-global/bin:$PATH

### android 
############

# platform tools, including adb
export ANDROID_HOME=/Users/$USER/Library/Android/sdk
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

### gcloud 
############

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/nick/Documents/SDKs/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/nick/Documents/SDKs/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/nick/Documents/SDKs/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/nick/Documents/SDKs/google-cloud-sdk/completion.zsh.inc'; fi
