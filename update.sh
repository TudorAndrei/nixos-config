#!/usr/bin/env bash

# Exit immediately if any command fails
set -euo pipefail

# Update flake inputs
echo "🔄 Updating flake inputs..."
nix flake update

# Switch OS configuration
echo "🖥️  Switching OS configuration..."
nh os switch

# Switch Home configuration
echo "🏠 Switching Home configuration..."
nh home switch

# Commit changes if there are any
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
