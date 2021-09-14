### alias
############
alias rc="open ~/.zshrc"
alias grsh1="git reset --soft HEAD~1"
alias prune="git remote prune origin"
alias fpg="flutter pub get"
alias fpu="flutter pub upgrade"
alias fprbb="flutter pub run build_runner build"
alias fprbbd="flutter pub run build_runner build --delete-conflicting-outputs"
alias fprbw="flutter pub run build_runner watch"
alias fprbwd="flutter pub run build_runner watch --delete-conflicting-outputs"
alias dpg="dart pub get"
alias dpu="dart pub upgrade"
alias drbb="dart run build_runner build"
alias drbbd="dart run build_runner build --delete-conflicting-outputs"
alias drbw="dart run build_runner watch"
alias drbwd="dart run build_runner watch --delete-conflicting-outputs"
alias devtools_activate="dart pub global activate --source path /Users/nick/git/languages/dart/contributing/devtools/packages/devtools"
alias devtools_rebuild="cd /Users/nick/git/languages/dart/contributing/devtools && ./tool/update_flutter_sdk.sh && ./rebuild.sh && dart pub global activate --source path ./packages/devtools"

### flutter
############

# add flutter to the path 
path+=~/SDKs/flutter/bin

### dart 
############

# globally installed dart packages
path+=~/.pub-cache/bin

### npm 
############

# globally installed npm packages
# path+=~/.npm-global/bin

### path
# export to sub-processes (make it inherited by child processes)
export PATH
# set the environment used by launchd
launchctl setenv PATH $PATH

### oh my zsh 
############

plugins=(zsh-syntax-highlighting)
ZSH_THEME="robbyrussell"

# Path to your oh-my-zsh installation.
export ZSH="/Users/nick/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh