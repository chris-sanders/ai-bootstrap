
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