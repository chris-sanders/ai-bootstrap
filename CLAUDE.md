# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
This repository contains the "AI Bootstrap" project, which provides a standardized workflow for AI agents. The main components are:
- A bootstrap script that sets up the workflow in any project
- Documentation templates and task management structure
- Process guidelines for AI agents

## Task Management
- IMPORTANT: Always begin by thoroughly reading `/docs/agentic/ai-readme.md` to understand the complete workflow
- Find tasks in `/tasks/ready/` assigned to AI agents
- Move tasks through the workflow: backlog → ready → started → review → completed
- Update task metadata when changing status (see task template for format)
- Create branches following the naming convention: `task/[task-filename-without-extension]`
- Submit PRs when tasks are completed and move them to the review folder
- When completing tasks, document evidence of completion

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