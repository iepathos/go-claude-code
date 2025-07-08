# Go Claude Code Starter Template

A comprehensive Go project starter template optimized for development with Claude Code. This template provides a well-structured foundation for building Go applications with AI-assisted development in mind.

## Features

- **Comprehensive CLAUDE.md**: Detailed project guidelines tailored for AI-assisted development
- **Production-ready .gitignore**: Extensive ignore patterns for Go development
- **Best practices baked in**: Error handling, testing, documentation, and architecture patterns
- **Example project structure**: Based on a real-world computer vision application

## Quick Start

1. **Clone this template**:
   ```bash
   git clone https://github.com/yourusername/go-claude-code.git my-project
   cd my-project
   rm -rf .git
   git init
   ```

2. **Review and customize CLAUDE.md**:
   - Update the project overview section
   - Modify technology stack to match your project
   - Adjust architecture principles as needed
   - Update the directory structure example

3. **Initialize your Go module**:
   ```bash
   go mod init github.com/yourusername/my-project
   ```

4. **Create your project structure**:
   ```bash
   mkdir -p cmd/myapp internal/{app,config,models} pkg docs tests
   ```

## Project Structure

```
my-project/
├── .claude/           # Claude Code configuration (auto-generated)
├── .gitignore         # Comprehensive Go gitignore
├── CLAUDE.md          # AI development guidelines
├── README.md          # This file
├── go.mod             # Go module file
├── cmd/               # Application entry points
│   └── myapp/         # Main application
├── internal/          # Private application code
│   ├── app/           # Application core logic
│   ├── config/        # Configuration management
│   └── models/        # Data models
├── pkg/               # Public packages
├── docs/              # Documentation
├── tests/             # Integration tests
└── bin/               # Build outputs (gitignored)
```

## What's Included

### .gitignore

A comprehensive gitignore file covering:
- Go build artifacts and binaries
- IDE and editor files (VS Code, IntelliJ, Vim)
- OS-specific files (macOS, Windows, Linux)
- Test outputs and coverage reports
- Temporary files and logs
- Environment and configuration files
- Database and archive files
- Project-specific patterns

### CLAUDE.md

Detailed guidelines for AI-assisted development including:

1. **Architecture Principles**:
   - Error handling patterns
   - Resource management
   - Concurrency and thread safety
   - Dependency injection

2. **Code Standards**:
   - Documentation requirements
   - Testing standards
   - Logging patterns
   - File naming conventions

3. **Development Workflow**:
   - Feature development process
   - Code review checklist
   - Performance considerations
   - Security best practices

4. **Tool Recommendations**:
   - Using ripgrep for fast code search
   - Go toolchain usage
   - Profiling and debugging

5. **Example Prompts**:
   - Feature implementation
   - Bug fixes
   - Code refactoring

## Working with Claude Code

### Best Practices

1. **Clear Context**: CLAUDE.md provides Claude with comprehensive context about your project's standards and patterns.

2. **Structured Prompts**: Use the example prompts in CLAUDE.md as templates for your requests.

3. **Incremental Development**: Break large features into smaller, testable increments.

4. **Test-Driven**: Ask Claude to write tests alongside implementations.

### Example Usage

```bash
# Start Claude Code in your project
claude code .

# Example prompts:
"Implement a REST API server with health check endpoint following our project standards"
"Create a configuration system using Viper with environment variable support"
"Add comprehensive unit tests for the user service with mocking"
```

## Customization Guide

### Adapting the Template

1. **Update CLAUDE.md**:
   - Replace "Gazelle Eye Tracking Project" with your project name
   - Update the technology stack section
   - Modify the directory structure to match your needs
   - Adjust coding standards to your team's preferences

2. **Modify .gitignore**:
   - Remove project-specific sections (e.g., Gazelle-specific, eye tracking)
   - Add patterns specific to your project
   - Keep the general Go and development tool patterns

3. **Add Project-Specific Files**:
   - Create a Makefile for common tasks
   - Add GitHub Actions workflows
   - Include Docker configuration if needed

### Extending the Template

Consider adding:
- Pre-commit hooks configuration
- CI/CD pipeline templates
- Dockerfile and docker-compose.yml
- Kubernetes manifests
- API documentation templates
- Database migration setup

## Contributing

If you have suggestions for improving this template:

1. Fork the repository
2. Create a feature branch
3. Make your improvements
4. Submit a pull request

## License

This template is available under the MIT License. Feel free to use it for any purpose.

## Acknowledgments

This template is based on real-world Go development experience and best practices from the Go community.