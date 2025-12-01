#!/bin/bash

# Script to trigger GitHub workflow deployments for Interior Design, Inventory, and Shopper agents
# This script uses the GitHub CLI (gh) to manually trigger workflow dispatches

set -e

echo "=========================================="
echo "Agent Deployment Trigger Script"
echo "=========================================="
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed."
    echo "Please install it from: https://cli.github.com/"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    echo "Error: Not authenticated with GitHub CLI."
    echo "Please run: gh auth login"
    exit 1
fi

echo "Triggering agent deployment workflows..."
echo ""

# Trigger Interior Design Agent deployment
echo "1. Triggering Interior Design Agent deployment..."
gh workflow run deploy-interior-design-agent.yml
if [ $? -eq 0 ]; then
    echo "   ✓ Interior Design Agent workflow triggered successfully"
else
    echo "   ✗ Failed to trigger Interior Design Agent workflow"
fi
echo ""

# Trigger Inventory Agent deployment
echo "2. Triggering Inventory Agent deployment..."
gh workflow run deploy-inventory-agent.yml
if [ $? -eq 0 ]; then
    echo "   ✓ Inventory Agent workflow triggered successfully"
else
    echo "   ✗ Failed to trigger Inventory Agent workflow"
fi
echo ""

# Trigger Shopper Agent deployment
echo "3. Triggering Shopper Agent deployment..."
gh workflow run deploy-shopper-agent.yml
if [ $? -eq 0 ]; then
    echo "   ✓ Shopper Agent workflow triggered successfully"
else
    echo "   ✗ Failed to trigger Shopper Agent workflow"
fi
echo ""

echo "=========================================="
echo "All workflow triggers completed!"
echo "=========================================="
echo ""
echo "To monitor workflow runs, use:"
echo "  gh run list"
echo "  gh run watch"
echo ""
echo "Or visit: https://github.com/ikanwal/TechWorkshop-L300-AI-Apps-and-agents/actions"
