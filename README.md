# Reminder Animation for Omarchy

A community bar widget for Omarchy's Quickshell desktop. It shows the time left on your existing reminders, without creating a second timer. The default skin is a shrinking bar during the countdown and a pulsing dot when a pinned timer finishes.

## Install

Requires an Omarchy installation with `omarchy plugin add` and `omarchy-reminder show --json`. From an interactive terminal:

```sh
omarchy plugin add https://github.com/PhilippWuerfel/omarchy-reminder-animation.git --enable
```

Choose `centerEnd` to place the widget to the right of the clock. No manual `shell.json` edits are needed. If you already have the older standalone `reminder-countdown` module, remove its layout entry before enabling the plugin to avoid two countdowns.

## Try it

1. Set a reminder as usual, or run `omarchy-reminder 1 "Take a break"`.
2. For a single timer, no selection is needed. Let the countdown run without clicking it.
3. When the timer expires, the animation starts automatically and loops until you click it. Dismissing the normal system notification does not dismiss the animation. With no reminders left, the widget disappears. Pins last for the current shell session. The widget polls the reminder list every five seconds. If you clear a pinned timer just before it is due, it can disappear between polls and be mistaken for an expiry; click once to dismiss the animation.

```sh
omarchy plugin update pw.reminder-animation
omarchy plugin disable pw.reminder-animation
# To uninstall instead, back up your custom skins first:
omarchy plugin remove pw.reminder-animation
```

After `omarchy plugin update`, run `omarchy-restart-shell`. The shell reloads changed plugin files on its own, but it keeps the reminder state that is already running. Without a restart, the widget can mix new and old code. For example, a fix in the expiry logic may not take effect.

## Make a skin

Start with the working template rather than editing the timer code. In the **installed plugin**:

```sh
cd ~/.config/omarchy/plugins/pw.reminder-animation
cp -r skins/plain skins/firefly   # choose a new folder name
# Edit skins/firefly/Track.qml and skins/firefly/Finish.qml, then activate:
omarchy bar set pw.reminder-animation skin firefly
```

| File | What to draw | Inputs |
| --- | --- | --- |
| `Track.qml` | The countdown graphic (default 68 × 14 logical pixels). The widget draws the numeric time separately. | `property real progress`: elapsed fraction, 0 at start, 1 at expiry. `property color ink`: current bar foreground. |
| `Finish.qml` | A looping animation in place of the countdown (default 107 × 20). Clicking is handled by the widget. | Optional `property color ink`. The component is unloaded on acknowledgement. |

To watch a skin without a running reminder, open the preview from the checkout or plugin root with `qml6 tools/preview.qml` (part of `qt6-declarative`). It lists every folder under `skins/`, plays the countdown in a loop or lets you scrub `progress` with a slider, and shows `Finish.qml` below. Reopen it after editing a file. The preview runs as its own process and is never loaded by the shell.

Use lowercase letters, digits, `_` or `-` for the folder name. Give both root items an `implicitWidth` and `implicitHeight`. Switch back with `omarchy bar set pw.reminder-animation skin plain`. If you edit an already loaded QML file and the old version is still visible, run `omarchy-restart-shell` (this also resets the current pin). Only load skins you trust: QML is executable code.

### Example AI prompt

> Read `skins/plain/Track.qml` and `skins/plain/Finish.qml`. Create a new skin in `skins/firefly/`, leaving all other files untouched. During the countdown, draw an original firefly moving toward a leaf as `progress` goes from 0 to 1. On expiry, have it circle the leaf and gently glow until the widget is clicked. Keep the template's dimensions and property names. Use QtQuick primitives or Canvas, no third-party artwork, network requests, shell commands or click handlers. Make it legible on both dark and light bars. Return the two QML files and the command to select the skin.

### Edit a private skin in your repo and preview it locally

`omarchy bar set` **selects** a skin in the installed plugin; it does not copy files from your repo. Installing from GitHub or from a local Git repo does not include ignored skins.

Git ignores **every folder under `skins/` except `plain/`**. You can keep personal skins in your development checkout without publishing them. Verify with `git check-ignore -v skins/firefly/Track.qml`. Do not force-add private skins. Ignored files are not backed up or transferred by Git.

The development checkout and installed plugin are separate directories. To use a skin from your checkout, run the following **from the checkout root** after installing the plugin (replace `firefly` with your folder name):

```sh
cp -r skins/firefly ~/.config/omarchy/plugins/pw.reminder-animation/skins/
omarchy bar set pw.reminder-animation skin firefly
```

After editing `Track.qml` or `Finish.qml` in your checkout, repeat the `cp` command above. If the bar still shows the old animation, run `omarchy-restart-shell` (this clears the current pin). The selected skin stays selected. No commit, push, or reinstall is needed.

Keep the checkout copy as your source. To use that skin on another laptop, copy it separately after installing the plugin. Before publishing changes, run `omarchy plugin validate .` and inspect `git status --short --ignored`.

## Run a branch

The installed plugin is a Git checkout. To run a pushed branch in your bar:

```sh
cd ~/.config/omarchy/plugins/pw.reminder-animation
git fetch origin
git checkout <branch>      # later: git pull
omarchy-restart-shell
```

To go back, run `git checkout main` and `omarchy-restart-shell`. Restart the shell after every switch. Do not run `omarchy plugin update` while a branch other than `main` is checked out.

## License

[MIT](LICENSE). The distributed template uses geometric shapes and does not require external artwork.
