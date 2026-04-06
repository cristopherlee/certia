#!/bin/bash

# Configuration
TASKS_DIR="tasks"
COMPLETED_TASKS_DIR="completed_tasks"

# Ensure completed tasks directory exists
mkdir -p "$COMPLETED_TASKS_DIR"

function usage() {
    echo "Usage: $0 [list | archive <task_name> | remove <task_name>]"
    exit 1
}

if [ -z "$1" ]; then
    usage
fi

case "$1" in
    list)
        echo "## Currently tracked tasks in $TASKS_DIR/ ##"
        if [ ! -d "$TASKS_DIR" ] || [ -z "$(ls -A $TASKS_DIR)" ]; then
            echo "No tasks found."
        else
            ls -1d "$TASKS_DIR"/*/ | xargs -n 1 basename
        fi
        ;;
    archive)
        if [ -z "$2" ]; then
            echo "Error: Task name required for archiving."
            usage
        fi
        TASK_NAME="$2"
        TASK_PATH="$TASKS_DIR/$TASK_NAME"
        if [ -d "$TASK_PATH" ]; then
            echo "Archiving task: $TASK_NAME..."
            tar -czf "$COMPLETED_TASKS_DIR/$TASK_NAME.tar.gz" -C "$TASKS_DIR" "$TASK_NAME"
            echo "Archive created at $COMPLETED_TASKS_DIR/$TASK_NAME.tar.gz"
            rm -rf "$TASK_PATH"
            echo "Task directory $TASK_PATH removed."
        else
            echo "Error: Task $TASK_NAME not found in $TASKS_DIR."
        fi
        ;;
    remove)
        if [ -z "$2" ]; then
            echo "Error: Task name required for removal."
            usage
        fi
        TASK_NAME="$2"
        TASK_PATH="$TASKS_DIR/$TASK_NAME"
        if [ -d "$TASK_PATH" ]; then
            echo "Removing task: $TASK_NAME..."
            rm -rf "$TASK_PATH"
            echo "Task directory $TASK_PATH removed."
        else
            echo "Error: Task $TASK_NAME not found in $TASKS_DIR."
        fi
        ;;
    *)
        usage
        ;;
esac
