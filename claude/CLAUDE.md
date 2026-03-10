# User Environment

## Shell & Terminal

- Shell: zsh with Prezto framework and Powerlevel10k prompt (two-line: ╭─ prefix + ❯ command line)
- Terminal: iTerm2, almost always running inside tmux
- tmux prefix: Ctrl-B. Key bindings of note: prefix+o copies last command output,
  prefix+/ for hint-mode (vimium-style), {/} in copy mode navigates between ❯ prompts

## Preferred CLI Tools

Prefer these over standard alternatives when suggesting commands:

| Preferred | Instead of | Notes |
|-----------|-----------|-------|
| `fd` | `find` | respects .gitignore, faster |
| `bat` | `cat` | syntax highlighting, line numbers |
| `eza` / `ll` | `ls` | `ll` = `eza -l --git --header` |
| `rg` | `grep` | ripgrep, respects .gitignore |
| `z <query>` | `cd` | zoxide, jumps to frecent dirs |
| `zi` | interactive cd | zoxide interactive fzf picker |
| `git-delta` | default pager | already configured, diff output is rich |
| `yq` | manual YAML editing | read/write YAML, JSON, XML, CSV, TOML |
| `duckdb` | writing scripts to process data | SQL on CSV/JSON/Parquet files directly, no setup |
| `http`/`https` | `curl` | httpie — readable HTTP requests and responses |
| `tldr` | `man` | concise command examples (tlrc client) |
| `semgrep` | writing grep pipelines for code | structural code search with language-aware patterns |

Prefer these tools over writing scripts. Use `duckdb` to query/transform structured data, `yq` for config file manipulation, `semgrep` for code pattern matching, `http` for API calls. Combine with `jq`, `fzf`, `rg`, `fd` for pipelines.

fzf is wired to: Ctrl-T (files), Ctrl-F (dirs/cd), Ctrl-R (atuin history search).
Tab completion is powered by fzf-tab with tmux popups and bat/eza previews.

## Git Workflow

- `gs` = `git status` — also populates scmpuff numbered refs ($e1, $e2, ...)
- `sw` = `git checkout`
- `br` = `git branch`
- `up` = `git fetch && git rebase origin/main`
- `uploc` = `git rebase origin/main`
- scmpuff: after `gs`, files are numbered. `$e1`, `$e2`, etc. are the file paths.
- `ge <cmd> 1 2` expands numbers to scmpuff refs for any command: `ge vim 1 2` → `vim $e1 $e2`
- `lgv 1` and `lv 1` (neovim variants) auto-expand numbers without needing `ge`

## Editors

- `lgv` = graphical Neovim (GUI)
- `lv` = CLI Neovim
- `vim` = vim fallback
- `$EDITOR` = vim

## Dotfiles & Config Strategy

- All configs live in `~/dotfiles/` and symlink to their true paths
- Never create configs directly in `~/.config/`, `~/`, etc. — always create in dotfiles first, then symlink
- This repo is open source; work-specific customizations are done locally on each machine

## Coding Preferences

- Concise and focused — don't add features beyond what was asked
- No docstrings, comments, or type annotations on code I didn't change
- No over-engineering or premature abstractions — three similar lines beats a helper function
- Don't add error handling for scenarios that can't happen
- Prefer editing existing files over creating new ones
- No backwards-compatibility shims for removed code

## Commit / Git Behavior

- NEVER commit without explicit instruction
- NEVER push without explicit instruction
- Ask before any destructive git operation (reset --hard, force push, branch delete, etc.)

## Python

- `python` and `pip` are aliased to `python3` / `pip3`
- Virtual environments are common; activate per project
