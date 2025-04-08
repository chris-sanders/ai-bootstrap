# AI Bootstrap

A minimalist workflow for managing AI agent tasks in software projects.

## Overview

AI agents have become increasingly capable of helping with software development tasks, but there's a need for a standardized approach to delegating work to them and tracking their progress. This project provides a structured task lifecycle with a simple directory organization that makes it easy to manage AI contributions in any project.

## Key Features

- **Task-based workflow**: Clear status transitions from backlog → ready → started → completed
- **Directory structure** that reflects the task status
- **Standardized task format** with metadata, objectives, success criteria, and validation plans
- **Supporting documentation** with architecture details and instructions for AI agents
- **Easy bootstrapping** via a single script that sets up the entire structure

## Getting Started

```bash
# Clone this repository
git clone https://github.com/yourusername/ai-bootstrap.git

# Run the bootstrap script in your project
./ai-bootstrap/aigentic-bootstrap.sh /path/to/your/project
```

## Usage

1. Create tasks in the `/tasks/backlog/` directory using the provided template
2. Move tasks to `/tasks/ready/` when they're fully defined and ready for implementation
3. Point an AI agent to your project and instruct it to read `/docs/aigentic/ai-readme.md`
4. The AI agent will find tasks in the ready folder, work on them, and move them to the completed folder
5. Review and integrate the AI agent's work

## Benefits

- Provides a consistent way to manage AI agent contributions
- Makes it clear what tasks are available and their current status
- Enables tracking of task progress
- Minimal overhead for project teams to adopt
- Easy for AI agents to understand and follow

## Customization

The workflow is designed to be minimalist but can be customized for specific project needs. You can modify the task template, documentation structure, or add additional components as needed.