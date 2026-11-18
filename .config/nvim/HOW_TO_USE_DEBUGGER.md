# How to use the debugger

This config uses [nvim-dap](https://github.com/mfussenegger/nvim-dap) +
[nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) for every language.
The core keybindings are the same everywhere; only the debug *adapter* and
how you tell it what to run change per language. Read
[Core workflow](#core-workflow) once, then jump to your language.

- [Core workflow](#core-workflow)
- [C / C++](#c--c)
- [Rust](#rust)
- [Java](#java)
- [Python](#python)
- [TypeScript / JavaScript / React](#typescript--javascript--react)
- [Electron](#electron)
- [Using a project's `.vscode/launch.json`](#using-a-projects-vscodelaunchjson)
- [Troubleshooting](#troubleshooting)

## Core workflow

1. Open the file you want to debug and set a breakpoint: `<leader>db` on
   the line you want to stop at.
2. Start debugging: `<leader>dc` (Run/Continue). The first time in a
   session, this shows a picker of the available configurations for that
   filetype (e.g. "Launch file" vs "Attach to process") — pick one.
3. [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) opens
   automatically once the session starts: variables/scopes on the left,
   call stack and breakpoints on the right, REPL/console at the bottom.
4. Step through with `<leader>di` (step into), `<leader>do` (step out),
   `<leader>dO` (step over).
5. `<leader>de` (visual or normal mode) evaluates the expression under the
   cursor / selection and shows the result in a popup.
6. `<leader>dt` stops the session. `<leader>du` toggles the DAP UI windows
   manually if you want them out of the way without ending the session.

Full keymap reference:

| Key | Action |
|---|---|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint (prompts for a condition) |
| `<leader>dc` | Run / Continue |
| `<leader>da` | Run with args (prompts for CLI args) |
| `<leader>dC` | Run to cursor |
| `<leader>dg` | Go to line (without executing) |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>dO` | Step over |
| `<leader>dj` / `<leader>dk` | Move down/up a stack frame |
| `<leader>dl` | Re-run the last configuration |
| `<leader>dP` | Pause |
| `<leader>dr` | Toggle the debug REPL |
| `<leader>ds` | Show/select session (when multiple are running) |
| `<leader>dt` | Terminate the session |
| `<leader>dw` | Hover widgets (inspect value under cursor) |
| `<leader>du` | Toggle DAP UI |
| `<leader>de` | Eval expression under cursor/selection |
| `<leader>td` | Debug the nearest test (via neotest, where available) |

## C / C++

**Adapter:** [codelldb](https://github.com/vadimcn/codelldb) — installed
automatically by Mason the first time you open a `.c`/`.cpp` file (check
with `:Mason`, look for `codelldb`).

**Requirements:** a `compile_commands.json` so clangd/the debugger
understand your build. With CMake:

```sh
cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build build
```

(clangd here is configured to look for `compile_commands.json` inside
`build/` specifically — see `lua/plugins/lsp.lua`.)

**Debugging:**

1. Build your binary first — nvim-dap doesn't build for you.
2. `<leader>db` on the line you want to break at.
3. `<leader>dc` → pick **"Launch file"** → type the path to your compiled
   executable when prompted.
4. To attach to an already-running process instead, pick **"Attach to
   process"** and select it from the picker.

There are also `cppdbg`-style defaults (gdb-based, including
"Attach to gdbserver") available in the same picker, auto-registered by
`mason-nvim-dap`; codelldb is the recommended default unless you
specifically need gdb.

If you have a real VSCode-style `.vscode/launch.json` in your project (see
[below](#using-a-projects-vscodelaunchjson)), its entries show up in the
same picker automatically, on top of the defaults above — nothing extra to
load.

## Rust

**Adapter:** codelldb, via
[rustaceanvim](https://github.com/mrcjkb/rustaceanvim) — installed
automatically the first time you open a `.rs` file in a Cargo project.

**Requirements:** `rust-analyzer` on your `$PATH` (install via `rustup
component add rust-analyzer` if `rustaceanvim` warns it's missing at
startup).

**Debugging:**

- `<leader>dr` opens **Rust Debuggables** — a picker of every
  runnable/debuggable target rust-analyzer found (binaries, tests,
  examples). Pick one and it launches straight into a debug session with
  codelldb, no manual "path to executable" prompt needed.
- `<leader>db` to set breakpoints as usual, either before or after opening
  the debuggables picker.
- `<leader>cR` (buffer-local, `.rs` only) is a general rust-analyzer code
  action menu — not debug-specific, but useful right next to it.

## Java

**Adapter:** `java-debug-adapter` (+ `java-test` for the test runner) —
installed automatically via Mason the first time jdtls attaches to a
`.java` file.

**Debugging a `main` method:**

`<leader>dc` — jdtls scans the project for `main` methods and offers them
directly in the configuration picker (no manual launch config needed). Set
breakpoints first with `<leader>db`.

**Attaching to a remote JVM:** a config named `"Debug (Attach) - Remote"`
is pre-registered (`lua/plugins/java.lua` via the `lang.java` extra),
targeting `127.0.0.1:5005` — the default remote-debug port. Start your JVM
with:

```sh
java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 -jar app.jar
```

then `<leader>dc` and pick that config.

**Testing:** Java uses jdtls's own test runner instead of neotest (buffer-local
to `.java` files, overriding the global neotest bindings of the same name):

| Key | Action |
|---|---|
| `<leader>tt` | Run all tests in the class |
| `<leader>tr` | Run the nearest test method |
| `<leader>tT` | Pick a specific test to run |

These run through the debugger automatically when you need to step through
a failing test — no separate "debug test" command needed, breakpoints set
with `<leader>db` are honored.

**Maven:** `<leader>mm` (test) / `<leader>mp` (package) / `<leader>mi`
(install) run Maven directly in a terminal split, independent of the
debugger.

## Python

**Adapter:** `debugpy`, via
[nvim-dap-python](https://github.com/mfussenegger/nvim-dap-python).

**Before you debug: pick the right interpreter.** `<leader>cv` opens
[venv-selector.nvim](https://github.com/linux-cultist/venv-selector.nvim) —
pick the project's virtualenv. This matters because the debugger runs
*inside* that interpreter; if you skip this and debugpy uses the wrong
Python, imports will fail or breakpoints won't line up with installed
packages.

**Debugging:**

- `<leader>db`, then `<leader>dc` → "Launch file" runs the current file
  under the debugger.
- `<leader>dPt` — debug the test method under the cursor.
- `<leader>dPc` — debug the whole test class under the cursor.
- `<leader>td` — debug the nearest test via neotest (uses the
  `neotest-python` adapter, wired up by the `lang.python` extra).

## TypeScript / JavaScript / React

**Adapter:** `js-debug-adapter` (Microsoft's `vscode-js-debug`, DAP-wrapped)
— installed automatically via Mason.

**Debugging a Node/React script:**

1. `<leader>db` on the line to break at.
2. `<leader>dc` → **"Launch file"** — runs the current file with Node
   (or `tsx`/`ts-node` for `.ts` files, whichever is on `$PATH`).
3. For a running dev server or already-running Node process, pick
   **"Attach"** and select the process.

**Debugging React specifically:** if your React app runs in a browser
(e.g. via a bundler dev server, not SSR'd through Node), the Node debugger
attaches to the *build tooling*, not the browser tab. To debug the actual
component code running in the browser, use a `.vscode/launch.json` with a
`pwa-chrome` `launch` config pointed at your dev server URL (see
[below](#using-a-projects-vscodelaunchjson)) — this reuses the same
`pwa-chrome` adapter that's already registered for you, you just need a
config with the right `url`.

## Electron

Electron ships two separate processes that need debugging differently — a
Node **main** process and a Chromium **renderer** — so `.vscode/launch.json`
usually isn't enough by itself. `lua/plugins/electron-dap.lua` adds two
ready-made configs on top of the existing JS/TS adapters:

| Config name | What it does |
|---|---|
| **Electron: Main** | Launches Electron itself (`node_modules/.bin/electron`) with the main process under the Node debugger, and opens a remote-debugging port (`9222`) for the renderer |
| **Electron: Renderer** | Attaches Chrome DevTools protocol debugging to that same port, for the renderer's JS |

**Debugging the main process:**

1. `<leader>db` on a line in your main-process code (e.g. `main.js` /
   `main.ts`).
2. `<leader>dc` → **"Electron: Main"**.

If your entry point isn't `${workspaceFolder}/main.js`, edit the `program`
field in `lua/plugins/electron-dap.lua` to match (e.g.
`${workspaceFolder}/dist/main.js` for a TypeScript build output, or
`${workspaceFolder}/src/main/index.js` for an electron-vite/electron-forge
layout).

**Debugging the renderer process (while main is already running):**

1. `<leader>db` on a line in your renderer-process code.
2. `<leader>dc` → **"Electron: Renderer"**.

This attaches over CDP on port `9222` — it does **not** launch Electron
itself, so start "Electron: Main" first (or launch Electron manually with
`--remote-debugging-port=9222`), then attach the renderer config in a
second debug session. Both sessions can run at once; nvim-dap-ui will show
whichever one is active.

## Using a project's `.vscode/launch.json`

nvim-dap auto-discovers `.vscode/launch.json` in your project root for
*any* language, on demand, every time you open the config picker (`<leader>dc`)
— no manual loading step. Its entries show up alongside this config's
built-in defaults (codelldb/cppdbg for C++, the Electron configs, etc.),
never replacing them.

This config additionally decodes `launch.json` as
[json5](https://github.com/Joakker/lua-json5) instead of strict JSON, so
trailing commas (which VSCode's own editor happily writes) won't break
parsing.

Example, for a project that wants a custom Chrome-attached React debug
config alongside the defaults:

```jsonc
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "pwa-chrome",
      "request": "launch",
      "name": "Debug React (Chrome)",
      "url": "http://localhost:5173",
      "webRoot": "${workspaceFolder}/src"
    }
  ]
}
```

## Troubleshooting

- **"No configurations found" / the picker is empty.** Make sure you
  actually opened a file of that filetype before pressing `<leader>dc` —
  `vim.bo.filetype` drives which `dap.configurations[...]` table gets
  used. A blank scratch buffer has no filetype and therefore no configs.
- **Adapter binary not found.** Run `:Mason` and check the adapter is
  installed (`codelldb`, `java-debug-adapter`, `js-debug-adapter`,
  `debugpy`). Everything installs automatically on first use, but if that
  failed (no network at the time, etc.), install it manually from that UI
  (press `i` on the entry) or run `:MasonInstall <name>`.
- **`rustaceanvim` complains `rust-analyzer` not found.** It needs to be on
  `$PATH` directly (not just Mason-installed) — `rustup component add
  rust-analyzer`.
- **Breakpoints show as unverified (hollow circle).** Usually means the
  binary being debugged doesn't match the source you're looking at — for
  C/C++ and Rust, rebuild before debugging; for TS, make sure `sourceMaps`
  is enabled (it is, by default, in every JS/TS config here) and that
  you're not debugging stale build output.
- **Python debugging uses the wrong interpreter/can't find your
  packages.** Run `<leader>cv` and select the correct venv before starting
  a debug session.
- **DAP UI windows didn't open.** `<leader>du` toggles them manually; if
  they still don't appear, check `:messages` for an error from
  `nvim-dap-ui`'s `setup()` — most commonly a missing
  `nvim-neotest/nvim-nio` dependency, which should install automatically
  with everything else.
