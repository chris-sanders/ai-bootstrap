#!/bin/bash
# Build script for agentic-bootstrap
# Combines templates with core logic to generate a distributable script

set -e

# Default build configuration
VERSION="1.0.0"
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
OUTPUT_FILE="${PROJECT_ROOT}/dist/agentic-bootstrap.sh"
TEMPLATES_DIR="${PROJECT_ROOT}/templates"

# Parse arguments
VERBOSE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --verbose)
      VERBOSE=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: ./build.sh [--verbose]"
      exit 1
      ;;
  esac
done

# Print verbose information
if [ "$VERBOSE" = true ]; then
  echo "Building agentic-bootstrap script"
  echo "Version: $VERSION"
  echo "Timestamp: $TIMESTAMP"
  echo "Templates directory: $TEMPLATES_DIR"
  echo "Output file: $OUTPUT_FILE"
fi

# Create output directory if it doesn't exist
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Function to safely process template content
process_template() {
  local template_file="$1"
  local output_var="$2"
  
  # Read the template file and escape any problematic characters
  local content
  content=$(cat "$template_file" | sed 's/\$/\\$/g')
  
  # Update the output variable
  eval "$output_var=\"\$content\""
}

# Read template files into variables
README_BASE=""
README_GITHUB=""
GITHUB_MCP_GUIDE=""
GIT_COMMIT_GUIDELINES=""
TASK_TEMPLATE=""
COMPONENT_DOC=""
ARCHITECTURE=""
ADR_TEMPLATE=""
EXAMPLE_TASK=""

process_template "${TEMPLATES_DIR}/base/ai-readme-base.md" "README_BASE"
process_template "${TEMPLATES_DIR}/features/github-mcp/ai-readme-github-extension.md" "README_GITHUB"
process_template "${TEMPLATES_DIR}/features/github-mcp/github-mcp-guide.md" "GITHUB_MCP_GUIDE"
process_template "${TEMPLATES_DIR}/base/git-commit-guidelines.md" "GIT_COMMIT_GUIDELINES"
process_template "${TEMPLATES_DIR}/base/task-template.md" "TASK_TEMPLATE"
process_template "${TEMPLATES_DIR}/base/component-doc.md" "COMPONENT_DOC"
process_template "${TEMPLATES_DIR}/base/architecture.md" "ARCHITECTURE"
process_template "${TEMPLATES_DIR}/features/adr/adr-template.md" "ADR_TEMPLATE"
process_template "${TEMPLATES_DIR}/base/example-task.md" "EXAMPLE_TASK"

# Create the bootstrap script
cat > "$OUTPUT_FILE" << EOL
#!/bin/bash
# Version: $VERSION
# Generated: $TIMESTAMP
# AI Agent Development Workflow Bootstrap Script
# This script sets up the agentic workflow structure in your project
# Usage: ./agentic-bootstrap.sh [options] [project_directory]
# Options:
#   --with-adr         Include ADR (Architecture Decision Records) documentation
#   --without-github-mcp  Disable GitHub MCP workflow integration (enabled by default)
#   --force            Overwrite existing files even if they already exist

set -e

# Parse command line arguments
INCLUDE_ADR=false
INCLUDE_GITHUB_MCP=true
FORCE=false
PROJECT_DIR="."

while [[ \$# -gt 0 ]]; do
  case "\$1" in
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
      PROJECT_DIR="\$1"
      shift
      ;;
  esac
done

AGENTIC_DIR="\$PROJECT_DIR/docs/agentic"
TASKS_DIR="\$PROJECT_DIR/tasks"
DOCS_DIR="\$PROJECT_DIR/docs"

# Helper function to check if file exists and should be created
should_create_file() {
  local file_path="\$1"
  
  if [ ! -f "\$file_path" ] || [ "\$FORCE" = true ]; then
    return 0  # True - should create
  else
    return 1  # False - should skip
  fi
}

echo "Setting up AI Agent Development Workflow in \$PROJECT_DIR"

# Create directory structure
mkdir -p "\$AGENTIC_DIR/templates"
mkdir -p "\$TASKS_DIR/backlog" "\$TASKS_DIR/ready" "\$TASKS_DIR/started" "\$TASKS_DIR/review" "\$TASKS_DIR/completed"
mkdir -p "\$DOCS_DIR/components"

# Create decisions directory only if ADR is enabled
if [ "\$INCLUDE_ADR" = true ]; then
  mkdir -p "\$DOCS_DIR/decisions"
  echo "Including ADR documentation"
fi

# Display GitHub MCP status
if [ "\$INCLUDE_GITHUB_MCP" = true ]; then
  echo "Including GitHub MCP workflow integration (default)"
else
  echo "GitHub MCP workflow integration disabled"
fi

# Create AI readme file based on GitHub MCP flag
if [ "\$INCLUDE_GITHUB_MCP" = true ]; then
  # Create AI readme with GitHub MCP content
  README_PATH="\$AGENTIC_DIR/ai-readme.md"
  if should_create_file "\$README_PATH"; then
    cat > "\$README_PATH" << 'ENDOFFILE'
$README_BASE
$README_GITHUB
ENDOFFILE
    echo "Created: \$README_PATH"
  else
    echo "Skipped: \$README_PATH (already exists, use --force to overwrite)"
  fi
  
  # Create GitHub MCP guide
  MCP_GUIDE_PATH="\$AGENTIC_DIR/github-mcp-guide.md"
  if should_create_file "\$MCP_GUIDE_PATH"; then
    cat > "\$MCP_GUIDE_PATH" << 'ENDOFFILE'
$GITHUB_MCP_GUIDE
ENDOFFILE
    echo "Created: \$MCP_GUIDE_PATH"
  else
    echo "Skipped: \$MCP_GUIDE_PATH (already exists, use --force to overwrite)"
  fi
else
  # Create AI readme without GitHub MCP content
  README_PATH="\$AGENTIC_DIR/ai-readme.md"
  if should_create_file "\$README_PATH"; then
    cat > "\$README_PATH" << 'ENDOFFILE'
$README_BASE
$GIT_COMMIT_GUIDELINES
ENDOFFILE
    echo "Created: \$README_PATH"
  else
    echo "Skipped: \$README_PATH (already exists, use --force to overwrite)"
  fi
fi

# Create task template
TASK_TEMPLATE_PATH="\$AGENTIC_DIR/templates/task-template.md"
if should_create_file "\$TASK_TEMPLATE_PATH"; then
  cat > "\$TASK_TEMPLATE_PATH" << 'ENDOFFILE'
$TASK_TEMPLATE
ENDOFFILE
  echo "Created: \$TASK_TEMPLATE_PATH"
else
  echo "Skipped: \$TASK_TEMPLATE_PATH (already exists, use --force to overwrite)"
fi

# Create component documentation template
COMPONENT_DOC_PATH="\$AGENTIC_DIR/templates/component-doc.md"
if should_create_file "\$COMPONENT_DOC_PATH"; then
  cat > "\$COMPONENT_DOC_PATH" << 'ENDOFFILE'
$COMPONENT_DOC
ENDOFFILE
  echo "Created: \$COMPONENT_DOC_PATH"
else
  echo "Skipped: \$COMPONENT_DOC_PATH (already exists, use --force to overwrite)"
fi

# Create architecture document
ARCHITECTURE_PATH="\$DOCS_DIR/architecture.md"
if should_create_file "\$ARCHITECTURE_PATH"; then
  cat > "\$ARCHITECTURE_PATH" << 'ENDOFFILE'
$ARCHITECTURE
ENDOFFILE
  echo "Created: \$ARCHITECTURE_PATH"
else
  echo "Skipped: \$ARCHITECTURE_PATH (already exists, use --force to overwrite)"
fi

# Create ADR template if enabled
if [ "\$INCLUDE_ADR" = true ]; then
  ADR_TEMPLATE_PATH="\$DOCS_DIR/decisions/ADR-template.md"
  if should_create_file "\$ADR_TEMPLATE_PATH"; then
    cat > "\$ADR_TEMPLATE_PATH" << 'ENDOFFILE'
$ADR_TEMPLATE
ENDOFFILE
    echo "Created: \$ADR_TEMPLATE_PATH"
  else
    echo "Skipped: \$ADR_TEMPLATE_PATH (already exists, use --force to overwrite)"
  fi
fi

# Create a sample task
EXAMPLE_TASK_PATH="\$TASKS_DIR/backlog/TASK-001-example.md"
if should_create_file "\$EXAMPLE_TASK_PATH"; then
  cat > "\$EXAMPLE_TASK_PATH" << 'ENDOFFILE'
$EXAMPLE_TASK
ENDOFFILE
  echo "Created: \$EXAMPLE_TASK_PATH"
else
  echo "Skipped: \$EXAMPLE_TASK_PATH (already exists, use --force to overwrite)"
fi

echo "Workflow initialized successfully!"
echo ""
echo "Next steps:"
echo "1. Customize the architecture documentation in \$DOCS_DIR/architecture.md"
echo "2. Review the sample task in \$TASKS_DIR/backlog/TASK-001-example.md"
echo "3. Create additional tasks using the template in \$AGENTIC_DIR/templates/task-template.md"
echo ""
if [ "\$INCLUDE_ADR" = true ]; then
  echo "4. Create ADRs in \$DOCS_DIR/decisions/ to document architecture decisions"
  echo ""
fi
echo "To start working with an AI agent:"
echo "1. Move tasks from backlog to ready when they're fully defined and ready for implementation"
echo "2. Point the AI agent to your project repository"
echo "3. Instruct it to read \$AGENTIC_DIR/ai-readme.md first"
echo "4. The agent will find tasks in the ready folder and begin working"
echo ""
echo "Script options:"
echo "- To include Architecture Decision Records: --with-adr"
echo "- To disable GitHub MCP workflow integration (enabled by default): --without-github-mcp"
echo "- To force overwrite of existing files: --force"
EOL

# Make the output file executable
chmod +x "$OUTPUT_FILE"

echo "Successfully built agentic-bootstrap script at $OUTPUT_FILE"
if [ "$VERBOSE" = true ]; then
  echo "Final file size: $(wc -c < "$OUTPUT_FILE") bytes"
  echo "Line count: $(wc -l < "$OUTPUT_FILE") lines"
fi