# Justfile for Go project template
# https://github.com/casey/just

# Set shell to bash
set shell := ["bash", "-cu"]

# Default recipe - show available commands
default:
    @just --list

# Project configuration
project_name := "myproject"
go_version := "1.21"
binary_name := "myapp"
build_dir := "bin"
cmd_dir := "cmd"

# Development commands
alias d := dev
alias b := build
alias t := test
alias c := clean
alias l := lint
alias f := fmt

# Initialize a new Go project
init name=project_name:
    @echo "🚀 Initializing Go project: {{name}}"
    go mod init github.com/{{env_var_or_default("USER", "user")}}/{{name}}
    mkdir -p {{cmd_dir}}/{{name}} internal/{app,config,models} pkg docs tests assets {{build_dir}}
    @echo "✅ Project {{name}} initialized"

# Install dependencies
deps:
    @echo "📦 Installing dependencies..."
    go mod tidy
    go mod download

# Format code
fmt:
    @echo "🎨 Formatting code..."
    go fmt ./...
    goimports -w .

# Run linter
lint:
    @echo "🔍 Running linter..."
    golangci-lint run

# Run tests
test:
    @echo "🧪 Running tests..."
    go test -v ./...

# Run tests with coverage
test-coverage:
    @echo "🧪 Running tests with coverage..."
    go test -v -coverprofile=coverage.out ./...
    go tool cover -html=coverage.out -o coverage.html
    @echo "📊 Coverage report generated: coverage.html"

# Run tests with race detection
test-race:
    @echo "🧪 Running tests with race detection..."
    go test -race -v ./...

# Build the application
build:
    @echo "🔨 Building application..."
    mkdir -p {{build_dir}}
    go build -o {{build_dir}}/{{binary_name}} ./{{cmd_dir}}/{{binary_name}}

# Build for multiple platforms
build-all:
    @echo "🔨 Building for multiple platforms..."
    mkdir -p {{build_dir}}
    GOOS=linux GOARCH=amd64 go build -o {{build_dir}}/{{binary_name}}-linux-amd64 ./{{cmd_dir}}/{{binary_name}}
    GOOS=darwin GOARCH=amd64 go build -o {{build_dir}}/{{binary_name}}-darwin-amd64 ./{{cmd_dir}}/{{binary_name}}
    GOOS=darwin GOARCH=arm64 go build -o {{build_dir}}/{{binary_name}}-darwin-arm64 ./{{cmd_dir}}/{{binary_name}}
    GOOS=windows GOARCH=amd64 go build -o {{build_dir}}/{{binary_name}}-windows-amd64.exe ./{{cmd_dir}}/{{binary_name}}

# Run the application in development mode
dev:
    @echo "🚀 Running in development mode..."
    go run ./{{cmd_dir}}/{{binary_name}}

# Run the application with hot reload (requires air)
dev-watch:
    @echo "🔄 Running with hot reload..."
    air

# Install development tools
install-tools:
    @echo "🛠️  Installing development tools..."
    go install github.com/cosmtrek/air@latest
    go install golang.org/x/tools/cmd/goimports@latest
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Clean build artifacts
clean:
    @echo "🧹 Cleaning build artifacts..."
    rm -rf {{build_dir}}
    go clean
    rm -f coverage.out coverage.html

# Run security scan
security:
    @echo "🔒 Running security scan..."
    gosec ./...

# Generate documentation
docs:
    @echo "📚 Generating documentation..."
    godoc -http=:6060 &
    @echo "Documentation available at http://localhost:6060"

# Run benchmarks
bench:
    @echo "⚡ Running benchmarks..."
    go test -bench=. -benchmem ./...

# Profile CPU usage
profile-cpu:
    @echo "📊 Profiling CPU usage..."
    go test -cpuprofile=cpu.prof -bench=. ./...
    go tool pprof cpu.prof

# Profile memory usage
profile-mem:
    @echo "📊 Profiling memory usage..."
    go test -memprofile=mem.prof -bench=. ./...
    go tool pprof mem.prof

# Check for vulnerabilities
vuln-check:
    @echo "🔍 Checking for vulnerabilities..."
    govulncheck ./...

# Update dependencies
update-deps:
    @echo "📦 Updating dependencies..."
    go get -u ./...
    go mod tidy

# Vendor dependencies
vendor:
    @echo "📦 Vendoring dependencies..."
    go mod vendor

# Run all checks (format, lint, test, security)
check: fmt lint test security
    @echo "✅ All checks passed!"

# Prepare for release
release: clean check build-all
    @echo "🚀 Release artifacts prepared in {{build_dir}}/"

# Docker commands
docker-build:
    @echo "🐳 Building Docker image..."
    docker build -t {{project_name}} .

docker-run:
    @echo "🐳 Running Docker container..."
    docker run --rm {{project_name}}

# Git helpers
git-hooks:
    @echo "🪝 Installing git hooks..."
    cp scripts/pre-commit .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit

# Initialize project with example files
bootstrap: init install-tools
    @echo "📝 Creating example files..."
    @echo 'package main\n\nimport "fmt"\n\nfunc main() {\n\tfmt.Println("Hello, {{project_name}}!")\n}' > {{cmd_dir}}/{{binary_name}}/main.go
    @echo 'package main\n\nimport "testing"\n\nfunc TestMain(t *testing.T) {\n\t// TODO: Add tests\n}' > {{cmd_dir}}/{{binary_name}}/main_test.go
    @echo "✅ Bootstrap complete! Run 'just dev' to start development"

# Show project status
status:
    @echo "📊 Project Status:"
    @echo "  Go version: $(go version)"
    @echo "  Module: $(go list -m)"
    @echo "  Dependencies: $(go list -m all | wc -l) modules"
    @echo "  Test files: $(find . -name '*_test.go' | wc -l) files"
    @echo "  Go files: $(find . -name '*.go' | wc -l) files"