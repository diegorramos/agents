#!/bin/bash
# SDD + SPDD — Install Script
# Usage: ./install.sh /path/to/your/project
# Installs AGENTS.md, spdd/ references, and .agents/skills/ into a target project

TARGET=${1:-.}

echo "Installing SDD+SPDD into $TARGET..."

cp AGENTS.md "$TARGET/AGENTS.md"
echo "  ✓ AGENTS.md"

mkdir -p "$TARGET/spdd"
cp spdd/*.md "$TARGET/spdd/"
echo "  ✓ spdd/ (REASONS Canvas files + tdd + risks + perftest):"
ls spdd/*.md | xargs -I{} basename {} | sed 's/^/      - /'

mkdir -p "$TARGET/.agents/skills"
cp -r .agents/skills/* "$TARGET/.agents/skills/"
echo "  ✓ .agents/skills/:"
ls "$TARGET/.agents/skills/" | sed 's/^/      - /'

echo ""
echo "Done. To get started, ask your agent to run 'sdd-workflow'."
