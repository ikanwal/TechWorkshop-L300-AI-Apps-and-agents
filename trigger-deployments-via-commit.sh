#!/bin/bash

# Script to trigger agent deployments by creating a commit that touches the prompt files
# This will cause the workflows to run automatically

set -e

echo "=========================================="
echo "Agent Deployment Trigger via Git Commit"
echo "=========================================="
echo ""

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree &> /dev/null; then
    echo "Error: Not in a git repository"
    exit 1
fi

echo "This script will create a commit to trigger the agent deployment workflows."
echo ""

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)
echo "Current branch: $CURRENT_BRANCH"
echo ""

# Ask for confirmation
read -p "Do you want to trigger deployments on branch '$CURRENT_BRANCH'? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Deployment trigger cancelled."
    exit 0
fi

echo ""
echo "Triggering deployments by updating prompt modification timestamps..."
echo ""

# Touch the prompt files to update their modification time
# This will trigger the workflows without changing content
touch src/prompts/InteriorDesignAgentPrompt.txt
echo "✓ Touched InteriorDesignAgentPrompt.txt"

touch src/prompts/InventoryAgentPrompt.txt
echo "✓ Touched InventoryAgentPrompt.txt"

touch src/prompts/ShopperAgentPrompt.txt
echo "✓ Touched ShopperAgentPrompt.txt"

echo ""
echo "Creating deployment trigger commit..."

# Stage the files
git add src/prompts/InteriorDesignAgentPrompt.txt \
        src/prompts/InventoryAgentPrompt.txt \
        src/prompts/ShopperAgentPrompt.txt

# Create commit
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
git commit -m "chore: trigger agent deployments - $TIMESTAMP

Triggered deployments for:
- Interior Design Agent
- Inventory Agent  
- Shopper Agent

[skip ci] for other workflows"

echo ""
echo "Commit created successfully!"
echo ""

# Ask about pushing
read -p "Do you want to push this commit to trigger the workflows? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "Pushing to origin/$CURRENT_BRANCH..."
    git push origin "$CURRENT_BRANCH"
    echo ""
    echo "=========================================="
    echo "✓ Deployment triggers pushed successfully!"
    echo "=========================================="
    echo ""
    echo "The following workflows should now be running:"
    echo "  1. Deploy Interior Design Agent"
    echo "  2. Deploy Inventory Agent"
    echo "  3. Deploy Shopper Agent"
    echo ""
    echo "Monitor progress at:"
    echo "  https://github.com/ikanwal/TechWorkshop-L300-AI-Apps-and-agents/actions"
else
    echo ""
    echo "Commit created locally but not pushed."
    echo "Run 'git push' when ready to trigger the deployments."
fi

echo ""
