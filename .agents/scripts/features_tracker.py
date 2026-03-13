#!/usr/bin/env python3
import os
import json
import argparse
from pathlib import Path

def get_project_root() -> Path:
    # This script is expected to be in .agent/scripts/
    return Path(__file__).parent.parent.parent.resolve()

def get_features_json_path() -> Path:
    return get_project_root() / "data" / "features.json"

def get_features_dir() -> Path:
    return get_project_root() / "features"

def load_features_json() -> list:
    path = get_features_json_path()
    if not path.exists():
        return []
    try:
        with open(path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception:
        return []

def save_features_json(data: list):
    path = get_features_json_path()
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2)

def add_feature(session_name: str):
    root = get_project_root()
    features_dir = get_features_dir()
    session_path = features_dir / session_name
    
    if not session_path.exists():
        print(f"Error: Session directory {session_path} does not exist.")
        return

    # Find microservices (all subdirectories in session_path)
    subfolders = []
    # In some cases, there's another level of directory, for example some workflows create features/<session>/auth/<service>
    # So we search for any directory that's not hidden
    for item in session_path.rglob("*"):
        if item.is_dir() and not item.name.startswith("."):
            # We want to know if it's a "leaf" service or a intermediate folder
            # For simplicity, we can list everything or just the top level ones
            # Let's list the relevant ones (like services or projects)
            # The prompt said "all subfolders it possesses"
            subfolders.append({
                "name": item.name,
                "path": str(item.resolve())
            })

    # To avoid listing deep nested folders as "features", let's focus on first-level subfolders
    # if they are git repos or contain package.json/docker-compose.yml
    # but the user was generic, so I'll just keep the first level of session_path
    
    # Redefining subfolders to be only first level or specific structure
    subfolders = []
    for item in session_path.iterdir():
        if item.is_dir() and not item.name.startswith("."):
            subfolders.append({
                "name": item.name,
                "path": str(item.resolve())
            })
            # Check for sub-projects (like projets/auth/auth-x)
            for sub_item in item.iterdir():
                 if sub_item.is_dir() and not sub_item.name.startswith("."):
                     subfolders.append({
                         "name": f"{item.name}/{sub_item.name}",
                         "path": str(sub_item.resolve())
                     })

    features_data = load_features_json()
    
    # Ensure it's a list and items are dicts
    if not isinstance(features_data, list):
        features_data = []
    
    # Filter out invalid entries or use existing ones (keeping only non-current session entries)
    updated_features = []
    for f in features_data:
        if isinstance(f, dict) and f.get("name") != session_name:
            updated_features.append(f)

    updated_features.append({
        "name": session_name,
        "path": str(session_path.resolve()),
        "subfolders": subfolders
    })
    
    save_features_json(updated_features)
    print(f"Added feature {session_name} to features.json")

def remove_feature(session_name: str):
    features_data = load_features_json()
    if not isinstance(features_data, list):
        print(f"Malformated features.json. Resetting...")
        save_features_json([])
        return
        
    new_features = [f for f in features_data if isinstance(f, dict) and f.get("name") != session_name]
    
    if len(features_data) == len(new_features):
        print(f"Feature {session_name} not found in features.json")
    else:
        save_features_json(new_features)
        print(f"Removed feature {session_name} from features.json")

def main():
    parser = argparse.ArgumentParser(description="Manage features.json for tracking git worktree sessions.")
    parser.add_argument("action", choices=["add", "remove"], help="Action to perform")
    parser.add_argument("name", help="Name of the session")
    
    args = parser.parse_args()
    
    if args.action == "add":
        add_feature(args.name)
    elif args.action == "remove":
        remove_feature(args.name)

if __name__ == "__main__":
    main()
