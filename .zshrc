### alias
############
alias mp="cd ~/git/orgs/enspyrco/monorepo/packages"
alias rc="open ~/.zshrc"
alias grsh1="git reset --soft HEAD~1"
alias prune="git remote prune origin"
alias fpg="flutter pub get"
alias fpu="flutter pub upgrade"
alias fpo="flutter pub outdated"
alias fpa="flutter pub add"
alias fprbb="flutter pub run build_runner build"
alias fprbbd="flutter pub run build_runner build --delete-conflicting-outputs"
alias fprbw="flutter pub run build_runner watch"
alias fprbwd="flutter pub run build_runner watch --delete-conflicting-outputs"
alias dpg="dart pub get"
alias dpa="dart pub add"
alias dpu="dart pub upgrade"
alias drbb="dart run build_runner build"
alias drbbd="dart run build_runner build --delete-conflicting-outputs"
alias drbw="dart run build_runner watch"
alias drbwd="dart run build_runner watch --delete-conflicting-outputs"
alias devtools_activate="dart pub global activate --source path /Users/nick/git/languages/dart/contributing/devtools/packages/devtools"
alias devtools_rebuild="cd /Users/nick/git/languages/dart/contributing/devtools && ./tool/update_flutter_sdk.sh && ./rebuild.sh && dart pub global activate --source path ./packages/devtools"

# Add Visual Studio Code (code)
path+='/Applications/Visual Studio Code.app/Contents/Resources/app/bin'

# Use the JRE bundled with Android Studio
export JAVA_HOME='/Applications/Android Studio.app/Contents/jre/Contents/Home'

### flutter & dart
############

# add flutter to the path 
path+=~/SDKs/flutter/bin

# globally installed packages
path+=~/.pub-cache/bin
path+=~/SDKs/flutter/.pub-cache/bin

### npm 
############

# globally installed npm packages
# path+=~/.npm-global/bin

### build tools 
############

path+=~/SDKs/depot_tools

### path
# export to sub-processes (make it inherited by child processes)
export PATH
# set the environment used by launchd
launchctl setenv PATH $PATH

### oh my zsh 
############

plugins=(zsh-syntax-highlighting)
ZSH_THEME='robbyrussell'

# Path to your oh-my-zsh installation.
export ZSH='/Users/nick/.oh-my-zsh'
source $ZSH/oh-my-zsh.sh

### gcloud
############

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/nick/SDKs/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/nick/SDKs/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/nick/SDKs/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/nick/SDKs/google-cloud-sdk/completion.zsh.inc'; fi
