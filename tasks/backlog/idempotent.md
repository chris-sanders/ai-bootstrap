# Task: Idempotent bootstrap

## Objective
The bootstrap script should avoid damaging any existing files. Running the script shouldn't change existing files unless a force flag is provided.

## Context
The initial implementation re-running bootstrap will overwrite current files possibly causing the user loss of data.

## Success Criteria
- The bootstrap script generates the expected files for an empty directory same as it does today
- Modifying files and re-running the bootstrap will not change existing files
- Removing files and re-running bootstrap will replace the missing files
- Running bootstrap with a force flag will overwrite existing files replacing their contents

## Dependencies
None

## Implementation Plan
1. Update the bootstrap script with a flag to force
2. Check each file before creation and only overwrite files if force is active
3. Write a simple test script that can be run to perform validation based on the Success Criteria and Validation Plan

## Validation Plan
* Think carefully to ensure testing doesn't inadvertently overwrite files in the repo, perform testing in a test folder
- Perform each of the success criteria one at a time and confirm it works as described
* Run the test script and ensure it properly tests the validation plan and has a clean easy to understand output with clear test cases with pass/fail

## Evidence of Completion
(To be filled by AI)
- [ ] Command output or logs demonstrating completion
* ...

## Notes
None

## Progress Updates
(To be filled by AI during implementation)
