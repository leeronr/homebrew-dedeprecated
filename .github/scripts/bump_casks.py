#!/usr/bin/env python3

import re
import subprocess
import sys


TAP = "leeronr/dedeprecated"

ANSI_ESCAPE = re.compile(
    r"\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])"
    )


def run(command):
    print(f"$ {' '.join(command)}", flush=True)

    result = subprocess.run(
        command,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )

    if result.returncode != 0:
        print(result.stdout, end="")
        raise RuntimeError(
            f"Command failed with exit status {result.returncode}: "
            f"{' '.join(command)}"
        )

    return result.stdout


def parse_bump_output(output):
    single = {}
    arm = {}
    intel = {}

    package = None
    multiarch = False

    for line_number, raw_line in enumerate(output.splitlines(), 1):
        line = raw_line.rstrip()

        # Package header
        match = re.match(r"^==> (.+)$", line)
        if match:
            header = match.group(1)

            if header.endswith(" is up to date!"):
                package = None
                multiarch = False
                continue

            package = header
            multiarch = False
            continue

        if package is None:
            continue

        # ARM latest version
        match = re.match(
            r"^Latest livecheck version:\s*arm:\s*(.+)$",
            line,
        )
        if match:
            multiarch = True
            arm[package] = match.group(1).strip()
            continue

        # Intel continuation
        if multiarch:
            match = re.match(r"^\s+intel:\s*(.+)$", line)
            if match:
                intel[package] = match.group(1).strip()
                continue

        # Single latest version
        match = re.match(
            r"^Latest livecheck version:\s*(.+)$",
            line,
        )
        if match:
            single[package] = match.group(1).strip()
            continue

    return single, arm, intel


def main():
    output = run(["brew", "bump", "--tap", TAP])
    output = ANSI_ESCAPE.sub("", output)

    print("\n=== Parsed versions ===")

    single, arm, intel = parse_bump_output(output)

    for package, version in single.items():
        print(f"SINGLE  {package}: {version}")

    for package, version in arm.items():
        print(f"ARM     {package}: {version}")

        if package not in intel:
            raise RuntimeError(
                f"{package}: ARM version found but Intel version missing"
            )

        print(f"INTEL   {package}: {intel[package]}")

    print("\n=== Bumping ===")

    for package, version in single.items():
        command = [
            "brew",
            "bump-cask-pr",
            "--no-fork",
            "--no-browse",
            "--version",
            version,
            f"{TAP}/{package}",
        ]

        run(command)

    for package, arm_version in arm.items():
        intel_version = intel[package]

        command = [
            "brew",
            "bump-cask-pr",
            "--no-fork",
            "--no-browse",
            "--version-arm",
            arm_version,
            "--version-intel",
            intel_version,
            f"{TAP}/{package}",
        ]

        run(command)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(130)
    except Exception as exc:
        print(f"\nERROR: {exc}", file=sys.stderr)
        sys.exit(1)