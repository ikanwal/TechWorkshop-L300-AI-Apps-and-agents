# Agent Deployment Workflows

This directory contains GitHub Actions workflows for automatically deploying AI agents to Azure AI Foundry.

## Available Workflows

### 1. Interior Design Agent (`deploy-interior-design-agent.yml`)
Deploys the Interior Design Agent responsible for:
- Product recommendations and upselling
- Creating custom design images
- Assisting with DIY projects and interior design queries

**Triggers on changes to:**
- `src/app/agents/interiorDesignAgent_initializer.py`
- `src/prompts/InteriorDesignAgentPrompt.txt`
- `src/app/tools/imageCreationTool.py`

### 2. Inventory Agent (`deploy-inventory-agent.yml`)
Deploys the Inventory Agent responsible for:
- Checking inventory status
- Reporting inventory levels and locations
- Providing real-time stock information

**Triggers on changes to:**
- `src/app/agents/inventoryAgent_initializer.py`
- `src/prompts/InventoryAgentPrompt.txt`
- `src/app/tools/inventoryCheck.py`

### 3. Shopper Agent (`deploy-shopper-agent.yml`)
Deploys the Shopper Agent (Cora) responsible for:
- General customer service and greetings
- Understanding customer needs
- Routing to specialized agents

**Triggers on changes to:**
- `src/app/agents/shopperAgent_initializer.py`
- `src/prompts/ShopperAgentPrompt.txt`
- `src/app/tools/aiSearchTools.py`

## Workflow Structure

Each workflow follows the same pattern:

```yaml
1. Checkout code
2. Set up Python 3.12
3. Install dependencies
4. Create .env file from secrets
5. Azure Login
6. Deploy Agent
7. Clean up .env file
```

## Required Secrets

The workflows require the following GitHub secrets to be configured:

| Secret | Description |
|--------|-------------|
| `ENV` | Complete .env file contents with all environment variables |
| `AZURE_CREDENTIALS` | Azure service principal credentials for login |
| `AZURE_CLIENT_ID` | Azure AD application (client) ID |
| `AZURE_TENANT_ID` | Azure AD tenant (directory) ID |
| `AZURE_CLIENT_SECRET` | Azure AD application client secret |

## Manual Triggering

### Option 1: Using GitHub CLI (Recommended)

Run the provided script to trigger all workflows:

```bash
./trigger-agent-deployments.sh
```

Or trigger individual workflows:

```bash
# Interior Design Agent
gh workflow run deploy-interior-design-agent.yml

# Inventory Agent
gh workflow run deploy-inventory-agent.yml

# Shopper Agent
gh workflow run deploy-shopper-agent.yml
```

### Option 2: Using GitHub Web Interface

1. Go to the [Actions tab](https://github.com/ikanwal/TechWorkshop-L300-AI-Apps-and-agents/actions)
2. Select the workflow you want to run
3. Click "Run workflow" button
4. Select the branch (usually `main`)
5. Click "Run workflow"

### Option 3: Using GitHub API

```bash
# Set your personal access token
export GITHUB_TOKEN="your_token_here"

# Trigger Interior Design Agent
curl -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  https://api.github.com/repos/ikanwal/TechWorkshop-L300-AI-Apps-and-agents/actions/workflows/deploy-interior-design-agent.yml/dispatches \
  -d '{"ref":"main"}'

# Trigger Inventory Agent
curl -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  https://api.github.com/repos/ikanwal/TechWorkshop-L300-AI-Apps-and-agents/actions/workflows/deploy-inventory-agent.yml/dispatches \
  -d '{"ref":"main"}'

# Trigger Shopper Agent
curl -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  https://api.github.com/repos/ikanwal/TechWorkshop-L300-AI-Apps-and-agents/actions/workflows/deploy-shopper-agent.yml/dispatches \
  -d '{"ref":"main"}'
```

## Monitoring Workflow Runs

### Using GitHub CLI

```bash
# List recent workflow runs
gh run list

# Watch the latest run
gh run watch

# View details of a specific run
gh run view <run-id>

# View logs of a specific run
gh run view <run-id> --log
```

### Using GitHub Web Interface

Visit: https://github.com/ikanwal/TechWorkshop-L300-AI-Apps-and-agents/actions

## Troubleshooting

### Workflow fails with "Authentication failed"
- Verify that `AZURE_CREDENTIALS` secret is correctly configured
- Ensure the service principal has necessary permissions
- Check that credentials haven't expired

### Workflow fails during deployment step
- Review the workflow logs for specific error messages
- Verify that the `.env` file (from `ENV` secret) contains all required variables
- Ensure the Python initializer script is working correctly locally

### Workflow doesn't trigger on push
- Verify that the changed file matches one of the paths in the workflow trigger
- Ensure changes are pushed to the `main` branch
- Check that the workflow file itself is valid YAML

## Best Practices

1. **Test Locally First**: Before relying on the workflow, test the agent deployment locally
2. **Review Changes**: Always review prompt and code changes before merging to main
3. **Monitor Deployments**: Watch the workflow execution to catch issues early
4. **Use Pull Requests**: Make changes through PRs to review before deployment
5. **Version Control**: Keep track of which version of prompts and code are deployed

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Azure Login Action](https://github.com/Azure/login)
- [Azure AI Foundry Documentation](https://learn.microsoft.com/azure/ai-studio/)
