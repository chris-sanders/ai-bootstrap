# Component: Template Directory

## Purpose
The template directory provides a structured way to maintain and organize template files used by the bootstrap script, separating them from the core script logic for easier maintenance and clearer PR reviews.

## Responsibilities
- Store template files in a logical, organized structure
- Separate base templates from feature-specific templates
- Support conditional inclusion of templates based on script configuration
- Make templates easier to review and maintain independently

## Interfaces
- **Input**: None (passive component)
- **Output**: Template files read by the build script

## Dependencies
- Build script (scripts/build.sh) consumes these templates

## Design Decisions
- Organized in a hierarchical structure:
  - `templates/base/`: Contains core templates used in all configurations
    - `ai-readme-base.md`: Base AI readme content
    - `task-template.md`: Task template
    - `component-doc.md`: Component documentation template
    - `architecture.md`: System architecture template
    - `git-commit-guidelines.md`: Basic git commit guidelines
    - `example-task.md`: Example task template
  - `templates/features/`: Contains feature-specific templates
    - `github-mcp/`: GitHub MCP integration templates
      - `ai-readme-github-extension.md`: GitHub MCP extensions to AI readme
      - `github-mcp-guide.md`: GitHub MCP guide
    - `adr/`: Architecture Decision Record templates
      - `adr-template.md`: ADR template
- Templates are maintained as standalone files in their natural format
- Feature-specific templates are only included when their feature is enabled
- Templates follow the exact same format as used in the final script
- Use of clear, descriptive filenames to indicate purpose
- Follows a convention where base content and feature extensions are combined during build

## Examples

Template organization:
```
templates/
├── base/
│   ├── ai-readme-base.md
│   ├── architecture.md
│   ├── component-doc.md
│   ├── example-task.md
│   ├── git-commit-guidelines.md
│   └── task-template.md
└── features/
    ├── adr/
    │   └── adr-template.md
    └── github-mcp/
        ├── ai-readme-github-extension.md
        └── github-mcp-guide.md
```

Example of how templates are combined:
- For GitHub MCP enabled builds: 
  `ai-readme-base.md` + `ai-readme-github-extension.md` → `ai-readme.md`
- For builds without GitHub MCP: 
  `ai-readme-base.md` + `git-commit-guidelines.md` → `ai-readme.md`