# dotfig

dotfig (dotfiles + configuration) sets up a Mac for programming, and for
working alongside coding agents. One clone and two commands install the
apps and command-line tools, link the dotfiles, and configure the
terminals, editors, languages, and agents to work together, in one color
scheme.

It's opinionated on purpose: the tools are already chosen and set up to
fit together, so you can install it and get to work, and change what you
don't like.

## What it sets up

### Terminals

- **[cmux](https://www.cmux.dev/) for coding agents.** Each Claude Code or
  Codex session gets its own cmux workspace, so the sidebar is a dashboard
  of every agent: whether it's working or needs you, its model, and how
  much of its context it has used, in the same format for both agents.
  Links clicked in cmux, and `open https://...` in a cmux terminal, open in
  your own browser, with your logins, password manager, and extensions,
  rather than cmux's built-in one.
- **iTerm2 and tmux for everything else**: builds, git, editing. In iTerm2,
  every new shell attaches to one tmux session, which tmux-resurrect and
  tmux-continuum save in the background and restore after a reboot. The
  prefix is `C-a`; `\` and `-` split (in the current directory), `C-a C-a`
  cycles panes, and copy mode uses vi keys. Windows are flagged when they
  ring the bell, as agents do when they need input.
- **Ghostty's config** (`ghostty/config.ghostty`), which cmux reads too: the
  theme, Menlo 18, no bell sound, and a steady block cursor.

### One color scheme

Gruvbox Dark everywhere: iTerm2, cmux and Ghostty, tmux, the zsh prompt,
Claude Code (a custom theme), and Codex (its built-in `gruvbox-dark`).

### Shell

zsh, kept fast and simple (no framework):

- PATH, editor, and pager are set in `.zshenv`, which every zsh reads,
  so the non-interactive shells that agents, editors, and scripts start
  find the same tools as you do.
- A prompt with the user, host, folder, and git branch, marked `✗` when
  there are uncommitted changes:
  `karalekas@mbp ➜ dotfig git:(main) ✗`.
- Large shared history, case-insensitive completion, up and down arrows
  that search history for what you've typed, and syntax highlighting.
- Short aliases for git (`gs`, `ga`, `gaa`, `gb`, `gc`, `gcb`, `gcm`,
  `gdiff`, `gr`) and for editing this repo's files (`zshrc`, `aliases`,
  `tmuxconf`, `vimrc`, `gitconfig`, `emacsconf`).

### Coding agents

[Claude Code](https://claude.com/claude-code) and
[Codex](https://github.com/openai/codex), set up to match each other and
the terminal:

- Claude Code's status line shows `model | Context: N%`, and both agents
  put their model and context used in the cmux sidebar (Claude Code through
  its status line, Codex through a hook).
- Codex's terminal title is `codex` plus the conversation's title, like
  Claude Code's, and its status line shows the model and context used.
- Both use Gruvbox Dark.

### Editors

- **vim**: four-space indentation with spaces, syntax highlighting,
  filetype indentation, and reopening a file where you left it.
- **Emacs**: SLIME for Common Lisp (with SBCL), paredit for Lisp editing,
  MELPA, the Tomorrow Night theme, saved minibuffer history, and a
  full-screen window with a larger font. Its packages are in
  `emacs/.emacs.d`.
- **Sublime Text**: DejaVu Sans Mono 14, and spaces instead of tabs.

### Languages

- **Python** with [uv](https://docs.astral.sh/uv/), which installs Python
  versions and manages each project's environment and dependencies: `uv
  run script.py`, `uv add <package>`, `uv tool install <tool>`. uv uses only
  the Pythons it installs, never the system's.
- **Common Lisp** with SBCL, from Homebrew, and
  [Quicklisp](https://www.quicklisp.org). `lisp/` sets up Quicklisp (with
  `~/code` as a local-projects folder, so `(ql:quickload ...)` finds
  projects you've cloned there) and SLIME for Emacs. The Brewfile also
  installs gfortran (`gcc`) and LAPACK, which
  [MAGICL](https://github.com/quil-lang/magicl) needs for projects that use
  it, such as quilc and QVM; MAGICL builds its own copy of expokit with them.

### git and macOS

- **git**: vim as the editor, `main` for new repos, aliases (`undo`,
  `unstage`, `uncheckout`, `last`, `commitlog`, `awesomeness` for an
  interactive rebase), and worktree aliases (`wt`, `wta`, `wtl`, `wtr`), for
  example one worktree per agent working in parallel. Your name and email
  go in an untracked file (see Install).
- **macOS**: very fast key repeat, and cmux's minimal title bar.

## Install

On a new Mac:

```sh
# 1. git (with the Xcode command-line tools) and Homebrew (https://brew.sh)
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. this repo
git clone https://github.com/karalekas/dotfig.git ~/code/dotfig
cd ~/code/dotfig

# 3. apps and command-line tools (macos/Brewfile): cmux, iTerm2, Codex,
#    Emacs, Sublime Text, SBCL, tmux, uv, and more
brew bundle --no-upgrade --file macos/Brewfile

# 4. Claude Code (its native installer); then run each agent once, to sign
#    in and create its settings
curl -fsSL https://claude.ai/install.sh | bash
claude
codex
cmux hooks codex install   # Codex status and notifications in cmux

# 5. the dotfiles
./install.sh --dry-run     # preview
./install.sh

# 6. macOS settings that live outside dotfiles
macos/keyboard.sh          # fast key repeat
macos/cmux.sh              # cmux's minimal title bar
```

Then:

- **Set your git identity**, which isn't tracked (`git/.gitconfig` has no
  `[user]` block):

  ```sh
  git config --file ~/.gitconfig.local user.name "Your Name"
  git config --file ~/.gitconfig.local user.email "you@example.com"
  ```

- **Sign in to GitHub** with `gh auth login --web`, then `gh auth setup-git`
  so git uses the same login for private repos.
- **Import the iTerm2 colors**: `open macos/iterm/Gruvbox\ Dark.itermcolors`,
  then pick Gruvbox Dark in iTerm2 > Settings > Profiles > Colors.
- **Open a new terminal**, restart any running Claude Code and Codex
  sessions, and in Codex run `/hooks` and trust the `cmux-usage.sh` entries
  (Codex skips hooks you haven't approved).
- **For Common Lisp**, set up Quicklisp and SLIME: `make -C lisp quicklisp`.

`install.sh` symlinks the files below into your home folder, moving
anything already there to `~/.dotfig-backup/<timestamp>/`. It's safe to
re-run, and re-running it is how to pick up anything it skipped because a
tool wasn't set up yet: it prints `skip:` for those. Both `install.sh` and
`restore.sh` take `--dry-run`.

## Layout

| Repo | Installed as | Notes |
|---|---|---|
| `zsh/.zshenv` | `~/.zshenv` | Every shell, including non-interactive ones: PATH, editor, pager, uv |
| `zsh/.zprofile` | `~/.zprofile` | Re-applies PATH after macOS's `path_helper` |
| `zsh/.zshrc` | `~/.zshrc` | Interactive only: history, completion, keys, prompt, syntax highlighting, tmux in iTerm2 |
| `zsh/lib/` | `~/.zsh/` | `path.zsh`, `prompt.zsh`, `aliases.zsh` |
| `tmux/.tmux.conf` | `~/.tmux.conf` | Plugins in `~/.tmux/plugins` (cloned by `install.sh`), saved sessions in `~/.local/share/tmux/resurrect` |
| `git/.gitconfig` | `~/.gitconfig` | Includes `~/.gitconfig.local` |
| `vim/.vimrc` | `~/.vimrc` | |
| `emacs/` | `~/.emacs`, `~/.emacs.d` | |
| `sublime/Preferences.sublime-settings` | Sublime Text's `Packages/User/` | |
| `ghostty/config.ghostty` | `~/.config/ghostty/config.ghostty` | Read by cmux and Ghostty |
| `cmux/cmux.json` | `~/.config/cmux/cmux.json` | Gruvbox colors for the sidebar, pane borders, and accents; links in your browser |
| `claude/statusline.sh` | `statusLine.command` in `~/.claude/settings.json` | Set by `install.sh` |
| `claude/themes/gruvbox-dark.json` | `~/.claude/themes/` | Selected by `install.sh` (`theme` in `settings.json`) |
| `codex/tui-key.awk` | `[tui]` keys in `~/.codex/config.toml` | Title, status line, and theme, set by `install.sh` |
| `codex/cmux-usage.sh` | hooks in `~/.codex/hooks.json` | Added by `install.sh`, after cmux's own |
| `macos/` | | Brewfile, key repeat, cmux's title bar, iTerm2 colors |
| `lisp/` | | Quicklisp and SLIME setup |
| `archive/` | | Earlier setup scripts (Makefiles, oh-my-zsh, pyenv, building SBCL and expokit from source, Linux packages, PyCharm), kept for reference and not installed |

Claude Code's `settings.json` and Codex's `config.toml` and `hooks.json`
are also written by the agents themselves and by cmux, so `install.sh` sets
only its own keys in them rather than linking the files, and saves the old
values for `restore.sh`.

## Machine-specific settings

These are read if they exist and aren't tracked: `~/.zshenv.local`,
`~/.zshrc.local`, and `~/.gitconfig.local`. Put anything specific to one
machine there, and point installers that want to add lines to shell
startup files at them too.

## Uninstall

```sh
./restore.sh --dry-run   # preview
./restore.sh             # undo the latest install
./restore.sh ~/.dotfig-backup/<timestamp>   # or a specific one
```

`restore.sh` removes the links into this repo, moves the backed-up files
back, and puts back the settings `install.sh` changed. Anything it would
replace goes to `<backup>/displaced/`, so nothing is deleted.
