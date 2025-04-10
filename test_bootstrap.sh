#!/bin/bash
# Test script for agentic-bootstrap.sh idempotent behavior
# This script validates the idempotent behavior of the bootstrap script
# It verifies that the script:
# - Creates files in an empty directory
# - Doesn't overwrite existing files unless forced
# - Replaces missing files
# - Overwrites existing files when force flag is used
# - Properly handles GitHub MCP integration flags
# Usage: ./test_bootstrap.sh [--no-cleanup]

set -e  # Exit on error

# Parse command line arguments
CLEANUP=true
while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-cleanup)
      CLEANUP=false
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: ./test_bootstrap.sh [--no-cleanup]"
      exit 1
      ;;
  esac
done

# Create a temporary test directory in the local project
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="${SCRIPT_DIR}/test_bootstrap_$(date +%s)"
mkdir -p "$TEST_DIR"
echo "Using test directory: $TEST_DIR"
echo ""

# Define colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test function to validate a specific test case
run_test() {
  local test_name="$1"
  local expected_result="$2"
  local command="$3"
  
  echo -e "${BLUE}Test: $test_name${NC}"
  echo "  Command: $command"
  
  # Run the command and capture output
  local output=$(eval "$command")
  
  # Check if the output contains the expected result
  if echo "$output" | grep -q "$expected_result"; then
    echo -e "  ${GREEN}✓ PASS: Found expected output: '$expected_result'${NC}"
    return 0
  else
    echo -e "  ${RED}✗ FAIL: Expected output '$expected_result' not found${NC}"
    echo "  Actual output: $output"
    return 1
  fi
}

# Test function to verify file existence
check_file_exists() {
  local file_path="$1"
  local expected_exists="$2"
  local message="$3"
  
  if [ "$expected_exists" = true ]; then
    if [ -f "$file_path" ]; then
      echo -e "  ${GREEN}✓ PASS: $message${NC}"
      return 0
    else
      echo -e "  ${RED}✗ FAIL: $message - File doesn't exist: $file_path${NC}"
      return 1
    fi
  else
    if [ ! -f "$file_path" ]; then
      echo -e "  ${GREEN}✓ PASS: $message${NC}"
      return 0
    else
      echo -e "  ${RED}✗ FAIL: $message - File exists but shouldn't: $file_path${NC}"
      return 1
    fi
  fi
}

# Test function to check file content
check_file_content() {
  local file_path="$1"
  local pattern="$2"
  local should_contain="$3"
  local message="$4"
  
  if [ "$should_contain" = true ]; then
    if grep -q "$pattern" "$file_path"; then
      echo -e "  ${GREEN}✓ PASS: $message${NC}"
      return 0
    else
      echo -e "  ${RED}✗ FAIL: $message - Pattern not found: '$pattern'${NC}"
      return 1
    fi
  else
    if ! grep -q "$pattern" "$file_path"; then
      echo -e "  ${GREEN}✓ PASS: $message${NC}"
      return 0
    else
      echo -e "  ${RED}✗ FAIL: $message - Pattern found but shouldn't be: '$pattern'${NC}"
      return 1
    fi
  fi
}

# Copy the bootstrap script to the test directory
cp "$(pwd)/agentic-bootstrap.sh" "$TEST_DIR/"

# Change to the test directory
cd "$TEST_DIR"

echo "=== TEST SUITE: BOOTSTRAP SCRIPT IDEMPOTENT BEHAVIOR ==="
echo ""

# Test 1: Initial run - should create all files with GitHub MCP enabled by default
echo "=== Test Case 1: Initial creation in empty directory with default settings ==="
run_test "Initial creation" "Created:" "./agentic-bootstrap.sh" || exit 1
check_file_exists "./docs/agentic/ai-readme.md" true "AI readme file created" || exit 1
check_file_exists "./docs/agentic/github-mcp-guide.md" true "GitHub MCP guide created (default)" || exit 1
check_file_content "./docs/agentic/ai-readme.md" "Git/GitHub Operations" true "AI readme contains GitHub section" || exit 1
echo ""

# Test 2: Second run - should skip existing files
echo "=== Test Case 2: Skip existing files on second run ==="
run_test "Skip existing" "Skipped:" "./agentic-bootstrap.sh" || exit 1
echo ""

# Test 3: Modify a file and run again - should not overwrite
echo "=== Test Case 3: Don't overwrite modified files ==="
echo "MODIFIED CONTENT" >> "docs/agentic/ai-readme.md"
run_test "Don't overwrite modified file" "Skipped:" "./agentic-bootstrap.sh" || exit 1

# Check if the modification remains
check_file_content "docs/agentic/ai-readme.md" "MODIFIED CONTENT" true "Modification was preserved" || exit 1
echo ""

# Test 4: Remove a file and run again - should recreate it
echo "=== Test Case 4: Recreate deleted files ==="
rm "docs/agentic/templates/task-template.md"
run_test "Recreate deleted file" "Created: ./docs/agentic/templates/task-template.md" "./agentic-bootstrap.sh" || exit 1
echo ""

# Test 5: Force flag should overwrite existing files
echo "=== Test Case 5: Force flag overwrites existing files ==="
echo "MODIFIED CONTENT" >> "docs/agentic/ai-readme.md"
run_test "Force overwrite" "Created: ./docs/agentic/ai-readme.md" "./agentic-bootstrap.sh --force" || exit 1

# Check if the modification was overwritten
check_file_content "docs/agentic/ai-readme.md" "MODIFIED CONTENT" false "File was successfully overwritten with --force flag" || exit 1
echo ""

# Test 6: Without GitHub MCP flag in new directory
echo "=== Test Case 6: Without GitHub MCP flag ==="
TEST_SUBDIR="without_github_mcp_test"
mkdir -p "$TEST_SUBDIR"
cd "$TEST_SUBDIR"
cp "../agentic-bootstrap.sh" .

run_test "Without GitHub MCP" "GitHub MCP workflow integration disabled" "./agentic-bootstrap.sh --without-github-mcp" || exit 1
check_file_exists "./docs/agentic/github-mcp-guide.md" false "GitHub MCP guide not created when disabled" || exit 1
check_file_content "./docs/agentic/ai-readme.md" "Git Commit Guidelines" true "Basic Git section exists" || exit 1
check_file_content "./docs/agentic/ai-readme.md" "Git/GitHub Operations" false "GitHub MCP section not present when disabled" || exit 1
cd ..
echo ""

# Test 7: Toggle GitHub MCP integration with force flag
echo "=== Test Case 7: Toggle GitHub MCP integration with force flag ==="
# 7a: Add GitHub MCP to previously disabled setup
cd "$TEST_SUBDIR"
run_test "Enable GitHub MCP with force" "Created:" "./agentic-bootstrap.sh --force" || exit 1
check_file_exists "./docs/agentic/github-mcp-guide.md" true "GitHub MCP guide created when re-enabled" || exit 1
check_file_content "./docs/agentic/ai-readme.md" "Git/GitHub Operations" true "GitHub MCP section added when re-enabled" || exit 1
cd ..

# 7b: Disable GitHub MCP in default setup
TEST_SUBDIR2="toggle_github_mcp_test"
mkdir -p "$TEST_SUBDIR2"
cd "$TEST_SUBDIR2"
cp "../agentic-bootstrap.sh" .

# First create with default (GitHub MCP enabled)
run_test "Default GitHub MCP enabled" "Including GitHub MCP workflow integration" "./agentic-bootstrap.sh" || exit 1
check_file_exists "./docs/agentic/github-mcp-guide.md" true "GitHub MCP guide exists by default" || exit 1

# Then disable with force
run_test "Disable GitHub MCP with force" "GitHub MCP workflow integration disabled" "./agentic-bootstrap.sh --without-github-mcp --force" || exit 1
check_file_content "./docs/agentic/ai-readme.md" "Git/GitHub Operations" false "GitHub MCP section removed when disabled with force" || exit 1
cd ..
echo ""

echo -e "${GREEN}All tests passed successfully!${NC}"
echo "Test directory: $TEST_DIR"

# Clean up the test directory unless --no-cleanup was specified
if [ "$CLEANUP" = true ]; then
  echo "Cleaning up test directory..."
  rm -rf "$TEST_DIR"
  
  # Verify the cleanup was successful
  if [ -d "$TEST_DIR" ]; then
    echo -e "${RED}ERROR: Failed to remove test directory!${NC}"
    echo "Manual cleanup required: rm -rf $TEST_DIR"
    exit 1
  else
    echo -e "${GREEN}Test directory successfully removed.${NC}"
  fi
else
  echo "Test directory was preserved: $TEST_DIR"
  echo "You can clean it up with: rm -rf $TEST_DIR"
fi