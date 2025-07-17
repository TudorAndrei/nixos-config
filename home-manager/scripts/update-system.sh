#!/usr/bin/env bash
set -euo pipefail

echo "🔄 Updating flake inputs..."
nix flake update

echo "🖥️  Switching OS configuration..."
nh os switch

echo "🏠 Switching Home configuration..."
nh home switch

echo "🔍 Checking for changes to commit..."
if git diff-index --quiet HEAD --; then
    echo "✅ No changes to commit."
else
    echo "💾 Committing changes..."
    git add -A
    git commit -m "chore: update system and home configurations"
    echo "🚀 Changes committed successfully!"
fi

echo "🎉 All done! System and home configurations updated."