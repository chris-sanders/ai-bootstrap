#!/bin/bash
# AI Agent Development Workflow Bootstrap Script Core Logic
# This file contains the core logic of the bootstrap script without templates
# It will be combined with templates by the build script

set -e

# Parse command line arguments
INCLUDE_ADR=false
INCLUDE_GITHUB_MCP=true
FORCE=false
PROJECT_DIR="."

while [[ $# -gt 0 ]]; do
  case "$1" in
    --with-adr)
      INCLUDE_ADR=true
      shift
      ;;
    --without-github-mcp)
      INCLUDE_GITHUB_MCP=false
      shift
      ;;
    --force)
      FORCE=true
      shift
      ;;
    *)
      PROJECT_DIR="$1"
      shift
      ;;
  esac
done

AGENTIC_DIR="$PROJECT_DIR/docs/agentic"
TASKS_DIR="$PROJECT_DIR/tasks"
DOCS_DIR="$PROJECT_DIR/docs"

# Helper function to create files idempotently
create_file() {
  local file_path="$1"
  local content_file="$2"
  
  # Create directories if they don't exist
  mkdir -p "$(dirname "$file_path")"
  
  # Only create/overwrite the file if it doesn't exist or force is enabled
  if [ ! -f "$file_path" ] || [ "$FORCE" = true ]; then
    cat "$content_file" > "$file_path"
    echo "Created: $file_path"
  else
    echo "Skipped: $file_path (already exists, use --force to overwrite)"
  fi
}

# Function to create a file with content from a heredoc
create_file_with_content() {
  local file_path="$1"
  local temp_file=$(mktemp)
  
  # Write stdin content to temp file
  cat > "$temp_file"
  
  # Create the actual file
  create_file "$file_path" "$temp_file"
  
  # Clean up temp file
  rm "$temp_file"
}

echo "Setting up AI Agent Development Workflow in $PROJECT_DIR"

# Create directory structure
mkdir -p "$AGENTIC_DIR/templates"
mkdir -p "$TASKS_DIR/backlog" "$TASKS_DIR/ready" "$TASKS_DIR/started" "$TASKS_DIR/review" "$TASKS_DIR/completed"
mkdir -p "$DOCS_DIR/components"

# Create decisions directory only if ADR is enabled
if [ "$INCLUDE_ADR" = true ]; then
  mkdir -p "$DOCS_DIR/decisions"
  echo "Including ADR documentation"
fi

# Display GitHub MCP status
if [ "$INCLUDE_GITHUB_MCP" = true ]; then
  echo "Including GitHub MCP workflow integration (default)"
else
  echo "GitHub MCP workflow integration disabled"
fi

# TEMPLATE_INSERTION_POINT: ai_readme

# TEMPLATE_INSERTION_POINT: task_template

# TEMPLATE_INSERTION_POINT: component_doc

# TEMPLATE_INSERTION_POINT: architecture

# TEMPLATE_INSERTION_POINT: adr_template

# TEMPLATE_INSERTION_POINT: example_task

echo "Workflow initialized successfully!"
echo ""
echo "Next steps:"
echo "1. Customize the architecture documentation in $DOCS_DIR/architecture.md"
echo "2. Review the sample task in $TASKS_DIR/backlog/TASK-001-example.md"
echo "3. Create additional tasks using the template in $AGENTIC_DIR/templates/task-template.md"
echo ""
if [ "$INCLUDE_ADR" = true ]; then
  echo "4. Create ADRs in $DOCS_DIR/decisions/ to document architecture decisions"
  echo ""
fi
echo "To start working with an AI agent:"
echo "1. Move tasks from backlog to ready when they're fully defined and ready for implementation"
echo "2. Point the AI agent to your project repository"
echo "3. Instruct it to read $AGENTIC_DIR/ai-readme.md first"
echo "4. The agent will find tasks in the ready folder and begin working"
echo ""
echo "Script options:"
echo "- To include Architecture Decision Records: --with-adr"
echo "- To disable GitHub MCP workflow integration (enabled by default): --without-github-mcp"
echo "- To force overwrite of existing files: --force"