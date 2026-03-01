# Things To Try

A tour of all the non-standard tools and customizations in this setup. Run `tmux source-file ~/.tmux.conf` and `exec zsh` first to pick up any recent changes.


## Zsh - Fuzzy Finding (fzf)

All fzf pickers open in tmux popups when running inside tmux.

- **Ctrl-T** - Fuzzy find files under cwd. Paste the selected path onto the command line. Shows a bat preview of the file.
- **Ctrl-F** - Fuzzy find directories under cwd and cd into the selection. Shows an eza tree preview. (Rebound from the default Alt-C.)
- **Ctrl-R** - Opens atuin's history search TUI (see Atuin section below).

Try: `vim ` then `Ctrl-T` to fuzzy-pick a file to edit.
Try: `Ctrl-F` from your home directory to jump somewhere deep.


## Zsh - Tab Completion (fzf-tab)

All tab completions are powered by fzf in a tmux popup.

- Type any command and hit `Tab` - completion list appears in a popup
- `/` on a selected directory drills into it (continuous completion)
- `<` and `>` cycle between completion groups
- `cd` and `ls` completions show an eza directory listing preview

Try: `cd ~/` then `Tab`, then type a few chars to filter, then `/` to drill in.
Try: `git checkout ` then `Tab` to see branches in a fuzzy picker.
Try: `kill ` then `Tab` to fuzzy-pick a process.


## Zsh - Directory Jumping (zoxide)

Remembers directories you've visited, ranked by frequency and recency. Database starts empty and gets smarter over time.

- `z <query>` - Jump to best match (e.g., `z dot` jumps to `~/dotfiles`)
- `zi` - Interactive fzf picker over all remembered directories
- `z <query1> <query2>` - Multiple terms narrow the match

Try: `cd` around to a few directories, then use `z` with partial names to jump back.


## Zsh - History Search (atuin)

- **Ctrl-R** - Opens atuin's full-screen TUI
- Type to fuzzy filter, `Enter` to execute, `Tab` to paste without executing
- **Ctrl-S** (inside TUI) - Cycle search mode: fuzzy / prefix / fulltext / subsequence
- **Ctrl-R** (inside TUI) - Cycle filter: global / host / session / directory
- **Ctrl-D** (inside TUI) - Delete a history entry
- **Up arrow** - Normal zsh previous-command behavior (not atuin)

Try: `Ctrl-R`, then type a partial command. Try `Ctrl-R` again to switch to directory filter.
Try: cd into a project, then `Ctrl-R` and filter by directory - you'll only see commands run there.


## Zsh - Syntax Highlighting (fast-syntax-highlighting)

Active as you type - no action needed. Colors:
- **green** - valid command / alias / function
- **red bold** - unknown command
- **yellow** - strings, reserved words (if/while/for)
- **cyan** - options (--flag, -f)
- **magenta** - file/directory paths
- **magenta underline** - directory paths specifically
- **blue bold** - glob patterns (*, **, ?)
- **gray** - comments (#)

Try typing these (don't run them, just observe):
```
ls --color=always ~/dotfiles          # green cmd, cyan option, magenta path
fakecommand --option "a string"       # red cmd, cyan option, yellow string
for f in *.zsh; do echo $f; done     # yellow keywords, blue glob
git status # show changes             # gray comment
```


## Zsh - Other Keybindings

- **Ctrl-P / Ctrl-N** - Prefix-only history search (type `git`, then Ctrl-P cycles through commands starting with `git`)
- **Option-F / Option-B** - Forward/backward word (macOS Option key)
- `ll` - `eza -l --git --hyperlink --header` (macOS only)
- `rgp` - `rg -t py` (ripgrep for Python files only)
- `gs`, `sw`, `br` - git status, checkout, branch


## Zsh - scmpuff

Adds numbered shortcuts to git status output.

Try: `gs` (git status) - files are numbered. Then use the numbers in git commands (e.g., `git add 1 2`).


## Zsh - git-delta

Git diffs and logs automatically use delta for syntax-highlighted, side-by-side output.

Try: Make a change to a file and run `git diff`.
Try: `git log -p` to see commit diffs with syntax highlighting.


## tmux - Copy Mode (vi bindings + tmux-yank)

- **prefix + [** - Enter copy mode (navigate with vi keys: hjkl, /, ?, n, N, Ctrl-u, Ctrl-d)
- **v** - Start selection
- **V** - Select whole line
- **Ctrl-v** - Toggle rectangle/block selection
- **y** - Yank selection to system clipboard
- **q** - Exit copy mode
- **prefix + y** (normal mode) - Copy current command line to clipboard
- **prefix + Y** (normal mode) - Copy current working directory to clipboard

Try: Run `ls -la`, then `prefix + [`, navigate to a path, `v` to start selection, move to end, `y`. Paste in another app.
Try: `prefix + y` to grab whatever's on your command line.


## tmux - extrakto (token extraction)

- **prefix + Tab** - Opens fzf picker over all text visible in the current pane
- Type to fuzzy filter
- **Ctrl-F** - Cycle extraction mode: word → path → url → line → all (mode shown in header)
- **Tab** - Insert the selection at your cursor
- **Enter** - Copy the selection to clipboard instead
- **Ctrl-G** - Cycle grab area: current pane recent → current pane full → all panes
- **Ctrl-E** - Open selection in $EDITOR
- **Ctrl-O** - Open selection with OS default (browser for URLs, Finder for paths)
- **Shift-Tab** - Multi-select (selections joined with spaces/newlines)

To pick a whole line: open with `prefix + Tab`, press `Ctrl-F` until header shows "line", then Tab/Enter.

Try: Run `git log --oneline`, open extrakto, press `Ctrl-F` a few times to reach "line" mode, pick a commit.
Try: Run any command with file paths in the output, then `prefix + Tab` to grab one.


## tmux - tmux-fingers (vimium-style hints)

- **prefix + F** - Highlights all copyable items (paths, URLs, hashes, IPs, etc.) with letter hints
- Type the hint letters to copy that item to clipboard

Try: Run `git log --oneline` or `ls -la`, then `prefix + F`. Type the hint next to a hash or filename.

Note: tmux-fingers needs to compile on first use (requires Rust). If it fails, run `cargo` to check if Rust is installed.


## tmux - Window Navigation

- **Shift-Left / Shift-Right** - Previous/next window
- **Alt-1 through Alt-9** - Jump to window by number
- **prefix + ;** - Command prompt
- **prefix + :** - Last pane

Try: Open a few windows with `prefix + c`, then jump between them with Alt-1, Alt-2, etc.


## tmux - Other Features

- **allow-passthrough** - Enabled for terminal image protocols (SIXEL, iTerm2 inline images)
- **escape-time 10ms** - Fast escape key response (important for vim)
- **focus-events** - Vim/neovim can detect when tmux pane gains/loses focus
- **true color (RGB)** - Full 24-bit color support in terminal apps


## Tools Reference

| Tool | What it does | Replaces |
|------|-------------|----------|
| fzf | Fuzzy finder for files, dirs, history | manual find/grep |
| fzf-tab | Fuzzy tab completion | zsh default menu |
| zoxide | Directory jumping by frecency | fasd, autojump |
| atuin | Shell history with TUI | built-in Ctrl-R |
| fast-syntax-highlighting | Command-line syntax coloring | zsh-syntax-highlighting |
| fd | Fast file finder | find |
| ripgrep (rg) | Fast content search | grep |
| bat | Cat with syntax highlighting | cat |
| eza | Modern ls with git integration | ls |
| git-delta | Syntax-highlighted git diffs | default git pager |
| scmpuff | Numbered git status | - |
| tmux-yank | Cross-platform clipboard in tmux | manual pbcopy/xclip |
| extrakto | Token extraction from tmux panes | manual copy-paste |
| tmux-fingers | Vimium-style hint copying in tmux | manual copy-paste |


## Plugin Management

Plugins are pinned in `plugins.lock` and installed with `install-plugins.sh`. No plugin manager (TPM) is used.

```sh
./install-plugins.sh            # Install all at pinned commits
./install-plugins.sh --update   # Pull latest and print new SHAs
```
