#!/bin/bash
# Ensures Dart SDK and FVM are installed.
# Used as a Claude Code SessionStart hook.

install_dart() {
  local os arch platform dart_zip dart_url install_dir
  os="$(uname -s)"
  arch="$(uname -m)"

  # Map architecture
  case "$arch" in
    x86_64)  arch="x64" ;;
    aarch64|arm64) arch="arm64" ;;
    *) echo "Unsupported architecture: $arch" >&2; return 1 ;;
  esac

  # Map platform
  case "$os" in
    Darwin) platform="macos" ;;
    Linux)  platform="linux" ;;
    *) echo "Unsupported OS: $os" >&2; return 1 ;;
  esac

  # macOS: try brew first
  if [ "$platform" = "macos" ] && command -v brew &>/dev/null; then
    echo "Installing Dart SDK via Homebrew..."
    brew install dart-sdk 2>&1
    return $?
  fi

  # Direct download fallback (Linux, or macOS without brew)
  if ! command -v curl &>/dev/null; then
    echo "curl is required to download Dart SDK" >&2; return 1
  fi
  if ! command -v unzip &>/dev/null; then
    echo "unzip is required to extract Dart SDK" >&2; return 1
  fi

  install_dir="$HOME/.dart-sdk"
  dart_zip="dartsdk-${platform}-${arch}-release.zip"
  dart_url="https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/${dart_zip}"

  echo "Downloading Dart SDK from ${dart_url}..."
  mkdir -p "$install_dir"
  curl --retry 3 --location --fail --output "/tmp/${dart_zip}" "$dart_url" 2>&1
  unzip -qo "/tmp/${dart_zip}" -d "$install_dir" 2>&1
  rm -f "/tmp/${dart_zip}"

  export PATH="$install_dir/dart-sdk/bin:$PATH"
}

# ── Dart ──
if ! command -v dart &>/dev/null; then
  echo "Dart SDK not found. Installing..."
  install_dart
  if ! command -v dart &>/dev/null; then
    echo "Failed to install Dart SDK." >&2
    exit 1
  fi
  echo "Dart installed: $(dart --version 2>&1)"
fi

# ── FVM ──
if ! command -v fvm &>/dev/null; then
  echo "fvm not found. Installing via dart pub global activate fvm..."
  dart pub global activate fvm 2>&1
  export PATH="$PATH:$HOME/.pub-cache/bin"
  if ! command -v fvm &>/dev/null; then
    echo "Failed to install fvm." >&2
    exit 1
  fi
  echo "fvm installed: $(fvm --version 2>/dev/null)"
fi

# ── Persist PATH for the session ──
if [ -n "$CLAUDE_ENV_FILE" ]; then
  echo "export PATH=\"$HOME/.dart-sdk/dart-sdk/bin:$HOME/.pub-cache/bin:\$PATH\"" >> "$CLAUDE_ENV_FILE"
fi

# ── Install Flutter SDK via FVM ──
if [ -f "$CLAUDE_PROJECT_DIR/.fvmrc" ]; then
  echo "Running fvm install..."
  cd "$CLAUDE_PROJECT_DIR" && fvm install 2>&1
fi

echo "fvm is ready: $(fvm --version 2>/dev/null)"
exit 0
