# Component: Bootstrap Script (agentic-bootstrap.sh)

## Purpose
The bootstrap script initializes the AI agent workflow structure in a target project. It creates the necessary directories and template files to enable a standardized task management process.

## Responsibilities
- Create the directory structure for the AI agent workflow
- Generate template files for task management and documentation
- Provide initial guidance for using the workflow
- Set up an example task to demonstrate the workflow
- Safely handle existing files (idempotent operation)
- Configure GitHub MCP integration (enabled by default, can be disabled)

## Interfaces
- **Input**: 
  - Optional project directory path (defaults to current directory)
  - Optional flags:
    - `--with-adr`: Include Architecture Decision Records
    - `--without-github-mcp`: Disable GitHub MCP workflow integration (enabled by default)
    - `--force`: Overwrite existing files even if they already exist
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
- Idempotent by default (doesn't overwrite existing files unless forced)
- Uses temporary files to handle heredoc content creation safely
- GitHub MCP integration enabled by default to streamline Git/GitHub workflows
- Uses flag convention with "without" prefix for disabling default features

## Examples

Basic usage (in current directory, with GitHub MCP integration enabled by default):
```bash
./agentic-bootstrap.sh
```

Specify a target directory:
```bash
./agentic-bootstrap.sh /path/to/project
```

Include Architecture Decision Records:
```bash
./agentic-bootstrap.sh --with-adr
```

Without GitHub MCP integration:
```bash
./agentic-bootstrap.sh --without-github-mcp
```

Force overwrite of existing files:
```bash
./agentic-bootstrap.sh --force
```

Combining options:
```bash
./agentic-bootstrap.sh --with-adr --without-github-mcp --force /path/to/project
```

After running, point AI agents to the docs/agentic/ai-readme.md file to get started with the workflow.