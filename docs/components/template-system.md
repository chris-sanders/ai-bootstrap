# Component: Template System

## Purpose
The template system provides a comprehensive approach to manage and build the bootstrap script by separating templates from core logic. This makes templates easier to maintain and review, while preserving the simplicity of the curl-pipe-bash installation experience.

## Responsibilities
- Separate templates from script logic for improved maintainability
- Organize templates in a logical structure based on features
- Build a complete, distributable script from templates and core logic
- Ensure identical functionality compared to the original monolithic script
- Provide a simpler development experience for template modifications

## Interfaces
- **Input**: 
  - Templates in the templates/ directory
  - Core script logic in src/bootstrap-core.sh
  - Build script parameters (--verbose)
- **Output**: 
  - Generated distributable script in dist/agentic-bootstrap.sh

## Dependencies
- Bash shell environment
- Unix standard utilities (cat, sed, mkdir, etc.)
- Source templates in multiple directories
  - Base templates in templates/base/
  - Feature-specific templates in templates/features/

## Design Decisions
- **Full Script Generation**: 
  - Generates a standalone script rather than using source statements for templates
  - The generated script has no runtime dependencies on template files
  - Preserves the same user experience as the original monolithic script

- **Directory Structure**:
  - Organized templates by functionality (base vs. feature-specific)
  - Clear separation between conditional and non-conditional templates
  - Templates stored in plain text to make them easier to edit and review

- **Build Process**:
  - Build script constructs the final script directly rather than using a complex templating system
  - Uses heredocs with custom delimiters (TEMPLATE_EOF) to avoid conflicts with template content
  - Preserves meaningful comments in the generated script
  - Adds version and timestamp information for tracking

- **Component Interactions**:
  - Templates have no dependencies on each other
  - Core script contains only structure and logic without templates
  - Generated script is fully independent after build

## Examples

### Template Organization
```
templates/
├── base/               # Base templates used in all configurations
│   ├── ai-readme-base.md
│   ├── architecture.md
│   ├── component-doc.md
│   ├── example-task.md
│   ├── git-commit-guidelines.md
│   └── task-template.md
└── features/           # Feature-specific templates
    ├── adr/
    │   └── adr-template.md
    └── github-mcp/
        ├── ai-readme-github-extension.md
        └── github-mcp-guide.md
```

### Build Command
```bash
# Basic build
./scripts/build.sh

# Build with verbose output
./scripts/build.sh --verbose
```

### Installation Experience (Unchanged)
```bash
# The generated script works exactly like the original
./dist/agentic-bootstrap.sh

# All flags work as expected
./dist/agentic-bootstrap.sh --with-adr --without-github-mcp --force
```