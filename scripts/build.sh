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

# Create a temporary working file
TEMP_OUTPUT=$(mktemp)

# Add script header
cat > "$TEMP_OUTPUT" << EOF
#!/bin/bash
# Version: ${VERSION}
# Generated: ${TIMESTAMP}
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

# Helper function to create files idempotently
create_file() {
  local file_path="\$1"
  local content_file="\$2"
  
  # Create directories if they don't exist
  mkdir -p "\$(dirname "\$file_path")"
  
  # Only create/overwrite the file if it doesn't exist or force is enabled
  if [ ! -f "\$file_path" ] || [ "\$FORCE" = true ]; then
    cat "\$content_file" > "\$file_path"
    echo "Created: \$file_path"
  else
    echo "Skipped: \$file_path (already exists, use --force to overwrite)"
  fi
}

# Function to create a file with content from a heredoc
create_file_with_content() {
  local file_path="\$1"
  local temp_file=\$(mktemp)
  
  # Write stdin content to temp file
  cat > "\$temp_file"
  
  # Create the actual file
  create_file "\$file_path" "\$temp_file"
  
  # Clean up temp file
  rm "\$temp_file"
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
EOF

# 1. AI readme (conditional based on GitHub MCP)
cat >> "$TEMP_OUTPUT" << 'SCRIPT'

# AI readme file
if [ "$INCLUDE_GITHUB_MCP" = true ]; then
  # AI readme with GitHub MCP integration
  cat << 'EOF' | create_file_with_content "$AGENTIC_DIR/ai-readme.md"
SCRIPT

# Append template content for AI readme
cat "${TEMPLATES_DIR}/base/ai-readme-base.md" >> "$TEMP_OUTPUT"
cat "${TEMPLATES_DIR}/features/github-mcp/ai-readme-github-extension.md" >> "$TEMP_OUTPUT"

# Close heredoc and add GitHub MCP guide
cat >> "$TEMP_OUTPUT" << 'SCRIPT'
EOF

  # GitHub MCP guide file
  cat << 'EOF' | create_file_with_content "$AGENTIC_DIR/github-mcp-guide.md"
SCRIPT

# Append GitHub MCP guide content
cat "${TEMPLATES_DIR}/features/github-mcp/github-mcp-guide.md" >> "$TEMP_OUTPUT"

# Close heredoc and add else case
cat >> "$TEMP_OUTPUT" << 'SCRIPT'
EOF
else
  # AI readme without GitHub MCP integration
  cat << 'EOF' | create_file_with_content "$AGENTIC_DIR/ai-readme.md"
SCRIPT

# Append non-GitHub content
cat "${TEMPLATES_DIR}/base/ai-readme-base.md" >> "$TEMP_OUTPUT"
cat "${TEMPLATES_DIR}/base/git-commit-guidelines.md" >> "$TEMP_OUTPUT"

# Close heredoc and if statement
cat >> "$TEMP_OUTPUT" << 'SCRIPT'
EOF
fi

# Task template
cat << 'EOF' | create_file_with_content "$AGENTIC_DIR/templates/task-template.md"
SCRIPT

# Append task template content
cat "${TEMPLATES_DIR}/base/task-template.md" >> "$TEMP_OUTPUT"

# Close heredoc
cat >> "$TEMP_OUTPUT" << 'SCRIPT'
EOF

# Component documentation template
cat << 'EOF' | create_file_with_content "$AGENTIC_DIR/templates/component-doc.md"
SCRIPT

# Append component doc template content
cat "${TEMPLATES_DIR}/base/component-doc.md" >> "$TEMP_OUTPUT"

# Close heredoc
cat >> "$TEMP_OUTPUT" << 'SCRIPT'
EOF

# Architecture document
cat << 'EOF' | create_file_with_content "$DOCS_DIR/architecture.md"
SCRIPT

# Append architecture content
cat "${TEMPLATES_DIR}/base/architecture.md" >> "$TEMP_OUTPUT"

# Close heredoc and add ADR conditional
cat >> "$TEMP_OUTPUT" << 'SCRIPT'
EOF

# Create ADR template if enabled
if [ "$INCLUDE_ADR" = true ]; then
  cat << 'EOF' | create_file_with_content "$DOCS_DIR/decisions/ADR-template.md"
SCRIPT

# Append ADR template content
cat "${TEMPLATES_DIR}/features/adr/adr-template.md" >> "$TEMP_OUTPUT"

# Close heredoc and if statement
cat >> "$TEMP_OUTPUT" << 'SCRIPT'
EOF
fi

# Example task
cat << 'EOF' | create_file_with_content "$TASKS_DIR/backlog/TASK-001-example.md"
SCRIPT

# Append example task content
cat "${TEMPLATES_DIR}/base/example-task.md" >> "$TEMP_OUTPUT"

# Close heredoc and add final script section
cat >> "$TEMP_OUTPUT" << 'SCRIPT'
EOF

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
SCRIPT

# Create output directory if it doesn't exist
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Move the temporary file to the final location
cp "$TEMP_OUTPUT" "$OUTPUT_FILE"
rm "$TEMP_OUTPUT"

# Make the output file executable
chmod +x "$OUTPUT_FILE"

echo "Successfully built agentic-bootstrap script at $OUTPUT_FILE"
if [ "$VERBOSE" = true ]; then
  echo "Final file size: $(wc -c < "$OUTPUT_FILE") bytes"
  echo "Line count: $(wc -l < "$OUTPUT_FILE") lines"
fi