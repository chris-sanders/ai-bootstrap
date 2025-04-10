# Task: GitHub MCP Integration Implementation

**Status**: started
**Started**: 2025-04-10
**Branch**: task/github-mcp-integration
**PR**: #1
**PR URL**: https://github.com/chris-sanders/ai-bootstrap/pull/1
**PR Status**: Open

## Objective
Enhance the AI Bootstrap workflow to incorporate GitHub MCP functionality by default, enabling AI agents to perform Git/GitHub operations as part of the task lifecycle and creating a seamless transition from task completion to code review.

## Context
The current AI Bootstrap workflow manages tasks through file movement but lacks integration with Git/GitHub operations via the MCP (Model Capability Provider) interface. Adding GitHub MCP support would create a more comprehensive workflow that extends from task management to code review.

AI agents are capable of performing Git/GitHub operations through MCP tools, but need structured guidelines and documentation to follow a consistent process. The MCP tool configuration itself is handled at the user level in Claude Code, not at the project level.

## Success Criteria
- [x] Documentation updated with MCP GitHub operations guidelines
- [x] AI workflow extended to include GitHub operations by default
- [x] Bootstrap script enhanced with GitHub MCP flag (enabled by default, with option to disable)
- [x] This task itself used as a validation test for the GitHub MCP workflow
- [x] Branch created and PR submitted as part of completing this task

## Dependencies
None

## Implementation Plan
### Phase 1: Documentation and Workflow Integration
1. Update AI agent instructions:
   - Extend `/docs/agentic/ai-readme.md` with a new section on GitHub operations using MCP
   - Define PR creation as a standard part of the workflow when GitHub integration is enabled
   - Include clear guidelines for branch naming conventions (based on task filenames)
   - Document requirement to update task files with PR information once created
   - Document how to track PR review progress within task update sections
   - Clarify task status workflow:
     * Tasks remain in "started" folder while PRs are under review
     * Tasks include PR status in metadata with branch name and PR number
     * Tasks only move to "completed" after PR is merged

2. Create MCP GitHub operations guide:
   - Add `/docs/agentic/github-mcp-guide.md` with specific MCP command formats
   - Include command templates for creating branches, committing code changes, creating pull requests, and responding to review comments
   - Clearly state that MCP tool configuration is handled at the user level in Claude Code, not at the project level

3. Update task metadata format:
   - Add fields for tracking GitHub artifacts (branch name, PR number, PR status)
   - Update progress updates section format to include GitHub status transitions
   - Define standard format for branch names (e.g., `task/github-mcp-integration`)

### Phase 2: Bootstrap Script Enhancement
1. Modify bootstrap script for GitHub MCP integration:
   - Enable GitHub MCP workflow by default
   - Add `--without-github-mcp` flag to `agentic-bootstrap.sh` to disable GitHub integration when needed
   - Maintain idempotent behavior - adding/removing the flag in subsequent runs won't modify existing files unless `--force` is also used
   - Modify the help text to explain this feature and the need for `--force` to update existing files
   - Ensure bootstrap script only configures workflow instructions, not MCP server configuration

### Phase 3: Testing and Validation
1. Use this task as its own test case:
   - Implement the GitHub MCP integration as defined in the plan
   - Create a branch following the naming convention defined in the documentation
   - Make required changes to implement the task
   - Create a PR and update this task's metadata
   - This self-referential approach validates the workflow in a real scenario

## Validation Plan
- Test bootstrap script with default settings:
  - Verify it creates the GitHub MCP guide document
  - Verify it updates the AI agent instructions with GitHub operations
  - Confirm idempotent behavior (doesn't overwrite existing files without --force)

- Test bootstrap script with --without-github-mcp flag:
  - Verify it doesn't include GitHub MCP documentation and workflow sections

- Test the GitHub MCP integration using this task:
  - Create branch for this task following naming convention
  - Make required implementation changes
  - Create PR and update task metadata
  - Verify task can remain in "started" folder during PR review
  - Verify task file is updated with PR information

- Test with both new and existing projects:
  - Verify the GitHub MCP integration works when bootstrapping a new project
  - Verify adding or removing GitHub MCP support to an existing project works correctly with the --force flag

## Evidence of Completion
- [x] Command output or logs demonstrating completion: All tests pass successfully with the updated test script
- [x] Path to created/modified files:
  - Added `/docs/agentic/github-mcp-guide.md` with GitHub MCP operations documentation
  - Updated `/docs/agentic/ai-readme.md` with GitHub operations workflow
  - Modified `agentic-bootstrap.sh` to add GitHub MCP integration by default
  - Updated `test_bootstrap.sh` to test GitHub MCP integration features
  - Updated `docs/components/bootstrap-script.md` to document the new feature
  - Updated `docs/components/test-bootstrap-script.md` to reflect the enhanced tests
- [x] Summary of changes made:
  1. Created comprehensive GitHub MCP operations guide with command templates
  2. Updated AI agent instructions with Git/GitHub workflow procedures
  3. Added GitHub MCP integration to bootstrap script (enabled by default)
  4. Implemented `--without-github-mcp` flag to disable GitHub integration
  5. Enhanced test script with additional tests for GitHub MCP features
  6. Updated documentation to reflect all changes
  7. Maintained idempotent behavior with the new features
  8. Updated bootstrap script help text with new flag details
- [x] Branch name created for this task: `task/github-mcp-integration`
- [x] PR number and URL for this task: [PR #1](https://github.com/chris-sanders/ai-bootstrap/pull/1)

## Notes
- This task only configures workflow instructions for GitHub MCP, it does not configure the Claude Code MCP server itself, as that's handled at the user level.
- The flag follows the same convention as the existing `--with-adr` flag, but inverse logic as it disables a feature that's on by default.
- For Phase 4 (Future Work), a placeholder task for GitHub issues integration should be created in `/tasks/backlog/` after this task is completed, but is not part of this immediate implementation.
- Task status flow: Tasks stay in "started" folder until PR is merged, even after implementation is complete. This ensures AI agents can find and continue work on tasks with open PRs by looking in the "started" folder.

## Progress Updates
2025-04-10: Started working on the task. Created branch `task/github-mcp-integration` and moved task to started folder.
2025-04-10: Implemented GitHub MCP documentation. Created `/docs/agentic/github-mcp-guide.md` with comprehensive guide for Git/GitHub operations.
2025-04-10: Updated AI agent instructions in `/docs/agentic/ai-readme.md` with GitHub workflow procedures.
2025-04-10: Modified bootstrap script to enable GitHub MCP by default and added `--without-github-mcp` flag.
2025-04-10: Enhanced test script to verify GitHub MCP integration features with additional test cases.
2025-04-10: Updated component documentation for both bootstrap script and test script.
2025-04-10: Ran tests successfully, verifying all GitHub MCP integration features work as expected.
2025-04-10: Added explicit guidance about using existing test scripts rather than manual testing.
2025-04-10: Created PR #1 for the task using MCP tools as documented in the guide.