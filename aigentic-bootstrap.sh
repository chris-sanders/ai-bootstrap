#!/bin/bash
# AI Agent Development Workflow Bootstrap Script
# This script sets up the aigentic workflow structure in your project
# Usage: ./aigentic-bootstrap.sh [project_directory]

set -e

PROJECT_DIR=${1:-.}
AIGENTIC_DIR="$PROJECT_DIR/.aigentic"
TASKS_DIR="$PROJECT_DIR/tasks"
DOCS_DIR="$PROJECT_DIR/docs"

echo "Setting up AI Agent Development Workflow in $PROJECT_DIR"

# Create directory structure
mkdir -p "$AIGENTIC_DIR/templates"
mkdir -p "$TASKS_DIR/backlog" "$TASKS_DIR/ready" "$TASKS_DIR/started" "$TASKS_DIR/completed"
mkdir -p "$DOCS_DIR/components" "$DOCS_DIR/decisions"

# Create AI readme file
cat > "$AIGENTIC_DIR/ai-readme.md" << 'EOF'
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
   - Update context-map.md if necessary

5. **Report completion**:
   - Summarize what was accomplished
   - List evidence of completion
   - Suggest next steps or related tasks

## Context Understanding

Before working on any task:

1. Review `/.aigentic/context-map.md` to understand the project structure
2. Check related documentation in `/docs/`
3. Examine completed tasks in `/tasks/completed/` for similar work

## Code Quality Guidelines

When implementing solutions:

1. Follow the project's coding standards
2. Write clean, well-documented code
3. Add appropriate tests
4. Update documentation to reflect changes

## Communication Format

When reporting progress or completion:

1. Be specific about what was accomplished
2. Reference specific files and line numbers
3. Explain any deviations from the task plan
4. Document any challenges encountered
5. Suggest improvements to the workflow if applicable

Remember to keep documentation up-to-date as you work, especially the context map which helps maintain project knowledge.
EOF

# Create context map template
cat > "$AIGENTIC_DIR/context-map.md" << 'EOF'
# Project Context Map

## Project Overview
[Brief description of the project purpose and goals]

## Technology Stack
- Language: [Python/Golang/etc.]
- Framework: [If applicable]
- Infrastructure: [Kubernetes, Docker, etc.]

## Repository Structure
- `/.aigentic/` - AI agent configuration and instructions
- `/tasks/` - Development tasks in various stages
- `/docs/` - Project documentation
- [Other important directories]

## Key Components
- [Component 1]: [Purpose/responsibility]
- [Component 2]: [Purpose/responsibility]

## Current Development Focus
[What the team is currently working on]

## References
- [Link to architecture docs]
- [Link to external resources]
EOF

# Create task template
cat > "$AIGENTIC_DIR/templates/task-template.md" << 'EOF'
# Task: [Task Title] [TASK-ID]

> **Status**: ready | **Priority**: [high|medium|low] | **Assigned**: [ai-agent|human-developer]

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
- [ ] [Expected evidence 1]
- [ ] [Expected evidence 2]

## Notes
[Any additional information]

## Progress Updates
(To be filled by AI during implementation)
EOF

# Create component documentation template
cat > "$AIGENTIC_DIR/templates/component-doc.md" << 'EOF'
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
cat > "$DOCS_DIR/architecture.md" << 'EOF'
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

# Create a sample task
cat > "$TASKS_DIR/ready/TASK-001-example.md" << 'EOF'
# Task: Example Task [TASK-001]

> **Status**: ready | **Priority**: medium | **Assigned**: ai-agent | **Tags**: example, documentation

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
- [ ] Screenshot or log showing successful execution
- [ ] Link to documentation files

## Notes
This is just an example task to get started.

## Progress Updates
(To be filled by AI during implementation)
EOF

echo "Workflow initialized successfully!"
echo ""
echo "Next steps:"
echo "1. Customize the context map in $AIGENTIC_DIR/context-map.md"
echo "2. Review the sample task in $TASKS_DIR/ready/TASK-001-example.md"
echo "3. Create additional tasks using the template in $AIGENTIC_DIR/templates/task-template.md"
echo ""
echo "To start working with an AI agent:"
echo "1. Point the AI agent to your project repository"
echo "2. Instruct it to read $AIGENTIC_DIR/ai-readme.md first"
echo "3. The agent will find tasks in the ready folder and begin working"
