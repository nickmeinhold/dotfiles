# dotfiles

Personal macOS shell configuration. The repository is small on purpose — its
centre of gravity is [`.zshrc`](.zshrc), which sets up PATHs for the SDKs I use,
wires in [`fzf`](https://github.com/junegunn/fzf) fuzzy-finding, and adds a suite
of **git-repo navigation** commands (`g` / `gc` / `gs`) for jumping between the
hundreds of repos under `~/git`.

> ⚠️ **This repo is public. No secrets live here.** API keys and tokens are kept
> in `~/.claude/.env` (outside the repo) and sourced at shell start. See
> [Secrets](#secrets).

## What's here

| File | Purpose |
| --- | --- |
| [`.zshrc`](.zshrc) | The whole shell config — PATHs, aliases, fzf, repo navigation. |
| [`create_symlinks.sh`](create_symlinks.sh) | Symlinks `.zshrc` into `$HOME`. |
| [`install.sh`](install.sh) | Notes on the SDKs installed manually into `~/SDKs`. |
| [`.gitignore`](.gitignore) | Keeps secret files (`.env`, `*.secrets`) out of the repo. |

## Install

```sh
git clone https://github.com/nickmeinhold/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./create_symlinks.sh      # ln -svf ~/.dotfiles/.zshrc ~
```

Then provision secrets (see below) and open a new shell.

### Dependencies the `.zshrc` expects

- [`fzf`](https://github.com/junegunn/fzf) — fuzzy finder (`brew install fzf`).
- [`fzf-tab`](https://github.com/Aloxaf/fzf-tab) — cloned to `~/.zsh/fzf-tab`;
  turns TAB completion into a live fzf picker.
- [`jq`](https://stedolan.github.io/jq/) — used by `gindex` to read `package.json`.
- The `claude` CLI — used by `gs` for semantic repo search.
- SDKs under `~/SDKs` (Flutter, Dart, gcloud) and the usual toolchains (Go, Rust
  via `~/.cargo`, Node via `nvm`, Android Studio's bundled JRE). Paths are added
  defensively, so a missing SDK just means that path does nothing.

## Secrets

Because this repo is **public**, no credentials are committed. The `.zshrc` loads
them from `~/.claude/.env` at shell start, exporting each so child processes see
them:

```sh
[[ -f ~/.claude/.env ]] && { set -a; source ~/.claude/.env; set +a; }
```

To provision a new machine, create `~/.claude/.env` (chmod 600) with the keys you
need, e.g.:

```sh
export CLAUDE_REVIEWER_PAT="<your-github-pat>"
export CLAUDE_PM_PAT="<your-github-pat>"
```

`.gitignore` blocks `.env`, `*.secrets`, and `*.local` so a stray secret file can
never be staged.

## The `.zshrc`, section by section

### Prompt & aliases

A minimal prompt (`%1~ %#`) plus:

- `rc` — open `~/.zshrc` in your editor.
- `grsh1` — `git reset --soft HEAD~1` (undo the last commit, keep the changes).

### fzf & fzf-tab

`fzf --zsh` enables **Ctrl-R** (fuzzy history), **Ctrl-T** (fuzzy file picker),
and **Alt-C** (fuzzy `cd`). `fzf-tab` then hands ordinary TAB completion to fzf,
so every completion menu becomes a live, narrowing picker.

### Repo navigation: `g` / `gc` / `gs`

Jump between the git repos under `$GIT_ROOT` (`~/git`) without typing full paths.
These are shell **functions** (not scripts) because only in-shell code can change
your working directory.

| Command | What it does |
| --- | --- |
| `g <name>` | `cd` into a repo. Resolution order: exact path under `$GIT_ROOT` → **basename match** (a bare name matching exactly one nested repo by its final path segment, e.g. `g ascend` → `experiments/ascend`) → interactive `fzf` picker for anything ambiguous. |
| `gc <name>` | Same as `g`, then launches `claude` in that repo. |
| `gs <phrase>` | **Semantic** search — routes your phrase through headless Claude to rank repos by *what they are* (e.g. `gs nintendo` finds an SNES project), then opens the shortlist in fzf. Slower (~3-5s; an LLM is in the loop). |
| `gsc <phrase>` | `gs`, then launches `claude` in the pick. |
| `grefresh` | Rebuild the repo cache `~/.cache/git-repos.txt`. **Run after cloning a new repo** — the cache only auto-builds when missing, not when stale. |
| `gindex` | Rebuild the semantic index `~/.cache/git-repos-index.tsv` (`path<TAB>description`), mining each repo's `<title>` / README H1 / `package.json` / `pubspec.yaml` / `CLAUDE.md`. Runs automatically inside `grefresh`. |

TAB completion on `g`/`gc` is served from the repo cache with a preview pane
showing recent commits and a directory listing of the highlighted repo.

#### How the caches work

`grefresh` walks `~/git` with two layers of pruning: dependency/build dirs
(`node_modules`, `Pods`, `.build`, `DerivedData`, …) are skipped wholesale, and
each real repo prunes its own subtree so nested submodules aren't listed as
separate projects. `gindex` then builds a grounded, LLM-free description per repo
so `gs` can route by meaning rather than by an opaque directory name.

## Relevant Resources

- [Getting Started With Dotfiles](https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789)
- [fzf](https://github.com/junegunn/fzf) · [fzf-tab](https://github.com/Aloxaf/fzf-tab)
