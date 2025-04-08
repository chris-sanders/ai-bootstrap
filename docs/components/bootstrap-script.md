# Component: Bootstrap Script (aigentic-bootstrap.sh)

## Purpose
The bootstrap script initializes the AI agent workflow structure in a target project. It creates the necessary directories and template files to enable a standardized task management process.

## Responsibilities
- Create the directory structure for the AI agent workflow
- Generate template files for task management and documentation
- Provide initial guidance for using the workflow
- Set up an example task to demonstrate the workflow

## Interfaces
- **Input**: Optional project directory path (defaults to current directory)
- **Output**: Directory structure and template files created in the target location

## Dependencies
- Bash shell
- Standard Unix utilities (mkdir, cat, echo)

## Design Decisions
- Self-contained in a single script for easy deployment
- Creates all necessary directories and files in one operation
- Provides helpful output to guide the user on next steps
- Uses here-documents (EOF) to create template files with proper formatting
- Sets `-e` flag to fail fast if any errors occur during execution

## Examples

Basic usage (in current directory):
```bash
./aigentic-bootstrap.sh
```

Specify a target directory:
```bash
./aigentic-bootstrap.sh /path/to/project
```

After running, point AI agents to the .aigentic/ai-readme.md file to get started with the workflow.