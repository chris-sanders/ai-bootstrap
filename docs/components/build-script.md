# Component: Build Script (scripts/build.sh)

## Purpose
The build script combines the core bootstrap script logic with templates to generate a distributable bootstrap script. It enables separate maintenance of templates and script logic while preserving the simple installation experience.

## Responsibilities
- Combine core bootstrap script logic with templates
- Handle conditional inclusion of templates based on configuration
- Create the final distributable script in the dist/ directory
- Make the generated script executable
- Support verbose output for debugging purposes
- Add version and timestamp information to the generated script

## Interfaces
- **Input**: 
  - Source files from src/ and templates/ directories
  - Optional flags:
    - `--verbose`: Enable detailed output during the build process
- **Output**: 
  - Generated bootstrap script in dist/agentic-bootstrap.sh

## Dependencies
- Bash shell
- Standard Unix utilities (sed, cat, cp)
- Core bootstrap script (src/bootstrap-core.sh)
- Template files in templates/ directory

## Design Decisions
- Templates are stored in separate directories based on feature type:
  - templates/base/ for common templates
  - templates/features/ for feature-specific templates
- Uses temporary files to safely handle content manipulation
- Supports conditional template inclusion based on build flags
- Preserves heredoc format for the final script
- Maintains the same file structure and command-line arguments as the original script
- Uses template insertion points in the core script to mark where templates should be inserted
- Escapes special characters in templates to ensure proper sed replacement
- Adds version and build timestamp to the generated script for tracking
- Script location (dist/agentic-bootstrap.sh) is fixed to ensure predictable usage

## Examples

Basic build:
```bash
./scripts/build.sh
```

Build with verbose output:
```bash
./scripts/build.sh --verbose
```