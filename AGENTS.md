# AGENTS.md

Omarchy bar plugin (`phiwue.reminder-animation`): a skinnable countdown widget for `omarchy-reminder`, written in QML (Qt 6 / Quickshell).

## Layout

- `Widget.qml` – bar widget, entry point (see `manifest.json`)
- `CountdownVisual.qml`, `ReminderMenuItem.qml` – widget parts
- `countdownstate/` – reminder state logic (`ReminderState.qml`, `Focus.js`)
- `skins/<name>/Track.qml` + `Finish.qml` – skins; only `skins/plain/` is tracked, other skin folders are git-ignored
- `tools/preview.qml` – standalone skin preview, never loaded by the shell
- `tests/tst_*.qml` – QtTest test cases

## Commands

```sh
# Run all tests (same command as CI, .github/workflows/test.yml)
QT_QPA_PLATFORM=offscreen /usr/lib/qt6/bin/qmltestrunner -input tests

# Preview skins without a running reminder
qml6 tools/preview.qml

# Enable the repo's git hooks once per clone (runs tests before each commit)
git config core.hooksPath .githooks

# Reload the shell after editing an installed QML file
omarchy-restart-shell
```

Both tools come from `qt6-declarative`. On Arch, `qmltestrunner` is not on `PATH`; use the full path above.

## Conventions

- Add new tests as `tests/tst_<topic>.qml`; tests must not import `Quickshell` so they run headless in CI.
- Run the tests before committing (enforced by `.githooks/pre-commit`).
- Do not force-add private skins under `skins/`.
- Commit messages use Conventional Commits (`feat:`, `fix:`, `docs:` …).
