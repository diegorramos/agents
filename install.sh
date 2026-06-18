#!/bin/bash
# SDD + SPDD — Install Script
# Usage: ./install.sh /path/to/your/project
# Installs AGENTS.md, spdd/ references, and .agents/skills/ into a target project

TARGET=${1:-.}

echo "Installing SDD+SPDD into $TARGET..."

# AGENTS.md na raiz do projeto alvo
cp AGENTS.md "$TARGET/AGENTS.md"
echo "  ✓ AGENTS.md"

# Referências SPDD (lidas sob demanda pelas skills)
mkdir -p "$TARGET/spdd"
cp spdd/*.md "$TARGET/spdd/"
echo "  ✓ spdd/ (canvas.md, tdd.md, risks.md, perftest.md)"

# Skills agnósticas (.agents/skills/)
mkdir -p "$TARGET/.agents/skills"
cp -r .agents/skills/* "$TARGET/.agents/skills/"
echo "  ✓ .agents/skills/"
ls "$TARGET/.agents/skills/" | sed 's/^/      - /'

echo ""
echo "Done. To get started, ask your agent to run 'sdd-workflow'."
