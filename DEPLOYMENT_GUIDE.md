# GitHub Workflow Deployment Guide

## Overview

This guide explains how to deploy the Interior Design, Inventory, and Shopper agents using GitHub Actions workflows.

## Available Agents

1. **Interior Design Agent** - Handles product recommendations and custom design images
2. **Inventory Agent** - Manages inventory checks and stock status
3. **Shopper Agent (Cora)** - Provides general customer service

## Deployment Methods

### Method 1: Automatic Deployment (Recommended for Production)

Workflows automatically trigger when you push changes to the `main` branch that affect specific files:

**Interior Design Agent** triggers on changes to:
- `src/app/agents/interiorDesignAgent_initializer.py`
- `src/prompts/InteriorDesignAgentPrompt.txt`
- `src/app/tools/imageCreationTool.py`

**Inventory Agent** triggers on changes to:
- `src/app/agents/inventoryAgent_initializer.py`
- `src/prompts/InventoryAgentPrompt.txt`
- `src/app/tools/inventoryCheck.py`

**Shopper Agent** triggers on changes to:
- `src/app/agents/shopperAgent_initializer.py`
- `src/prompts/ShopperAgentPrompt.txt`
- `src/app/tools/aiSearchTools.py`

**Usage:**
```bash
# Make changes to agent files
git add src/prompts/InteriorDesignAgentPrompt.txt
git commit -m "Update interior design agent prompt"
git push origin main
```

### Method 2: Manual Trigger via Git Commit

Use this method to trigger all three agent deployments with a single commit:

```bash
./trigger-deployments-via-commit.sh
```

**What it does:**
- Updates modification timestamps on all three prompt files
- Creates a commit
- Optionally pushes to trigger the workflows

**Advantages:**
- No API token needed
- Simple and straightforward
- Works with standard git authentication

### Method 3: Manual Trigger via GitHub API

Use this method for programmatic or CI/CD integration:

```bash
# Set your GitHub Personal Access Token
export GITHUB_TOKEN='your_token_here'

# Run the script
./trigger-deployments-via-api.sh
```

**Or pass token as argument:**
```bash
./trigger-deployments-via-api.sh 'your_token_here'
```

**Creating a GitHub Token:**
1. Go to https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Give it a descriptive name
4. Select the `workflow` scope
5. Click "Generate token"
6. Copy and save the token securely

**Advantages:**
- No git commits needed
- Can be integrated into other automation
- Immediate trigger without code changes

### Method 4: Manual Trigger via GitHub CLI

If you have GitHub CLI installed and authenticated:

```bash
# Trigger all workflows
./trigger-agent-deployments.sh

# Or trigger individually
gh workflow run deploy-interior-design-agent.yml
gh workflow run deploy-inventory-agent.yml
gh workflow run deploy-shopper-agent.yml
```

**Setup GitHub CLI:**
```bash
# Install (if not already installed)
# On macOS: brew install gh
# On Ubuntu: sudo apt install gh

# Authenticate
gh auth login
```

**Advantages:**
- Clean interface
- No token management needed after auth
- Can monitor runs easily

### Method 5: Manual Trigger via GitHub Web UI

1. Go to [GitHub Actions](https://github.com/ikanwal/TechWorkshop-L300-AI-Apps-and-agents/actions)
2. Click on the workflow you want to run:
   - "Deploy Interior Design Agent"
   - "Deploy Inventory Agent"
   - "Deploy Shopper Agent (Cora)"
3. Click the "Run workflow" button (top right)
4. Select branch: `main`
5. Click "Run workflow"

**Advantages:**
- No command line needed
- Visual confirmation
- Easy for non-technical users

## Monitoring Deployments

### Using GitHub Web Interface

Visit: https://github.com/ikanwal/TechWorkshop-L300-AI-Apps-and-agents/actions

You'll see:
- ✓ Successful runs in green
- ✗ Failed runs in red
- ⏳ In-progress runs in yellow

Click on any run to see detailed logs.

### Using GitHub CLI

```bash
# List recent runs
gh run list

# Watch the latest run in real-time
gh run watch

# View specific run details
gh run view <run-id>

# View logs
gh run view <run-id> --log
```

### Using GitHub API

```bash
# List recent workflow runs
curl -H "Authorization: Bearer $GITHUB_TOKEN" \
  "https://api.github.com/repos/ikanwal/TechWorkshop-L300-AI-Apps-and-agents/actions/runs" | jq '.workflow_runs[] | {id, name, status, conclusion}'
```

## Troubleshooting

### Issue: Workflow doesn't trigger automatically

**Possible causes:**
- Changes weren't pushed to `main` branch
- Changed files don't match the workflow's path triggers
- Workflow file has syntax errors

**Solution:**
```bash
# Check current branch
git branch --show-current

# Verify you're on main
git checkout main
git pull origin main

# Check workflow file syntax
cat .github/workflows/deploy-interior-design-agent.yml | grep -A 5 "paths:"
```

### Issue: Workflow fails with authentication error

**Possible causes:**
- Azure credentials expired
- Secrets not configured correctly
- Service principal lacks permissions

**Solution:**
1. Verify secrets in GitHub Settings → Secrets and variables → Actions
2. Required secrets:
   - `ENV` - Environment variables file
   - `AZURE_CREDENTIALS` - Service principal JSON
   - `AZURE_CLIENT_ID`
   - `AZURE_TENANT_ID`
   - `AZURE_CLIENT_SECRET`

### Issue: API trigger returns 403/404 error

**Possible causes:**
- GitHub token lacks `workflow` scope
- Token expired
- Workflow file name incorrect

**Solution:**
```bash
# Verify workflow file exists
ls -la .github/workflows/deploy-*.yml

# Create new token with correct permissions
# Visit: https://github.com/settings/tokens
# Ensure 'workflow' scope is selected
```

### Issue: Deployment succeeds but agent doesn't update

**Possible causes:**
- Agent initialization script has errors
- Environment variables missing
- Azure AI Foundry connection issues

**Solution:**
1. Check workflow logs for the "Deploy [Agent Name]" step
2. Test the initializer script locally:
   ```bash
   cd src
   source .env
   python app/agents/interiorDesignAgent_initializer.py
   ```

## Best Practices

### 1. Test Before Deploying
```bash
# Test locally first
cd src
source .env
python app/agents/interiorDesignAgent_initializer.py
```

### 2. Use Feature Branches
```bash
# Create feature branch
git checkout -b feature/update-interior-design-prompt

# Make changes
# Test locally
# Create PR for review
# Merge to main to trigger deployment
```

### 3. Review Workflow Logs
Always check the logs after deployment to ensure everything worked correctly.

### 4. Keep Secrets Updated
Regularly rotate Azure credentials and update GitHub secrets.

### 5. Version Your Prompts
Consider adding version comments to prompt files:
```
# Interior Design Agent Prompt
# Version: 2.0.0
# Last Updated: 2025-12-01
```

## Quick Reference

### Trigger All Deployments
```bash
# Using git commit method (recommended)
./trigger-deployments-via-commit.sh

# Using API method
export GITHUB_TOKEN='your_token'
./trigger-deployments-via-api.sh

# Using GitHub CLI
gh workflow run deploy-interior-design-agent.yml
gh workflow run deploy-inventory-agent.yml
gh workflow run deploy-shopper-agent.yml
```

### Check Deployment Status
```bash
# GitHub CLI
gh run list --limit 5

# Web browser
open https://github.com/ikanwal/TechWorkshop-L300-AI-Apps-and-agents/actions
```

### View Logs
```bash
# Get latest run ID
RUN_ID=$(gh run list --limit 1 --json databaseId --jq '.[0].databaseId')

# View logs
gh run view $RUN_ID --log
```

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [Azure Login Action](https://github.com/Azure/login)
- [GitHub CLI Manual](https://cli.github.com/manual/)

## Support

For issues or questions:
1. Check workflow logs for error messages
2. Review this guide's troubleshooting section
3. Consult the [GitHub Actions documentation](https://docs.github.com/en/actions)
