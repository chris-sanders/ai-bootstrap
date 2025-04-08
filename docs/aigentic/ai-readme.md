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
