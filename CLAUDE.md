# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
This repository contains the "AI Bootstrap" project, which provides a standardized workflow for AI agents. The main components are:
- A bootstrap script that sets up the workflow in any project
- Documentation templates and task management structure
- Process guidelines for AI agents

## Task Management
- IMPORTANT: Always begin by thoroughly reading `/docs/agentic/ai-readme.md` to understand the complete workflow
- IMPORTANT: Tasks MUST only exist in ONE folder at a time. ALWAYS use `git mv` to move tasks between folders, NEVER copy them!
- Update task metadata when changing status (see task template for format)
- Create branches following the naming convention: `task/[task-filename-without-extension]`
- Submit PRs when tasks are completed and move them to the review folder
- When completing tasks, document evidence of completion

### Task Movement Guidelines
- CRITICAL: Tasks must only exist in ONE folder at a time throughout their lifecycle
- When moving a task, always:
  1. Check if the task exists in multiple folders (use `git ls-files tasks/*/*.md | grep <task-name>`)
  2. Keep ONLY the task file in the most advanced stage (backlog → ready → started → review → completed)
  3. Remove any duplicate task files with `git rm` before making other changes
  4. Use `git mv` instead of manual move+delete operations to ensure proper tracking

### Handling Merge Conflicts with Task Files
- If a merge conflict occurs with task files:
  1. Identify which version is in the more advanced stage (e.g., review trumps started)
  2. Keep ONLY the task file in the most advanced stage
  3. Ensure metadata is up-to-date with the latest status
  4. Check for duplicate copies in other task folders and remove them
  5. Commit the resolution with a clear message about resolving task duplication

### PR Cleanup Workflow
- IMPORTANT: After a PR has been merged, ALWAYS switch to the master branch
- Pull latest changes with `git pull` to ensure your local master is up-to-date
- Verify the task only exists in the review folder with `git ls-files tasks/*/*.md | grep <task-name>`
- Update the task file to change status to "completed" and add the completion date
- Move the task file from `/tasks/review/` to `/tasks/completed/` with `git mv`
- Commit these changes to the master branch
- Optionally delete the feature branch if it's no longer needed

## Coding Guidelines
- Write clean, well-documented bash scripts
- Use meaningful variable names with snake_case
- Include comments for complex logic
- Error handling: use `set -e` and check return values
- Follow markdown best practices for documentation files
- Use consistent formatting with 2-space indentation in markdown
- IMPORTANT: Never create or use directories outside the current project without explicit permission
- For testing, always use local directories within the project and provide cleanup mechanisms

## Documentation
- Document components in `/docs/components/`
- Keep the architecture document up-to-date as the system evolves
- Follow a consistent format for all markdown files
- IMPORTANT: After modifying templates or core script, always run the build script to regenerate the distributable file:
  ```bash
  ./scripts/build.sh
  ```
- Always commit the updated `dist/agentic-bootstrap.sh` along with any template or script changes

## Testing
- Test bootstrap script by running it in a test directory
- Validate that all templates are created correctly
- Ensure documentation is clear and consistent
