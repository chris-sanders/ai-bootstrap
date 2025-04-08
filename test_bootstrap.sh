#!/bin/bash
# Test script for agentic-bootstrap.sh idempotent behavior
# This script validates the idempotent behavior of the bootstrap script
# It verifies that the script:
# - Creates files in an empty directory
# - Doesn't overwrite existing files unless forced
# - Replaces missing files
# - Overwrites existing files when force flag is used

set -e  # Exit on error

# Create a temporary test directory
TEST_DIR=$(mktemp -d)
echo "Using temporary test directory: $TEST_DIR"
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

# Copy the bootstrap script to the test directory
cp "$(pwd)/agentic-bootstrap.sh" "$TEST_DIR/"

# Change to the test directory
cd "$TEST_DIR"

echo "=== TEST SUITE: BOOTSTRAP SCRIPT IDEMPOTENT BEHAVIOR ==="
echo ""

# Test 1: Initial run - should create all files
echo "=== Test Case 1: Initial creation in empty directory ==="
run_test "Initial creation" "Created:" "./agentic-bootstrap.sh" || exit 1
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
if grep -q "MODIFIED CONTENT" "docs/agentic/ai-readme.md"; then
  echo -e "  ${GREEN}✓ PASS: Modification was preserved${NC}"
else
  echo -e "  ${RED}✗ FAIL: Modification was overwritten${NC}"
  exit 1
fi
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
if grep -q "MODIFIED CONTENT" "docs/agentic/ai-readme.md"; then
  echo -e "  ${RED}✗ FAIL: Modified content was not overwritten with --force flag${NC}"
  exit 1
else
  echo -e "  ${GREEN}✓ PASS: File was successfully overwritten with --force flag${NC}"
fi

echo ""
echo -e "${GREEN}All tests passed successfully!${NC}"
echo "Temporary directory: $TEST_DIR"
echo "You can clean it up with: rm -rf $TEST_DIR"