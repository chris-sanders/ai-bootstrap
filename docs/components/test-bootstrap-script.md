# Component: Test Bootstrap Script (test_bootstrap.sh)

## Purpose
The test bootstrap script validates the idempotent behavior of the agentic-bootstrap.sh script. It ensures that the bootstrap script correctly handles existing files, recreates missing files, properly implements the --force flag, and correctly manages GitHub MCP integration.

## Responsibilities
- Verify that the bootstrap script creates all expected files when run on an empty directory
- Validate that existing files are not modified during subsequent runs
- Ensure deleted files are recreated when the script is run again
- Verify that the --force flag correctly overwrites existing files
- Test GitHub MCP integration features (enabled by default)
- Validate --without-github-mcp flag works correctly
- Test toggling GitHub MCP integration in existing projects
- Provide clear pass/fail output for each test case

## Interfaces
- **Input**: Optional flag for test behavior
  - `--no-cleanup`: Preserve test files after execution (for debugging)
- **Output**: Test results with colored pass/fail indicators

## Dependencies
- Bash shell
- agentic-bootstrap.sh script
- Standard Unix utilities (grep, mkdir, echo)

## Design Decisions
- Uses a local test directory within the project (not system temp directories)
- Automatically cleans up test files after execution unless --no-cleanup is specified
- Employs color-coded output for better readability of test results
- Tests each success criterion individually in a sequential manner
- Implements early exit on failure to prevent cascading test failures
- Creates subdirectories for testing different configurations simultaneously
- Uses both output message checking and file content verification
- Added specific functions for checking file existence and content patterns

## Examples

Basic usage:
```bash
./test_bootstrap.sh
```

Run without cleaning up test files:
```bash
./test_bootstrap.sh --no-cleanup
```

Example output:
```
=== TEST SUITE: BOOTSTRAP SCRIPT IDEMPOTENT BEHAVIOR ===

=== Test Case 1: Initial creation in empty directory with default settings ===
Test: Initial creation
  Command: ./agentic-bootstrap.sh
  ✓ PASS: Found expected output: 'Created:'
  ✓ PASS: AI readme file created
  ✓ PASS: GitHub MCP guide created (default)
  ✓ PASS: AI readme contains GitHub section

... (other test cases)

All tests passed successfully!
```