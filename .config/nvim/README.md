# 💤 LazyVim — personal config

A [LazyVim](https://github.com/LazyVim/LazyVim) setup tuned for C/C++, Rust,
Java, Python, and TypeScript/React/Electron development, with a working
debugger for every one of those languages.

Refer to the [LazyVim documentation](https://lazyvim.github.io/installation)
for anything not covered here — this file only documents what's custom or
non-obvious about *this* config.

## Prerequisites

LazyVim itself expects `git`, `ripgrep` (`rg`), and `lazygit` on `$PATH`.
This config additionally needs:

- **`fd`** (`fd-find`) — required by
  [venv-selector.nvim](https://github.com/linux-cultist/venv-selector.nvim)
  (Python virtualenv picker, `<leader>cv`) to search for virtualenvs; it
  errors out without it. On Arch: `sudo pacman -S fd`.

Everything else (clangd, rust-analyzer's companions, jdtls, pyright, ruff,
vtsls, and every debug adapter) installs itself automatically via Mason the
first time you open a matching file — `rust-analyzer` itself is the one
exception, install it with `rustup component add rust-analyzer` if
`rustaceanvim` warns it's missing.

## Language support

| Language | LSP | Formatting/Linting | Debugging | Enabled via |
|---|---|---|---|---|
| C / C++ | clangd (+ clang-tidy) | clang-format (via LSP) | codelldb | `lua/config/lazy.lua` (`lang.clangd`) + `lua/plugins/lsp.lua` |
| Rust | rust-analyzer (via rustaceanvim) | rustfmt | codelldb | `lazyvim.json` (`lang.rust`) |
| Java | jdtls | google-java-format (via jdtls) | java-debug-adapter | `lazyvim.json` (`lang.java`) + `lua/plugins/java.lua` |
| Python | pyright + ruff | ruff | debugpy | `lazyvim.json` (`lang.python`) |
| TypeScript / JS / React | vtsls | prettier + eslint | js-debug-adapter | `lua/config/lazy.lua` (`lang.typescript`, `linting.eslint`, `formatting.prettier`) |
| Electron | (same as TS/JS) | (same as TS/JS) | js-debug-adapter (custom launch configs) | `lua/plugins/electron-dap.lua` |

All debug adapters are installed automatically by `mason-nvim-dap` the first
time you open a file of that language (check progress with `:Mason` or
`:MasonLog`). **See [HOW_TO_USE_DEBUGGER.md](./HOW_TO_USE_DEBUGGER.md) for
the full debugging guide** — setup per language, every keybinding, and
Electron main/renderer debugging specifically.

## Generating doc comments (`<leader>cg`)

`<leader>cg` runs [neogen](https://github.com/danymat/neogen) on whatever
function/class your cursor is inside, using Doxygen for C/C++, Javadoc for
Java, and TSDoc for TypeScript.

**A note on where the cursor is:** neogen picks the *nearest enclosing*
construct to the cursor. Put the cursor on the function's signature line (or
anywhere in its body) to document the function; put it on the class line
itself to document the class. If the cursor sits on a blank/whitespace-only
column at the very start of an indented line, neogen can occasionally
resolve to the wrong (outer) scope — put the cursor on actual code, not
column 0 of the line, if that happens.

This config carries a local fix
([lua/neogen/configurations/c.lua](./lua/neogen/configurations/c.lua)) for a
real bug in upstream neogen's C/C++ support: it only looked for a `return`
statement that was a *direct* child of the function body, so any function
using an early-return / guard-clause pattern —

```cpp
std::string getName() {
    if (valid) {
        return name;   // <- nested inside `if`, not a direct child
    }
}
```

— silently got no `@return` tag, and functions returning a qualified or
templated type (`std::string`, `std::vector<T>`, `ns::Type`) were never
recognized as returning anything at all for header-only prototypes. Both are
fixed. If you hit another case where `@return` (or any other tag) is still
wrong, it's most likely this same file — open a PR upstream at
[danymat/neogen](https://github.com/danymat/neogen) referencing the same
`compound_statement` extractor, and update the local copy here to match once
it lands.

## File headers (`<leader>hh`)

[header.nvim](https://github.com/attilarepka/header.nvim) inserts a small
comment header (file name, author, dates) into new files automatically, and
updates "Date modified" on save. `<leader>hh` re-inserts it manually if
needed. Configured in
[lua/plugins/header-nvim.lua](./lua/plugins/header-nvim.lua).

## C++-specific tooling

[nvim-treesitter-cpp-tools](https://github.com/Badhi/nvim-treesitter-cpp-tools)
generates class boilerplate from treesitter:

| Key | Action |
|---|---|
| `<leader>ci` | Preview a member function's implementation inline |
| `<leader>cI` | Write that implementation to the paired `.cpp` file |
| `<leader>cM` | Turn an abstract class into a concrete one (stub out pure virtuals) |
| `<leader>c3` | Generate the Rule of 3 (copy ctor/assign, dtor) |
| `<leader>c5` | Generate the Rule of 5 (+ move ctor/assign) |
| `<leader>ch` | Switch between header and source file (from the `clangd` extra) |

`<leader>cM` used to be `<leader>cm`, which collided with LazyVim's own
`<leader>cm` → `:Mason` shortcut: both were plain global keymaps, so opening
any C/C++ file silently overwrote the Mason shortcut for the rest of the
session. Renamed to avoid that.

clangd is configured with `--compile-commands-dir=build`
([lua/plugins/lsp.lua](./lua/plugins/lsp.lua)), i.e. it expects
`compile_commands.json` inside a `build/` directory (typical CMake layout:
`cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`). If your project puts
`compile_commands.json` somewhere else, either symlink it into `build/` or
change that flag.

### CMake ([lua/plugins/cmake-tools.lua](./lua/plugins/cmake-tools.lua))

[cmake-tools.nvim](https://github.com/Civitasv/cmake-tools.nvim) drives CMake
from inside nvim and — this is the part that matters for clangd — soft-links
the generated `compile_commands.json` into the project root on every
generate (`cmake_compile_commands_options.action = "soft_link"`). Without a
complete, up-to-date compilation database, clangd silently falls back to
guessed flags and loses most code actions (including header
auto-import/insertion), so keep this in the loop rather than running `cmake`
by hand.

| Key | Action |
|---|---|
| `<leader>ckg` | CMake Generate |
| `<leader>ckb` | CMake Build |
| `<leader>ckr` | CMake Run |
| `<leader>ckd` | CMake Debug |
| `<leader>cks` | CMake Stop |
| `<leader>ckc` | CMake Clean |
| `<leader>ckt` | Select build type (Debug/Release/...) |

## Java (Maven)

[lua/plugins/java.lua](./lua/plugins/java.lua) adds Maven convenience
commands on top of LazyVim's `lang.java` extra:

| Key | Action |
|---|---|
| `<leader>mm` | `mvn test` |
| `<leader>mp` | `mvn -DskipTests package` |
| `<leader>mi` | `mvn install` |

It also points jdtls at `~/.m2/settings.xml` and prefers the git root over
Maven's own multi-module root detection.

## Rust

Just `<leader>cv`... no — that one's Python. For Rust, `<leader>cR` runs a
code action and `<leader>dr` opens **Rust Debuggables** (a picker of
runnable/debuggable targets detected by rust-analyzer) — both buffer-local
to `.rs` files, from LazyVim's `lang.rust` extra.
[crates.nvim](https://github.com/Saecki/crates.nvim) gives completion and
LSP-style hover/actions inside `Cargo.toml`.

## Python

`<leader>cv` opens [venv-selector.nvim](https://github.com/linux-cultist/venv-selector.nvim)
to pick which virtualenv/interpreter pyright, ruff, and the debugger should
use. Do this once per project before debugging — see
[HOW_TO_USE_DEBUGGER.md](./HOW_TO_USE_DEBUGGER.md#python) for why it
matters.

## TypeScript / React / Electron

Nothing extra to configure day-to-day — vtsls, prettier, and eslint all
attach automatically in `.ts`/`.tsx`/`.js`/`.jsx` files. For debugging
(including Electron's separate main/renderer processes), see
[HOW_TO_USE_DEBUGGER.md](./HOW_TO_USE_DEBUGGER.md#typescript--javascript--react)
and
[HOW_TO_USE_DEBUGGER.md](./HOW_TO_USE_DEBUGGER.md#electron).

## Testing (neotest)

`lazyvim.json` enables LazyVim's `test.core` extra
([nvim-neotest/neotest](https://github.com/nvim-neotest/neotest)), which
gives a consistent test runner UI across languages that have an adapter
configured (Rust via rustaceanvim, Python via neotest-python — both wired up
by their respective `lang.*` extras already). Java keeps its own separate
jdtls-based test runner (buffer-local to `.java` files, see below) rather
than neotest, since jdtls's test integration isn't neotest-compatible yet.

| Key | Action |
|---|---|
| `<leader>tt` | Run the current file's tests |
| `<leader>tr` | Run the nearest test |
| `<leader>tT` | Run all test files in the project |
| `<leader>tl` | Re-run the last test |
| `<leader>ts` | Toggle the test summary panel |
| `<leader>to` | Show output for the test under the cursor |
| `<leader>td` | Debug the nearest test (routes through nvim-dap) |

In `.java` files specifically, `<leader>tt`/`<leader>tr`/`<leader>tT` are
overridden (buffer-locally) by jdtls's own test runner instead — see
[HOW_TO_USE_DEBUGGER.md](./HOW_TO_USE_DEBUGGER.md#java).

## UI

[snacks.nvim](https://github.com/folke/snacks.nvim) (already part of
LazyVim) already covers most "IDE eye-candy" out of the box, so most of the
usual list of extra UI plugins would just be redundant/conflicting here —
worth knowing these exist before reaching for a plugin that duplicates them:

| Key | Action |
|---|---|
| `<leader>uz` | Toggle Zen Mode (distraction-free, centered buffer) |
| `<leader>uZ` | Toggle window zoom |
| `<leader>uD` | Toggle Dim (fades out everything but the current scope — snacks' equivalent of twilight.nvim) |
| `<leader>ug` | Toggle indent guides |
| `<leader>ua` | Toggle animations |

Image previews (markdown, etc., via the Kitty graphics protocol) also come
from snacks' built-in `image` module — no separate `image.nvim` needed.

The one thing snacks doesn't provide is a breadcrumb winbar, so
[dropbar.nvim](https://github.com/Bekaboo/dropbar.nvim)
([lua/plugins/dropbar.lua](./lua/plugins/dropbar.lua)) was added for that —
it shows an LSP/treesitter-aware breadcrumb trail (file → class → function)
at the top of the window automatically; `<leader>uB` opens an interactive
picker to jump to any breadcrumb segment.

## What changed from a stock LazyVim starter

- **Removed `avante.nvim`** — unused.
- **Fixed `<leader>cg` (neogen) missing `@return` on C/C++ functions** — see
  above.
- **Fixed C/C++ debugging being completely empty** — `lua/plugins/dap.lua`
  used to define its own `config` function for `nvim-dap`, which (per
  lazy.nvim's merge rules) fully replaced LazyVim's own `dap.core` config
  instead of composing with it — silently dropping DAP UI signs and
  mason-nvim-dap auto-install, and separately wiping the codelldb configs
  the `clangd` extra had just set up (`dap.configurations.cpp = {}`).
  Rewritten to use `opts` (side-effect functions compose across specs;
  `config` does not) and to stop duplicating what nvim-dap now does
  natively (`.vscode/launch.json` auto-discovery, see `:h
  dap-providers-configs`).
- **Enabled `lang.rust`, `lang.python`, and `test.core`** — previously only
  `lang.java` was enabled; Rust and Python had no dedicated LSP setup, DAP
  adapter, or treesitter grammar at all.
- **Added Electron debugging** — `lua/plugins/electron-dap.lua`, two extra
  launch configs (main process via `pwa-node`, renderer via `pwa-chrome`)
  layered on top of the existing JS/TS adapters.
- **Fixed a real keymap collision**: `<leader>cm` was bound both to
  `:Mason` (LazyVim core) and to cpp-tools' "Make concrete class". Opening
  any C/C++ file silently broke the Mason shortcut for the rest of the
  session. Moved cpp-tools to `<leader>cM`.
- **Fixed a dead autocmd group reference** in `lua/config/autocmds.lua`
  (`group = grp` referenced an undefined variable, so the header-update
  autocmd was never actually grouped/cleared on config reload).
- **Fixed a typo** in `lua/plugins/mini-files.lua`
  (`use_as_default_exporer` → `use_as_default_explorer` — harmless in
  practice since that option already defaults to `true`, but the typo meant
  the setting itself was a no-op).
- **Added `cmake-tools.nvim`** — auto-symlinks `compile_commands.json` to
  the project root so clangd stops falling back to guessed flags (the cause
  of missing code actions / failed header auto-import on CMake projects).
- **Added `dropbar.nvim`** for an IDE-style breadcrumb winbar; deliberately
  did *not* add `indent-blankline.nvim`, `zen-mode.nvim`/`twilight.nvim`, or
  `image.nvim` since snacks.nvim (already installed) already provides all
  of that — see the UI section above.
