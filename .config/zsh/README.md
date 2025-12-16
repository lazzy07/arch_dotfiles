Here’s what each alias does, **mapped directly to the underlying tmux command** and how you’d actually use it in practice.

---

## `alias t='tmux'`

**What it does:**
Just a shorthand for the `tmux` command itself.

**Why it’s useful:**
Saves typing and keeps muscle memory short.

```bash
t new
t ls
t attach
```

---

## `alias ta='tmux attach'`

**What it does:**
Attaches your terminal to an **existing tmux session**.

**Behavior:**

* If there is **only one session**, tmux attaches to it.
* If there are **multiple sessions**, tmux will usually error and ask you to specify one.

```bash
ta
```

Equivalent to:

```bash
tmux attach
```

---

## `alias tat='tmux attach -t'`

**What it does:**
Attaches to a **specific tmux session by name or ID**.

**`-t` means “target session”**

```bash
tat work
tat 0
```

Equivalent to:

```bash
tmux attach -t work
```

---

## `alias tl='tmux list-sessions'`

**What it does:**
Lists all running tmux sessions.

**Typical output:**

```text
work: 3 windows (created Wed)
notes: 1 windows (attached)
```

Usage:

```bash
tl
```

Equivalent to:

```bash
tmux ls
```

---

## `alias tn='tmux new -s'`

**What it does:**
Creates a **new tmux session with a specific name**.

**`-s` means “session name”**

```bash
tn dev
```

Equivalent to:

```bash
tmux new -s dev
```

If a session with that name already exists, tmux will fail.

---

## `alias tk='tmux kill-session -t'`

**What it does:**
Kills **one specific tmux session**.

**Use with care** — this terminates all windows and panes in that session.

```bash
tk dev
```

Equivalent to:

```bash
tmux kill-session -t dev
```

---

## `alias tka='tmux kill-server'`

**What it does:**
Kills **the entire tmux server**, i.e. **all tmux sessions**.

🚨 **Dangerous if you forget it’s running** 🚨

```bash
tka
```

Equivalent to:

```bash
tmux kill-server
```

---

## Mental model (important)

Think of tmux like this:

* **Server** → runs in the background
* **Sessions** → independent workspaces
* **Windows** → tabs
* **Panes** → splits

| Alias | Scope   | Effect                   |
| ----- | ------- | ------------------------ |
| `ta`  | session | attach to one            |
| `tat` | session | attach to a specific one |
| `tl`  | server  | list sessions            |
| `tn`  | session | create one               |
| `tk`  | session | kill one                 |
| `tka` | server  | kill everything          |
