#!/bin/bash
# SDD + SPDD — Install Script
#
# Usage:
#   ./install.sh [TARGET]               — install into TARGET project (default: current dir)
#   ./install.sh --global               — install into Devin global dir (add missing only)
#   ./install.sh --global --force       — install into Devin global dir (overwrite all)
#
# Devin global path: ~/.config/devin/
# On Windows:        %APPDATA%\devin\

set -e

# ── Resolve Devin global path ──────────────────────────────────────────────
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
  DEVIN_GLOBAL_DIR="${APPDATA}/devin"
else
  DEVIN_GLOBAL_DIR="${HOME}/.config/devin"
fi
DEVIN_GLOBAL_SKILLS="${DEVIN_GLOBAL_DIR}/skills"

# ── Parse arguments ────────────────────────────────────────────────────────
GLOBAL=false
FORCE=false
TARGET="."

for arg in "$@"; do
  case "$arg" in
    --global) GLOBAL=true ;;
    --force)  FORCE=true ;;
    *)        TARGET="$arg" ;;
  esac
done

# ── Helpers ────────────────────────────────────────────────────────────────
copy_if_missing() {
  local src="$1"
  local dst="$2"
  if [ ! -e "$dst" ]; then
    mkdir -p "$(dirname "$dst")"
    cp -r "$src" "$dst"
    echo "    + $(basename "$dst")"
  else
    echo "    ~ $(basename "$dst") (skipped — already exists)"
  fi
}

copy_always() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  cp -r "$src" "$dst"
  echo "    ✓ $(basename "$dst")"
}

# ── Mode: --global --force ─────────────────────────────────────────────────
if $GLOBAL && $FORCE; then
  echo "Installing SDD+SPDD into Devin global dir (OVERWRITE ALL)..."
  echo "  Path: $DEVIN_GLOBAL_DIR"
  echo ""

  echo "  AGENTS.md:"
  copy_always "AGENTS.md" "${DEVIN_GLOBAL_DIR}/AGENTS.md"

  echo "  spdd/ reference files:"
  mkdir -p "${DEVIN_GLOBAL_DIR}/spdd"
  for f in spdd/*.md; do
    copy_always "$f" "${DEVIN_GLOBAL_DIR}/${f}"
  done

  echo "  skills:"
  for skill_dir in .agents/skills/*/; do
    skill_name=$(basename "$skill_dir")
    copy_always "${skill_dir}SKILL.md" "${DEVIN_GLOBAL_SKILLS}/${skill_name}/SKILL.md"
  done

  echo ""
  echo "Done. All files overwritten in $DEVIN_GLOBAL_DIR"

# ── Mode: --global (add missing only) ─────────────────────────────────────
elif $GLOBAL; then
  echo "Installing SDD+SPDD into Devin global dir (add missing only)..."
  echo "  Path: $DEVIN_GLOBAL_DIR"
  echo ""

  echo "  AGENTS.md:"
  copy_if_missing "AGENTS.md" "${DEVIN_GLOBAL_DIR}/AGENTS.md"

  echo "  spdd/ reference files:"
  mkdir -p "${DEVIN_GLOBAL_DIR}/spdd"
  for f in spdd/*.md; do
    copy_if_missing "$f" "${DEVIN_GLOBAL_DIR}/${f}"
  done

  echo "  skills:"
  for skill_dir in .agents/skills/*/; do
    skill_name=$(basename "$skill_dir")
    copy_if_missing "${skill_dir}SKILL.md" "${DEVIN_GLOBAL_SKILLS}/${skill_name}/SKILL.md"
  done

  echo ""
  echo "Done. Existing files were not overwritten."
  echo "To overwrite everything, run: ./install.sh --global --force"

# ── Mode: project install (default) ───────────────────────────────────────
else
  echo "Installing SDD+SPDD into project: $TARGET"
  echo ""

  echo "  AGENTS.md:"
  copy_always "AGENTS.md" "${TARGET}/AGENTS.md"

  echo "  spdd/ reference files:"
  mkdir -p "${TARGET}/spdd"
  for f in spdd/*.md; do
    copy_always "$f" "${TARGET}/${f}"
  done

  echo "  .agents/skills/:"
  mkdir -p "${TARGET}/.agents/skills"
  for skill_dir in .agents/skills/*/; do
    skill_name=$(basename "$skill_dir")
    copy_always "${skill_dir}SKILL.md" "${TARGET}/.agents/skills/${skill_name}/SKILL.md"
  done

  echo ""
  echo "Done. To get started, ask your agent to run 'sdd-workflow'."
  echo ""
  echo "Tip: to also install globally, run:"
  echo "  ./install.sh --global           (add missing only)"
  echo "  ./install.sh --global --force   (overwrite all)"
fi
