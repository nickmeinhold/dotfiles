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
alias prbb="pub run build_runner build"
alias prbbd="pub run build_runner build --delete-conflicting-outputs"
alias prbw="pub run build_runner watch"
alias prbwd="pub run build_runner watch --delete-conflicting-outputs"
alias devtools_activate="dart pub global activate --source path /Users/nick/git/languages/dart/contributing/devtools/packages/devtools"
alias devtools_rebuild="cd /Users/nick/git/languages/dart/contributing/devtools && ./tool/update_flutter_sdk.sh && ./rebuild.sh && dart pub global activate --source path ./packages/devtools"

### flutter
############

# add flutter to the path 
path+=('~/SDKs/flutter/bin')

### dart 
############

# globally installed dart packages
path+=('~/.pub-cache/bin')

### npm 
############

# add globally installed npm packages to the path
path+=('~/.npm-global/bin')

### gcloud 
############

# The next line updates PATH for the Google Cloud SDK.
if [ -f '~/SDKs/google-cloud-sdk/path.zsh.inc' ]; then . '~/SDKs/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '~/SDKs/google-cloud-sdk/completion.zsh.inc' ]; then . '~/SDKs/google-cloud-sdk/completion.zsh.inc'; fi

### oh my zsh 
############

plugins=(zsh-syntax-highlighting)
ZSH_THEME="robbyrussell"

# Path to your oh-my-zsh installation.
export ZSH="/Users/nick/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# export to sub-processes (make it inherited by child processes)
export PATH