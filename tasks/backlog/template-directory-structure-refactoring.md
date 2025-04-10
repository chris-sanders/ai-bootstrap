# Task: Template Directory Structure Refactoring

**Status**: backlog

## Objective
Refactor the AI Bootstrap project structure to separate templates from the bootstrap script logic, implementing a build process that combines them into a single distributable script, while maintaining the simplicity of curl-pipe-bash installation.

## Context
The current implementation uses a single large bash script with templates embedded as heredocs. This approach makes PR reviews difficult, especially when adding new features that require duplicated template content with minor variations. The goal is to make template management and PR reviews easier while preserving the user-friendly installation experience.

The proposed solution is to adopt a "Template Directory with Build Script" approach where:
1. Templates are stored in separate files outside the script logic
2. A build script combines templates with core logic to generate the final distributable script
3. Users still install with `curl | bash` using the generated script
4. PR reviews can focus on actual template changes rather than duplicated content

## Success Criteria
- [ ] Project restructured with separate template directory and core script logic
- [ ] Build script created to generate the distributable bootstrap script
- [ ] Generated script maintains all current functionality including:
  - [ ] Basic bootstrap functionality
  - [ ] Idempotent behavior
  - [ ] GitHub MCP integration (configurable)
  - [ ] ADR support (configurable)
- [ ] PR reviews are simplified with template changes isolated from script logic
- [ ] User installation experience remains unchanged (curl-pipe-bash still works)
- [ ] Automated tests verify the generated script functionality matches original script
- [ ] Documentation updated to reflect the new development workflow

## Dependencies
- Existing idempotent bootstrap script
- Existing test infrastructure

## Implementation Plan

### Phase 1: Project Structure and Refactoring
1. Create new directory structure:
   ```
   /templates/
     base/          # Base templates shared across all configurations
       ai-readme-base.md
       task-template.md
       component-doc.md
       architecture.md
     features/      # Feature-specific templates
       github-mcp/
         github-mcp-guide.md
         ai-readme-github-extension.md
       adr/
         adr-template.md
   /src/
     bootstrap-core.sh   # Core logic only
   /scripts/
     build.sh           # Combines templates and core logic
   /dist/
     agentic-bootstrap.sh  # Generated final script
   ```

2. Extract core logic from current bootstrap script:
   - Move argument parsing and helper functions to bootstrap-core.sh
   - Keep the flow control and directory creation logic
   - Replace heredoc sections with template insertion placeholders

3. Extract templates from current bootstrap script:
   - Move all heredoc template content to appropriate files in the templates directory
   - Split templates with conditional content (like ai-readme.md) into base and extension parts

### Phase 2: Build Script Implementation
1. Create build script (scripts/build.sh) to:
   - Process command line arguments for configuration options
   - Combine core script with templates based on configuration
   - Output the final script to dist/agentic-bootstrap.sh
   - Set executable permissions on the generated script

2. Implement template combination logic:
   - For base templates, simply include them in the appropriate locations
   - For conditional templates, include them based on build configuration
   - Ensure generated heredocs are properly formatted and escaped
   - Add build timestamp and version information to the generated script

3. Update the distribution mechanism:
   - Ensure the generated script in dist/ is the one that gets committed
   - Document that developers should not edit the generated script directly

### Phase 3: Testing Infrastructure Update
1. Modify test_bootstrap.sh to:
   - Test the generated script rather than the original
   - Add verification that the build process produces a valid script
   - Ensure all existing tests pass with the generated script

2. Add specific tests for the build process:
   - Test various build configurations
   - Verify correct template inclusion based on configuration
   - Test for script syntax errors in the generated output

3. Create a development test mode:
   - Allow testing without committing the generated script
   - Add comparison between current and newly generated script

### Phase 4: Documentation and Workflow Updates
1. Update documentation:
   - Create a new component document for the build script
   - Update the bootstrap script component documentation
   - Add developer workflow documentation for how to modify templates

2. Update CI/CD workflow (if applicable):
   - Add build step before testing
   - Add verification that the committed script matches the built script

### Phase 5: Migration and Implementation
1. Implement changes incrementally:
   - First, extract core script logic
   - Then, extract templates
   - Next, implement build script
   - Finally, update testing infrastructure

2. Create initial generated script:
   - Run build script with default configuration
   - Verify the generated script is functionally identical to original

3. Update repository with all changes:
   - Commit new directory structure
   - Commit extracted templates and core logic
   - Commit build script
   - Commit generated script
   - Update documentation

## Validation Plan
- Test the original bootstrap script and capture its behavior:
  - Run with various flag combinations
  - Save output for comparison

- Test the build script for correct generation:
  - Run with different configuration options
  - Verify templates are correctly included
  - Check for syntax errors in generated script

- Test the generated bootstrap script's behavior:
  - Run comprehensive test suite (test_bootstrap.sh)
  - Verify all current features still work
  - Compare output with original script

- Test installation process:
  - Verify curl-pipe-bash still works with the generated script
  - Test on different platforms

- Regression test with existing tests:
  - Run all existing tests against the generated script
  - Ensure no functionality is lost
  - Verify idempotent behavior

- Run before/after PR review simulation:
  - Make sample template changes
  - Generate PRs for both approaches
  - Compare diff readability

## Evidence of Completion
(To be filled by AI)
- [ ] Command output or logs demonstrating completion
- [ ] Path to created/modified files
- [ ] Summary of changes made

## Notes
This refactoring is a significant change to the project structure and development workflow, but should be transparent to end-users. The key is maintaining the simplicity of installation while improving maintainability for developers.

Risk mitigation:
1. Implement changes incrementally and test thoroughly at each step
2. Keep the original script functional until the new approach is fully validated
3. Consider a phased rollout with the ability to revert if issues arise
4. Add extensive comments in the code to explain the new structure

## Progress Updates
(To be filled by AI during implementation)