#!/usr/bin/env python3
import os
import re
import sys
from pathlib import Path

def print_error(msg):
    print(f"\033[91m❌ {msg}\033[0m")

def print_success(msg):
    print(f"\033[92m✅ {msg}\033[0m")

def print_warning(msg):
    print(f"\033[93m⚠️  {msg}\033[0m")

def verify_catalog():
    root_dir = Path(__file__).parent.parent.parent
    catalog_path = root_dir / "AGENT_CATALOG.md"
    agents_dir = root_dir / ".agent" / "agents"

    if not catalog_path.exists():
        print_error(f"Catalog not found at {catalog_path}")
        return False

    if not agents_dir.exists():
        print_error(f"Agents directory not found at {agents_dir}")
        return False

    # Read catalog
    with open(catalog_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Extract agents from table
    # Format: | **agent-name** | ... | [agent-name.md](.agent/agents/agent-name.md) |
    # We'll use the link part as it's more definitive of what file should exist
    links = re.findall(r"\[([^\]]+\.md)\]\(\.agent/agents/([^)]+)\)", content)
    
    catalog_agents = {link[1] for link in links}
    actual_agents = {f.name for f in agents_dir.glob("*.md")}

    errors = 0

    print(f"Checking catalog consistency...")
    
    # 1. Check if agents in catalog exist in directory
    for agent_file in sorted(catalog_agents):
        if agent_file not in actual_agents:
            print_error(f"Agent '{agent_file}' listed in catalog but NOT found in {agents_dir}")
            errors += 1
        else:
            # Optional: check if the link text matches the filename
            pass

    # 2. Check if agents in directory are in catalog
    for agent_file in sorted(actual_agents):
        if agent_file not in catalog_agents:
            print_warning(f"Agent '{agent_file}' exists in directory but is NOT listed in AGENT_CATALOG.md")
            # This might not be an error depending on strictness, but let's report it.

    if errors == 0:
        print_success(f"Catalog verification passed! ({len(catalog_agents)} agents verified)")
        return True
    else:
        print_error(f"Catalog verification failed with {errors} errors.")
        return False

if __name__ == "__main__":
    success = verify_catalog()
    sys.exit(0 if success else 1)
