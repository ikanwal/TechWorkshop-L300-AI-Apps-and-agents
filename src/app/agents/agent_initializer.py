import os
from azure.ai.projects import AIProjectClient
from azure.ai.agents.models import ToolSet
from dotenv import load_dotenv

load_dotenv()

def initialize_agent(project_client : AIProjectClient, model : str, env_var_name : str, name : str, instructions : str, toolset : ToolSet):
    agent_id = os.environ.get(env_var_name, "")
    with project_client:
        agent_exists = False
        if agent_id:
            try:
                # Check if agent exists.
                agent = project_client.agents.get_agent(agent_id)
                print(f"Retrieved existing agent, ID: {agent.id}")
                agent_exists = True
            except Exception as e:
                print(f"Agent ID {agent_id} not found or error retrieving: {e}")
                agent_exists = False
        
        if agent_exists:
            agent = project_client.agents.update_agent(
                agent_id=agent.id,
                model=model,
                name=name,
                instructions=instructions,
                toolset=toolset
            )
            print(f"Updated {env_var_name} agent, ID: {agent.id}")
            print(f"AGENT_ID={agent.id}")  # For workflow capture
        else:
            agent = project_client.agents.create_agent(
            model=model,
            name=name,
            instructions=instructions,
            toolset=toolset
            )
            print(f"Created {env_var_name} agent, ID: {agent.id}")
            print(f"AGENT_ID={agent.id}")  # For workflow capture
            print(f"\n⚠️  IMPORTANT: Update your .env file with:")
            print(f"{env_var_name}={agent.id}")
        
        return agent

