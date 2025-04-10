#!/bin/bash
# Version: 1.0.0
# Generated: 2025-04-10 23:53:17 UTC
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

# Helper function to check if file exists and should be created
should_create_file() {
  local file_path="$1"
  
  if [ ! -f "$file_path" ] || [ "$FORCE" = true ]; then
    return 0  # True - should create
  else
    return 1  # False - should skip
  fi
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

# Create AI readme file based on GitHub MCP flag
if [ "$INCLUDE_GITHUB_MCP" = true ]; then
  # Create AI readme with GitHub MCP content
  README_PATH="$AGENTIC_DIR/ai-readme.md"
  if should_create_file "$README_PATH"; then
    cat > "$README_PATH" << 'ENDOFFILE'
# AI Agent Instructions

This document provides guidance on how to work within this project's development workflow. Follow these instructions to effectively contribute to the project.

## Task Management Workflow

As an AI agent, you should:

1. **Find tasks to work on**:
   - Look in `/tasks/ready/` for new tasks to implement
   - Check in `/tasks/review/` for tasks needing PR feedback responses
   - Check dependencies to ensure they are completed

2. **Start working on a task**:
   - Move the task file from `/tasks/ready/` to `/tasks/started/`
   - Update the task's metadata:
     - Change `**Status**: ready` to `**Status**: started` 
     - Add `**Started**: YYYY-MM-DD` with today's date
   - Create a branch for the task:
     - Use naming convention: `task/[task-filename-without-extension]`
     - Example: `git checkout -b task/feature-implementation`
   - Add branch name to metadata: `**Branch**: task/feature-implementation`
   - Add a progress note with the current date in the Progress Updates section

3. **Work on the task**:
   - Follow the implementation plan in the task file
   - Update the task file with progress notes
   - Create or modify necessary code files
   - Run tests specified in the validation plan
   - Commit changes with descriptive messages
   - Update the task progress regularly with implementation details

4. **Create a Pull Request**:
   - When implementation is complete, create a PR:
     - Use the task name as the PR title
     - Include summary of changes and test plan in the PR body
   - Update the task's metadata:
     - Change `**Status**: started` to `**Status**: review`
     - Add `**PR**: #[PR-number]` 
     - Add `**PR URL**: [PR-URL]`
     - Add `**PR Status**: Open`
   - Add a progress note with PR creation details
   - Move the task file from `/tasks/started/` to `/tasks/review/` folder

5. **Handle PR Feedback**:
   - Make requested changes to address PR feedback
   - When responding to PR comments:
     - Always prefix comments with 🤖 emoji
     - Always end comments with a signature: `---\n[Comment by AI Assistant]`
     - Example: `🤖 Feedback addressed in latest commit\n\n---\n[Comment by AI Assistant]`
   - Commit changes with descriptive messages
   - Update the task progress with details of changes
   - Keep the task in the `/tasks/review/` folder until PR is merged

6. **Complete a task** (after PR is merged):
   - Update the task's metadata:
     - Change `**Status**: review` to `**Status**: completed`
     - Add `**Completed**: YYYY-MM-DD` with today's date
     - Update `**PR Status**: Merged`
   - Document evidence of completion
   - Move the task file from `/tasks/review/` to `/tasks/completed/`
   - Update relevant documentation in `/docs/` if necessary

7. **Report completion**:
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

## Git/GitHub Operations

When working with Git and GitHub:

1. **Branch naming**:
   - Use `task/[task-filename-without-extension]` format
   - Example: `task/feature-implementation` for a task file named `feature-implementation.md`

2. **Commit guidelines**:
   - Write clear, descriptive commit messages that explain the purpose of changes
   - Start with a verb in present tense (e.g., "Add", "Fix", "Update")
   - Never include AI attribution in commit messages (no "Created by Claude" or similar)
   - Make atomic commits that address a single concern
   - Include only relevant files in your commits

3. **Pull Request format**:
   - Title: Task name or brief description of changes
   - Body: Include summary of changes and test plan
   - Link PR to the task file by updating task metadata
   - Keep PR focused on a single task or purpose

4. **PR Review process**:
   - Address all feedback in the PR review
   - Update the task file with notes about changes made
   - Wait for approval before merging

5. **Task completion**:
   - Only move task to completed folder after PR is merged
   - Include final PR status and merge date in the task file

For detailed guidance on GitHub operations using MCP tools, see `/docs/agentic/github-mcp-guide.md`.
ENDOFFILE
    echo "Created: $README_PATH"
  else
    echo "Skipped: $README_PATH (already exists, use --force to overwrite)"
  fi
  
  # Create GitHub MCP guide
  MCP_GUIDE_PATH="$AGENTIC_DIR/github-mcp-guide.md"
  if should_create_file "$MCP_GUIDE_PATH"; then
    cat > "$MCP_GUIDE_PATH" << 'ENDOFFILE'
# GitHub MCP Operations Guide

This document provides guidance on how to use GitHub MCP (Model Capability Provider) tools for Git and GitHub operations as part of the AI workflow.

## Prerequisites

- Claude Code must be configured with GitHub MCP access at the user level
- The repository must be a valid git repository

## Branch Management

### Creating a New Branch

When starting a task, create a branch using the following naming convention:

```
task/[task-filename-without-extension]
```

Example for a task file named `feature-implementation.md`:

```
git checkout -b task/feature-implementation
```

### Working with Branches

Basic branch operations:

```bash
# Check current branch
git branch

# Switch to another branch
git checkout [branch-name]

# Create and switch to a new branch
git checkout -b [branch-name]
```

## Making Changes

### Staging Changes

```bash
# Stage specific files
git add [file-path]

# Stage all changes
git add .

# Check what's staged
git status
```

### Committing Changes

```bash
# Commit staged changes with a message
git commit -m "Descriptive message about changes"

# Commit all tracked files with a message
git commit -am "Descriptive message about changes"
```

### Good Commit Messages

- Be descriptive but concise
- Focus on "why" rather than "what" when possible
- Start with a verb in present tense (e.g., "Add", "Fix", "Update")
- Do not include AI attribution (no "Created by Claude" or similar)

## Pull Requests

### Creating a Pull Request

After pushing your branch, create a pull request using the MCP tools:

```
# Format
mcp__github__create_pull_request:
  owner: [repository-owner]
  repo: [repository-name]
  title: "Implement [task-name]"
  head: [branch-name]
  base: master
  body: "PR description with summary and test plan"
```

### PR Description Template

```
## Summary
- Brief summary of changes
- Purpose of the changes

## Test Plan
- Steps to test the changes
- Expected results
```

### Updating Task with PR Information

After creating a PR, update the task file metadata and move it to the review folder:

```
**Status**: review
**PR**: #[PR-number]
**PR URL**: [PR-URL]
**PR Status**: Open
```

### Handling PR Feedback

When receiving PR feedback:

1. Make requested changes
2. Commit with a descriptive message
3. Update the task progress section with:
   ```
   [Date]: Updated PR with requested changes: [summary of changes]
   ```

## Merging Process

When a PR is approved and ready to merge:

```
# Format
mcp__github__merge_pull_request:
  owner: [repository-owner]
  repo: [repository-name]
  pullNumber: [PR-number]
  merge_method: "squash"  # or "merge" or "rebase"
```

After merging:
1. Update the task file with `**PR Status**: Merged`
2. Move the task from `review` to `completed` folder
3. Update the task status to `completed` with completion date

## Review Workflows

### Adding PR Comments

Always include AI attribution in comments to distinguish between human and AI responses:

```
# Format
mcp__github__create_pull_request_review:
  owner: [repository-owner]
  repo: [repository-name]
  pullNumber: [PR-number]
  event: "COMMENT"  # or "APPROVE" or "REQUEST_CHANGES"
  body: "🤖 Comment text\n\n---\n[Comment by AI Assistant]"
```

### Comment Attribution Format

All AI-generated comments must follow this format:
1. Start with 🤖 emoji to visually flag AI-generated content
2. End with a signature block after a horizontal rule

Example:
```
🤖 [Comment content here]

---
[Comment by AI Assistant]
```

### Approving a PR

```
# Format
mcp__github__create_pull_request_review:
  owner: [repository-owner]
  repo: [repository-name]
  pullNumber: [PR-number]
  event: "APPROVE"
  body: "🤖 Approval comment\n\n---\n[Comment by AI Assistant]"
```

## Important Notes

- MCP tool configuration is handled at the user level in Claude Code, not at the project level
- This guide only covers workflow instructions for GitHub operations
- When the GitHub workflow is enabled, creating PRs is a standard part of task completion
- Task workflow: backlog → ready → started → review → completed
- Tasks move from "started" to "review" folder when PR is created
- Tasks move from "review" to "completed" after PR is merged
ENDOFFILE
    echo "Created: $MCP_GUIDE_PATH"
  else
    echo "Skipped: $MCP_GUIDE_PATH (already exists, use --force to overwrite)"
  fi
else
  # Create AI readme without GitHub MCP content
  README_PATH="$AGENTIC_DIR/ai-readme.md"
  if should_create_file "$README_PATH"; then
    cat > "$README_PATH" << 'ENDOFFILE'
# AI Agent Instructions

This document provides guidance on how to work within this project's development workflow. Follow these instructions to effectively contribute to the project.

## Task Management Workflow

As an AI agent, you should:

1. **Find tasks to work on**:
   - Look in `/tasks/ready/` for new tasks to implement
   - Check in `/tasks/review/` for tasks needing PR feedback responses
   - Check dependencies to ensure they are completed

2. **Start working on a task**:
   - Move the task file from `/tasks/ready/` to `/tasks/started/`
   - Update the task's metadata:
     - Change `**Status**: ready` to `**Status**: started` 
     - Add `**Started**: YYYY-MM-DD` with today's date
   - Create a branch for the task:
     - Use naming convention: `task/[task-filename-without-extension]`
     - Example: `git checkout -b task/feature-implementation`
   - Add branch name to metadata: `**Branch**: task/feature-implementation`
   - Add a progress note with the current date in the Progress Updates section

3. **Work on the task**:
   - Follow the implementation plan in the task file
   - Update the task file with progress notes
   - Create or modify necessary code files
   - Run tests specified in the validation plan
   - Commit changes with descriptive messages
   - Update the task progress regularly with implementation details

4. **Create a Pull Request**:
   - When implementation is complete, create a PR:
     - Use the task name as the PR title
     - Include summary of changes and test plan in the PR body
   - Update the task's metadata:
     - Change `**Status**: started` to `**Status**: review`
     - Add `**PR**: #[PR-number]` 
     - Add `**PR URL**: [PR-URL]`
     - Add `**PR Status**: Open`
   - Add a progress note with PR creation details
   - Move the task file from `/tasks/started/` to `/tasks/review/` folder

5. **Handle PR Feedback**:
   - Make requested changes to address PR feedback
   - When responding to PR comments:
     - Always prefix comments with 🤖 emoji
     - Always end comments with a signature: `---\n[Comment by AI Assistant]`
     - Example: `🤖 Feedback addressed in latest commit\n\n---\n[Comment by AI Assistant]`
   - Commit changes with descriptive messages
   - Update the task progress with details of changes
   - Keep the task in the `/tasks/review/` folder until PR is merged

6. **Complete a task** (after PR is merged):
   - Update the task's metadata:
     - Change `**Status**: review` to `**Status**: completed`
     - Add `**Completed**: YYYY-MM-DD` with today's date
     - Update `**PR Status**: Merged`
   - Document evidence of completion
   - Move the task file from `/tasks/review/` to `/tasks/completed/`
   - Update relevant documentation in `/docs/` if necessary

7. **Report completion**:
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
ENDOFFILE
    echo "Created: $README_PATH"
  else
    echo "Skipped: $README_PATH (already exists, use --force to overwrite)"
  fi
fi

# Create task template
TASK_TEMPLATE_PATH="$AGENTIC_DIR/templates/task-template.md"
if should_create_file "$TASK_TEMPLATE_PATH"; then
  cat > "$TASK_TEMPLATE_PATH" << 'ENDOFFILE'
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
ENDOFFILE
  echo "Created: $TASK_TEMPLATE_PATH"
else
  echo "Skipped: $TASK_TEMPLATE_PATH (already exists, use --force to overwrite)"
fi

# Create component documentation template
COMPONENT_DOC_PATH="$AGENTIC_DIR/templates/component-doc.md"
if should_create_file "$COMPONENT_DOC_PATH"; then
  cat > "$COMPONENT_DOC_PATH" << 'ENDOFFILE'
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
ENDOFFILE
  echo "Created: $COMPONENT_DOC_PATH"
else
  echo "Skipped: $COMPONENT_DOC_PATH (already exists, use --force to overwrite)"
fi

# Create architecture document
ARCHITECTURE_PATH="$DOCS_DIR/architecture.md"
if should_create_file "$ARCHITECTURE_PATH"; then
  cat > "$ARCHITECTURE_PATH" << 'ENDOFFILE'
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
ENDOFFILE
  echo "Created: $ARCHITECTURE_PATH"
else
  echo "Skipped: $ARCHITECTURE_PATH (already exists, use --force to overwrite)"
fi

# Create ADR template if enabled
if [ "$INCLUDE_ADR" = true ]; then
  ADR_TEMPLATE_PATH="$DOCS_DIR/decisions/ADR-template.md"
  if should_create_file "$ADR_TEMPLATE_PATH"; then
    cat > "$ADR_TEMPLATE_PATH" << 'ENDOFFILE'
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
ENDOFFILE
    echo "Created: $ADR_TEMPLATE_PATH"
  else
    echo "Skipped: $ADR_TEMPLATE_PATH (already exists, use --force to overwrite)"
  fi
fi

# Create a sample task
EXAMPLE_TASK_PATH="$TASKS_DIR/backlog/TASK-001-example.md"
if should_create_file "$EXAMPLE_TASK_PATH"; then
  cat > "$EXAMPLE_TASK_PATH" << 'ENDOFFILE'
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
ENDOFFILE
  echo "Created: $EXAMPLE_TASK_PATH"
else
  echo "Skipped: $EXAMPLE_TASK_PATH (already exists, use --force to overwrite)"
fi

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
