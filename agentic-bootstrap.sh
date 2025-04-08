#!/bin/bash
# AI Agent Development Workflow Bootstrap Script
# This script sets up the agentic workflow structure in your project
# Usage: ./agentic-bootstrap.sh [options] [project_directory]
# Options:
#   --with-adr  Include ADR (Architecture Decision Records) documentation
#   --force     Overwrite existing files even if they already exist

set -e

# Parse command line arguments
INCLUDE_ADR=false
FORCE=false
PROJECT_DIR="."

while [[ $# -gt 0 ]]; do
  case "$1" in
    --with-adr)
      INCLUDE_ADR=true
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
mkdir -p "$TASKS_DIR/backlog" "$TASKS_DIR/ready" "$TASKS_DIR/started" "$TASKS_DIR/completed"
mkdir -p "$DOCS_DIR/components"

# Create decisions directory only if ADR is enabled
if [ "$INCLUDE_ADR" = true ]; then
  mkdir -p "$DOCS_DIR/decisions"
  echo "Including ADR documentation"
fi

# Create AI readme file
cat << 'EOF' | create_file_with_content "$AGENTIC_DIR/ai-readme.md"
# AI Agent Instructions

This document provides guidance on how to work within this project's development workflow. Follow these instructions to effectively contribute to the project.

## Task Management Workflow

As an AI agent, you should:

1. **Find tasks to work on**:
   - Look in `/tasks/ready/` for tasks marked with `**Assigned**: ai-agent`
   - Sort by priority (high → medium → low)
   - Check dependencies to ensure they are completed

2. **Start working on a task**:
   - Move the task file from `/tasks/ready/` to `/tasks/started/`
   - Update the task's metadata line:
     - Change `**Status**: ready` to `**Status**: started` 
     - Add `**Started**: YYYY-MM-DD` with today's date

3. **Work on the task**:
   - Follow the implementation plan in the task file
   - Update the task file with progress notes
   - Create or modify necessary code files
   - Run tests specified in the validation plan

4. **Complete a task**:
   - Verify all success criteria are met
   - Document evidence of completion
   - Update the task's metadata line:
     - Change `**Status**: started` to `**Status**: completed`
     - Add `**Completed**: YYYY-MM-DD` with today's date
   - Move the task file from `/tasks/started/` to `/tasks/completed/`
   - Update relevant documentation in `/docs/` if necessary

5. **Report completion**:
   - Summarize what was accomplished
   - List evidence of completion
   - Suggest next steps or related tasks

## Context Understanding

Before working on any task:

1. Review `/docs/architecture.md` to understand the system architecture and project structure
2. Check other documentation in `/docs/components/`
3. Examine completed tasks in `/tasks/completed/` for similar work

## Code Quality Guidelines

When implementing solutions:

1. Follow the project's coding standards
2. Write clean, well-documented code
3. Add appropriate tests
4. Update documentation to reflect changes
5. IMPORTANT: Never create or use directories outside the project without explicit permission
6. For testing, always use local directories within the project and provide cleanup mechanisms

## Communication Format

When reporting progress or completion:

1. Be specific about what was accomplished
2. Reference specific files and line numbers
3. Explain any deviations from the task plan
4. Document any challenges encountered
5. Suggest improvements to the workflow if applicable

Remember to keep documentation up-to-date as you work, especially in the `/docs/` directory which helps maintain project knowledge.

## Git Commit Guidelines

When committing changes:

1. Use clear, descriptive commit messages that explain the purpose of changes
2. Never include AI attribution in commit messages (no "Created by Claude" or similar)
3. Follow the project's commit message format
4. Include only relevant files in your commits
5. Make atomic commits that address a single concern
EOF

# Note: context-map.md has been removed. Project architecture is documented in docs/architecture.md instead

# Create task template
cat << 'EOF' | create_file_with_content "$AGENTIC_DIR/templates/task-template.md"
# Task: [Task Title]

## Objective
[Clear, measurable objective of this task]

## Context
[Relevant background information and links to related resources]

## Success Criteria
- [ ] [Specific, testable outcome 1]
- [ ] [Specific, testable outcome 2]
- [ ] [etc.]

## Dependencies
[Any prerequisite tasks or components]

## Implementation Plan
1. [Step 1]
2. [Step 2]
3. [etc.]

## Validation Plan
- [Test 1 description]
- [Test 2 description]

## Evidence of Completion
(To be filled by AI)
- [ ] Command output or logs demonstrating completion
- [ ] Path to created/modified files
- [ ] Summary of changes made

## Notes
[Any additional information]

## Progress Updates
(To be filled by AI during implementation)
EOF

# Create component documentation template
cat << 'EOF' | create_file_with_content "$AGENTIC_DIR/templates/component-doc.md"
# Component: [Component Name]

## Purpose
[Brief description of the component's purpose]

## Responsibilities
- [Responsibility 1]
- [Responsibility 2]
- [etc.]

## Interfaces
- **Input**: [What data/signals the component receives]
- **Output**: [What data/signals the component produces]

## Dependencies
- [Dependency 1]
- [Dependency 2]

## Design Decisions
- [Design decision 1]
- [Design decision 2]

## Examples
[Usage examples]
EOF

# Create architecture document
cat << 'EOF' | create_file_with_content "$DOCS_DIR/architecture.md"
# System Architecture

This document describes the overall system architecture.

## Overview
[High-level description of the system]

## Components
[List of key components and their relationships]

## Data Flow
[Description of how data flows through the system]

## Deployment Model
[How the system is deployed]

## Technologies
[Key technologies used]
EOF

# Create ADR template if enabled
if [ "$INCLUDE_ADR" = true ]; then
  cat << 'EOF' | create_file_with_content "$DOCS_DIR/decisions/ADR-template.md"
# Decision Record: [Title]

## Status
[Proposed/Accepted/Deprecated/Superseded]

## Context
[Describe the context and problem statement]

## Decision
[Describe the decision that was made]

## Consequences
### Positive
[List positive consequences]

### Negative
[List negative consequences]

## Implementation
[Describe implementation details if applicable]
EOF
fi

# Create a sample task
cat << 'EOF' | create_file_with_content "$TASKS_DIR/backlog/TASK-001-example.md"
# Task: Example Task

## Objective
Create a simple "Hello World" example to verify the project setup.

## Context
This is a sample task to demonstrate the workflow structure.

## Success Criteria
- [ ] Create a simple "Hello World" application
- [ ] Add basic documentation
- [ ] Verify it runs correctly

## Dependencies
None

## Implementation Plan
1. Set up basic project structure
2. Implement "Hello World" functionality
3. Add documentation

## Validation Plan
- Run the application and verify it outputs "Hello World"
- Check that documentation is clear and complete

## Evidence of Completion
(To be filled by AI)
- [ ] Command output or logs showing successful execution
- [ ] Path to created/modified files
- [ ] Link to documentation files

## Notes
This is just an example task to get started.

## Progress Updates
(To be filled by AI during implementation)
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
echo "- To force overwrite of existing files: --force"