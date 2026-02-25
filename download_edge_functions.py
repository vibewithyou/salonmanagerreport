#!/usr/bin/env python3
"""download_edge_functions.py

Download ALL Supabase Edge Functions for a project and store them in
`supabase_backup/<function_name>` next to this script.

Why this exists (Windows-friendly):
- Double-clicking .py files often uses a different PATH than your terminal.
- `npx`/`supabase` may not be found as an executable from Python subprocess.

This script therefore:
- Uses the directory of this script as repo root.
- Locates `npx.cmd` / `npm.cmd` from your *user* Node install (no admin).
- Runs Supabase CLI commands with streaming output.

Prereqs:
1) Node installed
2) One-time login (in a terminal):
   - `npx supabase login`  (preferred)
   - or `npm exec supabase login`

Usage:
- Double click via a .bat wrapper OR run in terminal:
  `python download_edge_functions.py`

You can override the project ref:
  `python download_edge_functions.py --project-ref <ref>`
"""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import sys
from pathlib import Path

# ✅ Embedded project ref (can be overridden by --project-ref)
PROJECT_REF = "tshbudjnxgufagnvgqtl"


def _user_node_bin(cmd_filename: str) -> str | None:
    """Return full path to a Node shim in %APPDATA%\npm if it exists."""
    appdata = os.environ.get("APPDATA")
    if not appdata:
        return None
    p = Path(appdata) / "npm" / cmd_filename
    return str(p) if p.exists() else None


def build_runner() -> tuple[str, str]:
    """Return (label, base_command_string).

    We prefer `npx.cmd` (user install). If not available, fall back to `npm.cmd exec`.

    Notes:
    - Using a command STRING with shell=True is the most reliable way to execute
      `.cmd` shims on Windows from Python.
    - `npm exec` needs `--yes` to avoid prompts.
    """
    npx_cmd = _user_node_bin("npx.cmd")
    npm_cmd = _user_node_bin("npm.cmd")

    if npx_cmd:
        # Run supabase via npx explicitly
        return ("npx.cmd supabase", f'"{npx_cmd}" supabase')

    # If npx is in PATH (rare in your case), use it
    if shutil.which("npx"):
        return ("npx supabase", "npx supabase")

    if npm_cmd:
        # npm exec requires `--` before args for the executed command in many npm setups.
        return ("npm.cmd exec supabase", f'"{npm_cmd}" exec --yes supabase --')

    # Last resort: hope npm is on PATH
    return ("npm exec supabase", "npm exec --yes supabase --")


def run_stream(cmd: str, cwd: Path) -> str:
    """Run a command with streaming stdout/stderr. Return captured stdout."""
    print(f"$ {cmd}")
    proc = subprocess.Popen(
        cmd,
        cwd=str(cwd),
        shell=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        bufsize=1,
    )
    assert proc.stdout is not None
    out_lines: list[str] = []
    for line in proc.stdout:
        print(line, end="")
        out_lines.append(line)
    rc = proc.wait()
    if rc != 0:
        raise RuntimeError(f"Command failed with exit code {rc}: {cmd}")
    return "".join(out_lines)


def parse_functions_list(output: str) -> list[str]:
    """Parse `supabase functions list` output and return function names."""
    fns: list[str] = []
    for line in output.splitlines():
        s = line.strip()
        if not s:
            continue
        # Skip common headers/separators
        if s.lower().startswith("name") or s.lower().startswith("id"):
            continue
        if set(s) <= {"-", " ", "|"}:
            continue
        # Table formats: either whitespace-separated or pipe-delimited
        if "|" in s:
            parts = [p.strip() for p in s.split("|") if p.strip()]
            # Typical CLI table: ID | NAME | SLUG | STATUS | ...
            # We must download by function NAME/SLUG, NOT by ID.
            if len(parts) >= 3:
                # Prefer SLUG because it's the deploy identifier.
                fns.append(parts[2])
            elif len(parts) >= 2:
                fns.append(parts[1])
            continue
        parts = s.split()
        if parts:
            # Whitespace table sometimes starts with ID then NAME; try to pick NAME.
            # If the first token looks like a UUID and we have more tokens, take the second.
            tok0 = parts[0]
            is_uuid = len(tok0) == 36 and tok0.count('-') == 4
            if is_uuid and len(parts) >= 2:
                fns.append(parts[1])
            else:
                fns.append(parts[0])

    # de-dup preserve order
    seen: set[str] = set()
    uniq: list[str] = []
    for n in fns:
        if n.lower() in {"name", "id"}:
            continue
        if n not in seen:
            seen.add(n)
            uniq.append(n)
    return uniq


def find_downloaded_function_dir(repo_root: Path, fn: str) -> Path | None:
    """Where did Supabase CLI place the downloaded function?"""
    candidates = [
        repo_root / "supabase" / "functions" / fn,
        repo_root / "supabase" / "functions" / fn.lower(),
    ]
    for c in candidates:
        if c.is_dir():
            return c
    # fallback: search one level deep
    base = repo_root / "supabase" / "functions"
    if base.is_dir():
        for child in base.iterdir():
            if child.is_dir() and child.name == fn:
                return child
    return None


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--project-ref", default=PROJECT_REF)
    args = parser.parse_args()
    project_ref = args.project_ref

    repo_root = Path(__file__).resolve().parent
    backup_dir = repo_root / "supabase_backup"
    backup_dir.mkdir(parents=True, exist_ok=True)

    label, base = build_runner()

    print("Starting Supabase Edge Function download...")
    print(f"Repo root: {repo_root}")
    print(f"Backup dir: {backup_dir}")
    print(f"Project ref: {project_ref}")
    print(f"CLI runner: {label}")

    try:
        out = run_stream(f"{base} functions list --project-ref {project_ref}", cwd=repo_root)
    except Exception as e:
        print("\n❌ Failed to list functions.")
        print("Most common fixes:")
        print("- Run once in a terminal: `npx supabase login` (or `npm exec supabase login`)")
        print("- Ensure Node user shims exist: %APPDATA%\\npm\\npx.cmd or npm.cmd")
        print("- Try running from VS Code terminal to see full output")
        print(f"\nError: {e}")
        sys.exit(1)

    fns = parse_functions_list(out)
    if not fns:
        print("\n⚠️ No functions parsed from output. If you see a table above, paste it here and I'll adjust the parser.")
        return

    print(f"\nFound {len(fns)} function(s): {', '.join(fns)}\n")

    for fn in fns:
        try:
            run_stream(f"{base} functions download {fn} --project-ref {project_ref}", cwd=repo_root)
        except Exception as e:
            print(f"❌ Download failed for {fn}: {e}")
            continue

        src = find_downloaded_function_dir(repo_root, fn)
        if not src:
            print(f"⚠️ Could not find downloaded folder for {fn} under {repo_root / 'supabase' / 'functions'}. Skipping copy.")
            continue

        dst = backup_dir / fn
        if dst.exists():
            shutil.rmtree(dst)
        shutil.copytree(src, dst)
        print(f"✅ Saved {fn} -> {dst}")

    print("\n🎉 Done. Edge functions stored in supabase_backup.\n")


if __name__ == "__main__":
    main()
