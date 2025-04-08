# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
This repository contains the "AI Bootstrap" project, which provides a standardized workflow for AI agents. The main components are:
- A bootstrap script that sets up the workflow in any project
- Documentation templates and task management structure
- Process guidelines for AI agents

## Task Management
- Follow the workflow defined in `/docs/agentic/ai-readme.md`
- Find tasks in `/tasks/ready/` assigned to AI agents
- Move tasks through the workflow: backlog → ready → started → completed
- Update task metadata when changing status (see task template for format)
- When completing tasks, document evidence of completion

## Coding Guidelines
- Write clean, well-documented bash scripts
- Use meaningful variable names with snake_case
- Include comments for complex logic
- Error handling: use `set -e` and check return values
- Follow markdown best practices for documentation files
- Use consistent formatting with 2-space indentation in markdown

## Documentation
- Document components in `/docs/components/`
- Keep the architecture document up-to-date as the system evolves
- Follow a consistent format for all markdown files

## Testing
- Test bootstrap script by running it in a test directory
- Validate that all templates are created correctly
- Ensure documentation is clear and consistent