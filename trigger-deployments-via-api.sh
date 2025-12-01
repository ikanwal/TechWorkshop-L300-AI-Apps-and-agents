#!/bin/bash

# Script to trigger GitHub workflows via API
# Requires: GITHUB_TOKEN environment variable or passed as argument

set -e

REPO_OWNER="ikanwal"
REPO_NAME="TechWorkshop-L300-AI-Apps-and-agents"
BRANCH="main"

echo "=========================================="
echo "Agent Deployment Trigger via GitHub API"
echo "=========================================="
echo ""

# Check for GitHub token
if [ -z "$GITHUB_TOKEN" ] && [ -z "$1" ]; then
    echo "Error: GitHub token not provided"
    echo ""
    echo "Usage:"
    echo "  Option 1: Export token as environment variable"
    echo "    export GITHUB_TOKEN='your_token_here'"
    echo "    ./trigger-deployments-via-api.sh"
    echo ""
    echo "  Option 2: Pass token as argument"
    echo "    ./trigger-deployments-via-api.sh 'your_token_here'"
    echo ""
    echo "To create a token:"
    echo "  1. Go to https://github.com/settings/tokens"
    echo "  2. Generate new token (classic)"
    echo "  3. Select 'workflow' scope"
    echo "  4. Copy the token"
    exit 1
fi

# Use provided token or environment variable
TOKEN="${1:-$GITHUB_TOKEN}"

echo "Repository: $REPO_OWNER/$REPO_NAME"
echo "Branch: $BRANCH"
echo ""

# Function to trigger a workflow
trigger_workflow() {
    local workflow_file=$1
    local workflow_name=$2
    
    echo "Triggering: $workflow_name..."
    
    response=$(curl -s -w "\n%{http_code}" -X POST \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer $TOKEN" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/actions/workflows/$workflow_file/dispatches" \
        -d "{\"ref\":\"$BRANCH\"}")
    
    http_code=$(echo "$response" | tail -n1)
    
    if [ "$http_code" -eq 204 ]; then
        echo "  ✓ $workflow_name triggered successfully"
        return 0
    else
        echo "  ✗ Failed to trigger $workflow_name (HTTP $http_code)"
        echo "$response" | head -n-1
        return 1
    fi
}

echo "Triggering workflows..."
echo ""

# Trigger each workflow
trigger_workflow "deploy-interior-design-agent.yml" "Interior Design Agent"
echo ""

trigger_workflow "deploy-inventory-agent.yml" "Inventory Agent"
echo ""

trigger_workflow "deploy-shopper-agent.yml" "Shopper Agent"
echo ""

echo "=========================================="
echo "Workflow triggers completed!"
echo "=========================================="
echo ""
echo "Monitor workflow runs at:"
echo "  https://github.com/$REPO_OWNER/$REPO_NAME/actions"
echo ""
echo "Check status with:"
echo "  curl -H 'Authorization: Bearer \$GITHUB_TOKEN' \\"
echo "    https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/actions/runs"
echo ""
