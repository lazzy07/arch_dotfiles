# tmux Keybindings (LazyVim-friendly)

This tmux configuration is designed to work **seamlessly with LazyVim / Neovim**, keeping navigation intuitive and minimizing key conflicts.

- **Prefix:** `Ctrl + Space`
- **Navigation:** Vim-style
- **Splits:** Open in current working directory
- **Status bar:** Top-aligned, session on the right (themed via matugen)
- **Clipboard:** System clipboard supported (Wayland/X11)

---

## Prefix

| Action | Key |
|-----|-----|
| tmux prefix | `Ctrl + Space` |
| Send literal prefix | `Ctrl + Space`, `Ctrl + Space` |

---

## Configuration & Help

| Action | Key |
|-----|-----|
| Reload tmux config | `Prefix + r` |
| Command prompt | `Prefix + :` |
| List windows | `Prefix + w` |
| Choose session | `Prefix + S` |

---

## Window Management

| Action | Key |
|-----|-----|
| New window (cwd) | `Prefix + c` |
| Rename window | `Prefix + r` |
| Next window | `Prefix + n` / `Alt + ]` |
| Previous window | `Prefix + p` / `Alt + [` |
| Kill window | `Prefix + &` |

---

## Pane Management

### Splitting (cwd-aware)

| Action | Key |
|-----|-----|
| Vertical split | `Prefix + -` |
| Horizontal split | `Prefix + |` |
| Horizontal split (alt) | `Prefix + v` |
| Vertical split (alt) | `Prefix + h` |

### Navigation

| Action | Key |
|-----|-----|
| Move left | `Prefix + h` |
| Move down | `Prefix + j` |
| Move up | `Prefix + k` |
| Move right | `Prefix + l` |

**Without prefix (recommended):**

| Action | Key |
|-----|-----|
| Move pane | `Alt + h/j/k/l` |

> This avoids conflicts with LazyVim’s `<Ctrl + h/j/k/l>` split navigation.

---

### Resizing Panes

| Action | Key |
|-----|-----|
| Resize left | `Prefix + ←` |
| Resize right | `Prefix + →` |
| Resize up | `Prefix + ↑` |
| Resize down | `Prefix + ↓` |

(Keys repeat while held.)

---

### Zoom & Rearrangement

| Action | Key |
|-----|-----|
| Toggle zoom (maximize pane) | `Prefix + z` |
| Swap pane up | `Prefix + <` |
| Swap pane down | `Prefix + >` |
| Toggle synchronize panes | `Prefix + y` |

---

## Copy Mode (Vi-style)

| Action | Key |
|-----|-----|
| Enter copy mode | `Prefix + [` or `Enter` |
| Start selection | `v` |
| Line selection | `V` |
| Copy selection | `y` |
| Copy → system clipboard | `Y` |
| Paste | `Prefix + p` |

Clipboard support:
- **Wayland:** `wl-copy`
- **X11:** `xclip`

---

## Session Management

| Action | Key |
|-----|-----|
| Rename session | `Prefix + s` |
| Kill session | `Prefix + X` |
| Detach | `Prefix + Ctrl + d` |

---

## Miscellaneous

| Action | Key |
|-----|-----|
| Clear pane | `Prefix + K` |
| Lock tmux | `Prefix + Ctrl + x` |
| Refresh client | `Prefix + Ctrl + l` |

---

## Design Notes

- Pane navigation intentionally mirrors Vim.
- `Alt + h/j/k/l` is preferred for tmux to avoid LazyVim conflicts.
- Status bar theming is **Material You–style** via **matugen**.
- No clock or hostname clutter—session identity is shown on the right.

---

## Requirements

- **tmux ≥ 3.2**
- **Nerd Font** (JetBrainsMono Nerd Font recommended)
- Clipboard tool:
  - Wayland: `wl-copy`
  - X11: `xclip`

---

## Tips

- If a binding doesn’t work, check:
  ```bash
  tmux list-keys
  tmux show-messages -JT

