#!/bin/bash
# Test script for agentic-bootstrap.sh with template directory structure
# This script validates the build process and the generated script behavior
# It verifies that:
# - Build script combines templates and core logic correctly
# - Force and GitHub MCP flags work as expected in the generated script
# - All template features are correctly implemented
# Usage: ./test_bootstrap.sh [--no-cleanup]

set -e  # Exit on error

# Cleanup any leftover test directories from failed runs
find "$(dirname "$0")" -maxdepth 1 -name "test_bootstrap_*" -type d -exec rm -rf {} \; 2>/dev/null || true

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
      echo "Usage: ./test_bootstrap_update.sh [--no-cleanup]"
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

# Test function to run tests
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
cp "$(pwd)/dist/agentic-bootstrap.sh" "$TEST_DIR/"

# Change to the test directory
cd "$TEST_DIR"

echo "=== TEST SUITE: GENERATED BOOTSTRAP SCRIPT BEHAVIOR ==="
echo ""

# Test 1: Initial run - should create all files with GitHub MCP enabled by default
echo "=== Test Case 1: Initial creation in empty directory with default settings ==="
mkdir -p test_case_1
cd test_case_1
run_test "Initial creation" "Created:" "../agentic-bootstrap.sh" || exit 1
check_file_exists "./docs/agentic/ai-readme.md" true "AI readme file created" || exit 1
check_file_exists "./docs/agentic/github-mcp-guide.md" true "GitHub MCP guide created (default)" || exit 1
check_file_content "./docs/agentic/ai-readme.md" "Git/GitHub Operations" true "AI readme contains GitHub section" || exit 1
check_file_content "./docs/agentic/ai-readme.md" "tasks/review" true "AI readme includes review folder in workflow" || exit 1
check_file_content "./docs/agentic/github-mcp-guide.md" "Comment Attribution Format" true "GitHub MCP guide includes comment attribution section" || exit 1
cd ..
echo ""

# Test 2: Without GitHub MCP flag
echo "=== Test Case 2: Without GitHub MCP flag ==="
mkdir -p test_case_2
cd test_case_2
run_test "Without GitHub MCP" "GitHub MCP workflow integration disabled" "../agentic-bootstrap.sh --without-github-mcp" || exit 1
check_file_exists "./docs/agentic/github-mcp-guide.md" false "GitHub MCP guide not created when disabled" || exit 1
check_file_content "./docs/agentic/ai-readme.md" "Git Commit Guidelines" true "Basic Git section exists" || exit 1
check_file_content "./docs/agentic/ai-readme.md" "Git/GitHub Operations" false "GitHub MCP section not present when disabled" || exit 1
cd ..
echo ""

# Test 3: With ADR flag
echo "=== Test Case 3: With ADR flag ==="
mkdir -p test_case_3
cd test_case_3
run_test "With ADR" "Including ADR documentation" "../agentic-bootstrap.sh --with-adr" || exit 1
check_file_exists "./docs/decisions/ADR-template.md" true "ADR template created when ADR enabled" || exit 1
cd ..
echo ""

# Test 4: Force flag
echo "=== Test Case 4: Force flag overwrites existing files ==="
mkdir -p test_case_4
cd test_case_4
# First run to create files
run_test "Initial creation" "Created:" "../agentic-bootstrap.sh" || exit 1
# Modify a file
echo "MODIFIED CONTENT" >> "docs/agentic/ai-readme.md"
check_file_content "docs/agentic/ai-readme.md" "MODIFIED CONTENT" true "File was modified" || exit 1
# Run with force flag
run_test "Force overwrite" "Created: ./docs/agentic/ai-readme.md" "../agentic-bootstrap.sh --force" || exit 1
# Check if the file was overwritten
check_file_content "docs/agentic/ai-readme.md" "MODIFIED CONTENT" false "File was overwritten with --force" || exit 1
cd ..
echo ""

# Test 5: Idempotent behavior
echo "=== Test Case 5: Idempotent behavior (skips existing files) ==="
mkdir -p test_case_5
cd test_case_5
# First run to create files
run_test "Initial creation" "Created:" "../agentic-bootstrap.sh" || exit 1
# Second run should skip existing files
run_test "Skip existing" "Skipped:" "../agentic-bootstrap.sh" || exit 1
cd ..
echo ""

# Test 6: Toggle GitHub MCP integration with force flag
echo "=== Test Case 6: Toggle GitHub MCP integration with force flag ==="
mkdir -p test_case_6
cd test_case_6
# First create with GitHub MCP disabled
run_test "Disable GitHub MCP" "GitHub MCP workflow integration disabled" "../agentic-bootstrap.sh --without-github-mcp" || exit 1
check_file_exists "./docs/agentic/github-mcp-guide.md" false "GitHub MCP guide not created" || exit 1
# Then enable with force
run_test "Enable GitHub MCP with force" "Including GitHub MCP workflow integration" "../agentic-bootstrap.sh --force" || exit 1
check_file_exists "./docs/agentic/github-mcp-guide.md" true "GitHub MCP guide created when enabled" || exit 1
check_file_content "./docs/agentic/ai-readme.md" "Git/GitHub Operations" true "GitHub MCP section added when enabled" || exit 1
cd ..
echo ""

# Test the build script
echo "=== TESTING BUILD SCRIPT ==="
cd "$SCRIPT_DIR"
run_test "Build script" "Successfully built" "./scripts/build.sh" || exit 1

echo -e "${GREEN}All tests passed successfully!${NC}"
echo "Test directory: $TEST_DIR"

# Ensure proper cleanup on EXIT
cleanup() {
  if [ "$CLEANUP" = true ] && [ -d "$TEST_DIR" ]; then
    echo "Cleaning up test directory..."
    rm -rf "$TEST_DIR"
    if [ ! -d "$TEST_DIR" ]; then
      echo -e "${GREEN}Test directory successfully removed.${NC}"
    else
      echo -e "${RED}ERROR: Failed to remove test directory!${NC}"
      echo "Manual cleanup required: rm -rf $TEST_DIR"
      exit 1
    fi
  elif [ "$CLEANUP" = false ]; then
    echo "Test directory was preserved: $TEST_DIR"
    echo "You can clean it up with: rm -rf $TEST_DIR"
  fi
}

# Register cleanup handler
trap cleanup EXIT