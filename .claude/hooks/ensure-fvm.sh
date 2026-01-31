#!/bin/bash
# Ensures FVM (Flutter Version Management) is installed.
# Used as a Claude Code SessionStart hook.

# Check if dart is available
if ! command -v dart &>/dev/null; then
  echo "Dart SDK is not installed. FVM requires Dart to be on PATH." >&2
  exit 1
fi

# Check if fvm is already available
if command -v fvm &>/dev/null; then
  echo "fvm is already installed: $(fvm --version 2>/dev/null)"
  exit 0
fi

echo "fvm not found. Installing via dart pub global activate fvm..." >&2

if ! dart pub global activate fvm 2>&1; then
  echo "Failed to install fvm." >&2
  exit 1
fi

# Ensure pub global bin is on PATH for this session
export PATH="$PATH:$HOME/.pub-cache/bin"

if ! command -v fvm &>/dev/null; then
  echo "fvm was installed but is not on PATH. Add ~/.pub-cache/bin to your PATH." >&2
  exit 1
fi

echo "fvm installed successfully: $(fvm --version 2>/dev/null)"

# Install the Flutter SDK version specified in .fvmrc
if [ -f "$CLAUDE_PROJECT_DIR/.fvmrc" ]; then
  echo "Running fvm install to cache the Flutter SDK version from .fvmrc..."
  cd "$CLAUDE_PROJECT_DIR" && fvm install 2>&1
fi

exit 0
