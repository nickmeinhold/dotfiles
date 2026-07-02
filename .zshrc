### prompt
PROMPT='%1~ %# '

### alias
############
alias rc="open ~/.zshrc"
alias grsh1="git reset --soft HEAD~1"

### go 
export+=/opt/homebrew/bin

### rust
path+=~/.cargo/bin

### history
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# Add Visual Studio Code (code)
path+='/Applications/Visual Studio Code.app/Contents/Resources/app/bin'

# Use the JRE bundled with Android Studio
export JAVA_HOME='/Applications/Android Studio.app/Contents/jbr/Contents/Home'
path+=~/Library/Android/sdk/cmdline-tools/latest/bin

### flutter & dart
############

# add flutter to the path 
path+=~/SDKs/flutter/bin

# add dart from SDK to the path
#path+=~/SDKs/dart-sdk/sdk/xcodebuild/ReleaseARM64

# globally installed packages
path+=~/.pub-cache/bin
path+=~/SDKs/flutter/.pub-cache/bin

### npm 
############

# globally installed npm packages
# path+=~/.npm-global/bin

### testing tools 
############

path+=~/utils

### gcloud
############

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/nick/SDKs/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/nick/SDKs/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/nick/SDKs/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/nick/SDKs/google-cloud-sdk/completion.zsh.inc'; fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/nick/.lmstudio/bin"
# End of LM Studio CLI section

. "$HOME/.local/bin/env"
export PATH=$PATH:$HOME/.maestro/bin

path+=/opt/homebrew/bin

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /Users/nick/.dart-cli-completion/zsh-config.zsh ]] && . /Users/nick/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]


# Added by Antigravity
export PATH="/Users/nick/.antigravity/antigravity/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/flutter-tizen/bin:$PATH"
export PATH="$HOME/tizen-studio/tools:$PATH"
export TIZEN_SDK="$HOME/tizen-studio"
### secrets — consolidated in ~/.claude/.env (outside this PUBLIC repo, never committed).
# allexport (set -a) so every KEY=val there is exported to the shell + child processes,
# preserving the old behaviour where the PATs were exported globally.
[[ -f ~/.claude/.env ]] && { set -a; source ~/.claude/.env; set +a; }
export SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"

### ─── fzf: fuzzy finder ───────────────────────────────────────────────
# Ctrl-R fuzzy history · Ctrl-T fuzzy file picker · Alt-C fuzzy cd
source <(fzf --zsh)

### ─── fzf-tab: turn TAB completion into a live fzf picker ─────────────
# Requires compinit to have run first (compdef is normally already defined).
(( $+functions[compdef] )) || { autoload -Uz compinit && compinit; }
zstyle ':completion:*' menu no                 # let fzf-tab own the menu
source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh
zstyle ':fzf-tab:*' fzf-flags --height=60% --layout=reverse --border

### ─── g / gc: fuzzy-jump to any git repo under ~/git ──────────────────
export GIT_ROOT=~/git
_GIT_REPOS_CACHE=~/.cache/git-repos.txt
_GIT_INDEX_CACHE=~/.cache/git-repos-index.tsv   # path<TAB>description, for gs

# Rebuild the cached list of TOP-LEVEL git repos. Two layers of pruning:
#  1. dependency/build dirs (node_modules, .build, Pods, …) are skipped wholesale
#     so vendored .git checkouts inside them never leak in;
#  2. on each real repo hit we prune the subtree, so submodules nested inside a
#     repo aren't listed as separate projects.
grefresh() {
  find "$GIT_ROOT" -type d \( \
         -name .git -o -name node_modules -o -name .build -o -name Pods \
         -o -name Carthage -o -name DerivedData -o -name .dart_tool -o -name vendor \
       \) -prune -o \
       -type d -exec test -e '{}/.git' ';' -prune -print 2>/dev/null \
    | sed "s|^$GIT_ROOT/||" | sort > "$_GIT_REPOS_CACHE"
  echo "grefresh: $(wc -l < "$_GIT_REPOS_CACHE" | tr -d ' ') repos"
  gindex >/dev/null            # keep the semantic-search index in sync
}

# gindex → build the grounded index ~/.cache/git-repos-index.tsv as
# "path<TAB>description", mining each repo's index.html <title> / README H1 /
# package.json / pubspec.yaml / CLAUDE.md. This is what lets `gs` route by what
# a repo IS rather than by its (often opaque or misleading) name. Pure shell,
# no LLM, ~instant. The (N) glob qualifier keeps missing READMEs quiet.
gindex() {
  [[ -f $_GIT_REPOS_CACHE ]] || grefresh >/dev/null
  : > "$_GIT_INDEX_CACHE"
  local p d desc rd
  while IFS= read -r p; do
    d="$GIT_ROOT/$p"; desc=""
    [[ -f $d/index.html ]] && desc=$(grep -m1 -ioE '<title>[^<]*</title>' "$d/index.html" 2>/dev/null | sed -E 's/<[^>]+>//g')
    if [[ -z $desc ]]; then
      rd=( "$d"/README*(N) ); rd=$rd[1]
      [[ -n $rd ]] && desc=$(grep -m1 -E '^# ' "$rd" 2>/dev/null | sed -E 's/^#+ *//')
      [[ -z $desc && -n $rd ]] && desc=$(grep -m1 -E '^[A-Za-z]' "$rd" 2>/dev/null)
    fi
    [[ -z $desc && -f $d/package.json ]] && desc=$(jq -r '.description // empty' "$d/package.json" 2>/dev/null)
    [[ -z $desc && -f $d/pubspec.yaml ]] && desc=$(grep -m1 -E '^description:' "$d/pubspec.yaml" 2>/dev/null | sed -E 's/^description: *//')
    [[ -z $desc && -f $d/CLAUDE.md ]] && desc=$(grep -m1 -E '^# ' "$d/CLAUDE.md" 2>/dev/null | sed -E 's/^#+ *//')
    desc=$(printf '%s' "$desc" | tr -d '\r' | tr -s ' ' | cut -c1-110)
    printf '%s\t%s\n' "$p" "$desc" >> "$_GIT_INDEX_CACHE"
  done < "$_GIT_REPOS_CACHE"
  echo "gindex: described $(wc -l < "$_GIT_INDEX_CACHE" | tr -d ' ') repos"
}

# g [filter] → jump to a git repo under ~/git. Works because g is a shell
# *function* — only in-shell code can move your pwd.
#   • exact path  → cd straight there
#   • partial/no match → opens fzf pre-filtered by what you typed
#   • TAB         → live fzf-tab picker
#   • no name match → points you at `gs` (semantic search)
g() {
  [[ -f $_GIT_REPOS_CACHE ]] || grefresh >/dev/null
  local arg="$*" pick
  if [[ -n $arg && -d $GIT_ROOT/$arg ]]; then cd "$GIT_ROOT/$arg"; return; fi
  # Basename fast-path: bare name (no slash) matching exactly one nested repo by
  # its final path segment → cd straight in (e.g. `g ascend` → experiments/ascend).
  # awk does a LITERAL last-field compare, so regex metachars in $arg can't over-match.
  if [[ -n $arg && $arg != */* ]]; then
    local -a base_hits
    base_hits=("${(@f)$(awk -F/ -v n="$arg" '$NF==n' "$_GIT_REPOS_CACHE" 2>/dev/null)}")
    if [[ ${#base_hits} -eq 1 && -n $base_hits[1] ]]; then cd "$GIT_ROOT/$base_hits[1]"; return; fi
  fi
  pick=$(fzf --select-1 --exit-0 --height=60% --layout=reverse --border --query="$arg" \
            --preview 'git -C $GIT_ROOT/{} log --oneline -8 --color=always 2>/dev/null; echo; ls -la $GIT_ROOT/{}' \
            < "$_GIT_REPOS_CACHE")
  if [[ -n $pick ]]; then
    cd "$GIT_ROOT/$pick"
  else
    [[ -n $arg ]] && print -u2 -- "g: no name match for \"$arg\" — try:  gs $arg  (semantic search by meaning)"
    return 1
  fi
}

# gc [filter] → cd into the repo (same picker as g) AND launch Claude there.
gc() { g "$@" && claude }

# Completion source: every cached repo path. fzf-tab renders it as a live,
# per-keystroke-narrowing list under the cursor; the full path disambiguates
# any colliding basenames (e.g. the two the-dreaming-repo clones).
_g_repos() {
  [[ -f $_GIT_REPOS_CACHE ]] || grefresh >/dev/null
  local -a repos; repos=( ${(f)"$(<$_GIT_REPOS_CACHE)"} )
  compadd -a repos
}
compdef _g_repos g
compdef _g_repos gc

# Preview pane: recent commits + listing of the highlighted repo.
zstyle ':fzf-tab:complete:(g|gc):*' fzf-preview \
  'git -C $GIT_ROOT/$word log --oneline -8 --color=always 2>/dev/null; echo; ls -la $GIT_ROOT/$word'

### ─── gs / gsc: SEMANTIC repo search (meaning, not spelling) ──────────
# g matches letters; gs matches MEANING. It routes your phrase through headless
# Claude (Max plan → zero marginal cost) to rank repos by what they ARE, then
# opens the shortlist in fzf. Bridges concept→repo that fzf can't: nintendo→snes,
# manipulator→lidar-robot-arm. Slower than g (~3-5s — an LLM is in the loop).
# Lean flags (--strict-mcp-config, --setting-sources '') skip MCP servers and
# CLAUDE.md so it starts fast and isn't swayed by global instructions.
gs() {
  command -v claude >/dev/null || { print -u2 -- "gs: claude CLI not found"; return 1 }
  [[ -f $_GIT_INDEX_CACHE ]] || gindex >/dev/null
  local query="$*"
  [[ -n $query ]] || { print -u2 -- "usage: gs <what the project is about>"; return 1 }
  print -u2 -r -- "gs: asking Claude about \"$query\"…"
  local ranked
  ranked=$(claude -p "You are a repo router. Each line below is a repo: a PATH, a TAB, then a description of what it is. Return the PATHS (the part before the tab, copied verbatim) most relevant BY MEANING to this query: \"$query\". Rank by the descriptions, using world knowledge (e.g. SNES is a Nintendo console; a robot arm is a manipulator). Output ONLY those paths, one per line, best first, max 12, no commentary or markdown. If none fit, output nothing.

REPOS:
$(<$_GIT_INDEX_CACHE)" --model sonnet --strict-mcp-config --setting-sources '' --output-format text 2>/dev/null \
    | grep -Fxf "$_GIT_REPOS_CACHE")   # keep only verbatim, real repo paths (drop any hallucination)
  [[ -n ${ranked//[[:space:]]/} ]] || { print -u2 -- "gs: nothing relevant to \"$query\""; return 1 }
  local pick
  pick=$(print -r -- "$ranked" | fzf --select-1 --exit-0 --height=60% --layout=reverse --border \
           --prompt="gs:$query> " \
           --preview 'git -C $GIT_ROOT/{} log --oneline -8 --color=always 2>/dev/null; echo; ls -la $GIT_ROOT/{}')
  [[ -n $pick ]] && cd "$GIT_ROOT/$pick"
}

# gsc <phrase…> → semantic search, then launch a Claude session in the pick.
gsc() { gs "$@" && claude }

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
# <<< grok installer <<<
