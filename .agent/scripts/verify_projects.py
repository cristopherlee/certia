#!/usr/bin/env python3
import json
import jsonschema
import sys
from pathlib import Path

def print_error(msg):
    print(f"\033[91m❌ {msg}\033[0m")

def print_success(msg):
    print(f"\033[92m✅ {msg}\033[0m")

def verify_projects():
    root_dir = Path(__file__).parent.parent.parent
    # Try multiple locations for projects.json
    projects_paths = [
        Path.home() / ".gemini" / "projects.json",
        root_dir / ".gemini" / "projects.json",
        root_dir / "projects.json"
    ]
    
    projects_path = None
    for p in projects_paths:
        if p.exists():
            projects_path = p
            break
            
    schema_path = root_dir / ".agent" / "schemas" / "projects.schema.json"

    if not projects_path:
        print_error("Projects file (projects.json) not found in expected locations.")
        return False

    if not schema_path.exists():
        print_error(f"Schema file not found at {schema_path}")
        return False

    # Load file
    with open(projects_path, "r", encoding="utf-8") as f:
        try:
            data = json.load(f)
        except json.JSONDecodeError as e:
            print_error(f"Invalid JSON in {projects_path}: {e}")
            return False

    # Load schema
    with open(schema_path, "r", encoding="utf-8") as f:
        try:
            schema = json.load(f)
        except json.JSONDecodeError as e:
            print_error(f"Invalid JSON in schema {schema_path}: {e}")
            return False

    # Validate
    try:
        jsonschema.validate(instance=data, schema=schema)
        print_success(f"Projects catalog '{projects_path.name}' is valid according to schema.")
        return True
    except jsonschema.exceptions.ValidationError as e:
        print_error(f"Validation Error: {e.message}")
        print(f"Path: {'.'.join(str(v) for v in e.path)}")
        return False

if __name__ == "__main__":
    success = verify_projects()
    sys.exit(0 if success else 1)
