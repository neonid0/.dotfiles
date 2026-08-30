#!/usr/bin/env python3
"""Save/list/restore i3 workspace setups (windows, geometry, floating state)."""

import json
import os
import subprocess
import sys
import time

SETUPS_DIR = os.path.expanduser("~/.config/i3/setups")

# class -> launcher command (prefer the wrapper/launcher over raw /proc cmdline,
# since snap-wrapped apps report their internal binary path there)
CLASS_TO_CMD = {
    "kitty": "kitty",
    "floorp": "floorp",
    "Thunar": "thunar",
    "thunderbird_thunderbird": "thunderbird",
    "Spotify": "spotify",
    "teams-for-linux": "teams-for-linux",
    "Telegram-desktop": "telegram-desktop",
    "TradingView": "tradingview",
}

# classes never worth saving/restoring (bars, helpers, etc.)
SKIP_CLASSES = {"i3bar"}


def run(cmd):
    return subprocess.run(cmd, capture_output=True, text=True)


def get_tree():
    out = subprocess.check_output(["i3-msg", "-t", "get_tree"])
    return json.loads(out)


def walk_windows(node, workspace=None, floating=False, out=None):
    if out is None:
        out = []
    if node.get("type") == "workspace":
        workspace = node.get("name")
    if node.get("window") and node.get("window_type") == "normal":
        out.append((node, workspace, floating))
    for child in node.get("nodes", []):
        walk_windows(child, workspace, floating, out)
    for child in node.get("floating_nodes", []):
        walk_windows(child, workspace, True, out)
    return out


def resolve_cmd(cls, window_id):
    if cls in CLASS_TO_CMD:
        return CLASS_TO_CMD[cls]
    try:
        pid = run(["xdotool", "getwindowpid", str(window_id)]).stdout.strip()
        with open(f"/proc/{pid}/cmdline", "rb") as f:
            parts = [p for p in f.read().decode(errors="replace").split("\x00") if p]
        if parts:
            return parts[0]
    except Exception:
        pass
    return None


def cmd_save(name):
    os.makedirs(SETUPS_DIR, exist_ok=True)
    tree = get_tree()
    windows = walk_windows(tree)

    saved = []
    for node, workspace, floating in windows:
        wp = node.get("window_properties", {})
        cls = wp.get("class")
        if cls in SKIP_CLASSES:
            continue
        rect = node.get("rect", {})
        cmd = resolve_cmd(cls, node["window"])
        saved.append({
            "workspace": workspace,
            "class": cls,
            "instance": wp.get("instance"),
            "title": wp.get("title"),
            "floating": floating,
            "rect": {
                "x": rect.get("x"),
                "y": rect.get("y"),
                "width": rect.get("width"),
                "height": rect.get("height"),
            },
            "cmd": cmd,
        })

    payload = {
        "name": name,
        "created": time.strftime("%Y-%m-%d %H:%M:%S"),
        "windows": saved,
    }

    path = os.path.join(SETUPS_DIR, f"{name}.json")
    with open(path, "w") as f:
        json.dump(payload, f, indent=2)

    missing = [w["class"] for w in saved if not w["cmd"]]
    print(f"Saved {len(saved)} window(s) to {path}")
    if missing:
        print(f"WARNING: no launch command resolved for: {', '.join(missing)} "
              f"(edit the 'cmd' field in the JSON manually)")


def cmd_list():
    if not os.path.isdir(SETUPS_DIR):
        return
    for fname in sorted(os.listdir(SETUPS_DIR)):
        if not fname.endswith(".json"):
            continue
        path = os.path.join(SETUPS_DIR, fname)
        try:
            with open(path) as f:
                data = json.load(f)
            n = len(data.get("windows", []))
            created = data.get("created", "?")
            print(f"{data.get('name', fname[:-5])}\t{n} window(s), saved {created}")
        except Exception:
            print(f"{fname[:-5]}\t(unreadable)")


def existing_window_ids():
    tree = get_tree()
    return {node["window"] for node, _, _ in walk_windows(tree)}


def close_all_windows():
    tree = get_tree()
    ids = [node["id"] for node, _, _ in walk_windows(tree)]
    for con_id in ids:
        subprocess.run(["i3-msg", f'[con_id="{con_id}"] kill'])

    # wait for windows to actually close (some apps prompt / take a moment)
    for _ in range(20):
        time.sleep(0.3)
        if not existing_window_ids():
            break


def cmd_restore(name):
    path = os.path.join(SETUPS_DIR, f"{name}.json")
    if not os.path.isfile(path):
        print(f"No such setup: {name}", file=sys.stderr)
        sys.exit(1)

    with open(path) as f:
        data = json.load(f)

    close_all_windows()

    for entry in data.get("windows", []):
        cmd = entry.get("cmd")
        ws = entry.get("workspace")
        cls = entry.get("class")
        if not cmd:
            print(f"Skipping {cls}: no launch command saved")
            continue

        before_ids = existing_window_ids()
        subprocess.run(["i3-msg", f'workspace "{ws}"; exec {cmd}'])

        # poll for the new window of this class
        con_id = None
        for _ in range(30):
            time.sleep(0.5)
            tree = get_tree()
            for node, _, _ in walk_windows(tree):
                wp = node.get("window_properties", {})
                if wp.get("class") == cls and node["window"] not in before_ids:
                    con_id = node["id"]
                    break
            if con_id:
                break

        if not con_id:
            print(f"WARNING: timed out waiting for window of class {cls}")
            continue

        rect = entry.get("rect", {})
        w, h = rect.get("width"), rect.get("height")
        x, y = rect.get("x"), rect.get("y")

        if entry.get("floating"):
            subprocess.run(["i3-msg", f'[con_id="{con_id}"] floating enable'])
            if w and h:
                subprocess.run(["i3-msg", f'[con_id="{con_id}"] resize set {w} px {h} px'])
            if x is not None and y is not None:
                subprocess.run(["i3-msg", f'[con_id="{con_id}"] move absolute position {x} px {y} px'])
        else:
            if w and h:
                subprocess.run(["i3-msg", f'[con_id="{con_id}"] resize set {w} px {h} px'])

    print(f"Restored setup: {name}")


def main():
    if len(sys.argv) < 2:
        print("usage: i3_setup_manager.py save|list|restore [name]", file=sys.stderr)
        sys.exit(1)

    action = sys.argv[1]
    if action == "save":
        if len(sys.argv) < 3:
            print("usage: i3_setup_manager.py save <name>", file=sys.stderr)
            sys.exit(1)
        cmd_save(sys.argv[2])
    elif action == "list":
        cmd_list()
    elif action == "restore":
        if len(sys.argv) < 3:
            print("usage: i3_setup_manager.py restore <name>", file=sys.stderr)
            sys.exit(1)
        cmd_restore(sys.argv[2])
    else:
        print(f"unknown action: {action}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
