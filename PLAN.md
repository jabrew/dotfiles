# Improvement Plan

Items to work through. Check off as done.

---

## Done

### [x] 3. fast-syntax-highlighting examples in TEST-CHECKLIST.md
Added concrete example commands showing each color in context.

### [x] 9. tmux-fingers key binding conflict
Fixed: `@fingers-key /` moves fingers to `prefix + /`. `prefix + f` stays as find-window.

### [x] 10. tmux: extended-keys, terminal-features, default-terminal, history-limit
- `default-terminal`, `history-limit`, `terminal-features` — already set correctly.
- `extended-keys on` — added. Allows distinguishing Ctrl+i from Tab, etc.

### [x] 7a. tmux prefix+Y — strip trailing newline
Overridden with explicit binding that pipes cwd through `tr -d '\n'`.

### [x] 6 (partial). ge command
Added `ge` shell function: `ge vim 1 2` expands to `vim $e1 $e2`. Works for any command.

---

## Needs discussion / ask before acting

### [ ] 4. `ll` alias — eza --hyperlink on Linux
Does eza silently ignore `--hyperlink` on terminals without OSC 8 support, or does it output garbage?
Need to test or check eza docs. If harmless, bind globally. If not, keep macOS-only.
**Action: check before changing.**

### [ ] 7b. Copy last command output
Bigger ask: detect where the prompt was, capture everything between then and now.
Could use tmux pane history + prompt marker. Several approaches, each with tradeoffs.
**Action: propose approaches and let user decide.**

### [ ] 8. extrakto — config review
Research done. Key findings:
- `@extrakto_filter_order` — set the default filter and order (e.g. `line word all`)
- `@extrakto_copy_key` / `@extrakto_insert_key` — rebind copy vs insert (default: enter=copy, tab=insert). Note: these are fzf keys inside the popup, not tmux keys, so Shift-Enter isn't straightforward.
- `@extrakto_open_key ctrl-o` — open selection in browser/finder
- `@extrakto_edit_key ctrl-e` — open selection in $EDITOR directly
- `@extrakto_grab_key ctrl-g` — cycle grab area (recent pane / full pane / window)
- `@extrakto_popup_size` — can set size (already handled by popup sizing)
- `@extrakto_filter_order word all line` — change which filter is shown first
- Multi-select with Shift-Tab (joins with spaces or newlines)
- Custom filters via `~/.config/extrakto/extrakto.conf`
- `@extrakto_clip_tool_run tmux_osc52` — useful for SSH sessions (copies to local clipboard)
Separate bindings for line vs word not possible without fork. Tab cycling is the intended UX.
**Action: apply any useful config tweaks, discuss with user.**

---

## Needs design / more involved

### [ ] 1. fd exclude lists for Ctrl-T and Ctrl-F
fd already respects .gitignore. For directories without one (e.g. ~, /), need a global ignore file.
Approach: create `~/.config/fd/ignore` (or `~/.fdignore`) with common noise:
  - node_modules, .git, Library, .cache, __pycache__, .venv, dist, build, .Trash
This applies everywhere fd is called including fzf keybindings.
Also consider: only exclude `Library` when cwd is `~` specifically (harder, probably not worth it).
**Action: create fdignore file in dotfiles + symlink.**

### [ ] 2. Frecency file picker (zi equivalent for files)
zi uses zoxide's directory database. No direct equivalent for files built-in.
Options:
  a. `fasd -f` tracking (we removed fasd - would need to re-add just the file tracking piece)
  b. Custom widget: fzf over recently modified files (`fd --changed-within 7d`)
  c. `fre` tool — like zoxide but for files (frecency-ranked)
  d. Use atuin: `Ctrl-R vim` surfaces recent vim commands, then edit the path
The cleanest standalone solution is probably (c) `fre` or (b) a custom fd+fzf widget sorted by mtime.
**Action: propose and let user pick approach.**

### [ ] 5. VCS-agnostic gs/sw/br aliases
No great existing tool covers git+hg universally.
Approach: small shell scripts in `dotfiles/bin/` that detect VCS type and dispatch.
  - `gs` → checks for `.git`, `.hg`, `.svn`, dispatches to `git status` / `hg status` / etc.
  - `sw` → `git checkout` / `hg update`
  - `br` → `git branch` / `hg branches`
Need to create `dotfiles/bin/` and add it to PATH. Mirrors Windows pattern user mentioned.
**Action: create dotfiles/bin/, write wrapper scripts.**

### [ ] 6. scmpuff — extend numbered args to more commands
scmpuff sets `$e1`, `$e2`, etc. env vars after `git status`. User wants shorthand `1` → `$e1`
in commands like `git show -- 1`, `vim 1`, `lgv 1`.
Approach: wrap the relevant commands as shell functions that expand numeric-only args to `$eN`.
E.g.:
```zsh
vim() {
  args=("${@//(#m)[0-9]##/${(P)${:-e$MATCH}}}")
  command vim $args
}
```
Need to wrap: vim, nvim, lgv, and possibly intercept bare numeric args to git subcommands.
**Action: implement wrapper functions in zshrc.**
