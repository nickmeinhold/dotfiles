### alias
############
alias rc="open ~/.zshrc"
alias grs1="git reset --soft HEAD~1"
alias prune="git remote prune origin"
alias fpg="flutter pub get"
alias fprb="flutter pub run build_runner build"
alias fprbd="flutter pub run build_runner build --delete-conflicting-outputs"
alias fprw="flutter pub run build_runner watch"
alias fprwd="flutter pub run build_runner watch --delete-conflicting-outputs"

### flutter
############

# add flutter to the path 
export PATH=$PATH:/Users/nick/SDKs/flutter/bin

### dart 
############

# globally installed dart packages
export PATH="$PATH":"$HOME/.pub-cache/bin"

# add flutter's dart/bin folder to the path 
export PATH=/Users/nick/SDKs/flutter/bin/cache/dart-sdk/bin:$PATH

### fuchsia 
############

# the jiri and fx tools are essential to Fuchsia workflows
export PATH="/Users/nick/fuchsia/.jiri_root/bin:$PATH"

# the fx-env.sh script enables useful shell functions
source ~/fuchsia/scripts/fx-env.sh

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
if [ -f '/Users/nick/SDKs/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/nick/SDKs/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/nick/SDKs/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/nick/SDKs/google-cloud-sdk/completion.zsh.inc'; fi

### oh my zsh 
############

plugins=(zsh-syntax-highlighting)
ZSH_THEME="robbyrussell"

# Path to your oh-my-zsh installation.
export ZSH="/Users/nick/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh