# Claude Code Generation Guidelines for Gazelle Eye Tracking Project

## Project Overview

This is a Go-based eye tracking application that uses computer vision (OpenCV) to detect eye movements and control cursor position. The project integrates multiple technologies:

- **Computer Vision**: OpenCV (gocv) for eye detection and pupil tracking
- **GUI Framework**: Fyne for cross-platform desktop UI
- **Cursor Control**: Robotgo for system-level mouse control
- **Logging**: Logrus for structured logging
- **Testing**: Testify for assertions and mocking

## Core Architecture Principles

### 1. Error Handling & Resource Management
- **Always return errors**: Never use panic for normal error flow
- **Resource cleanup**: Use `defer` immediately after resource acquisition
- **Context-aware errors**: Include relevant context in error messages
- **Graceful degradation**: Handle failures gracefully without crashing the application

```go
// Good example
func (c *Camera) Open() error {
    cap, err := gocv.OpenVideoCapture(0)
    if err != nil {
        return fmt.Errorf("failed to open camera: %w", err)
    }
    defer cap.Close()
    
    c.capture = cap
    return nil
}
```

### 2. Concurrency & Thread Safety
- **UI thread safety**: All UI updates must use `fyne.Do()` to ensure thread safety
- **Race condition prevention**: Use proper synchronization for shared resources
- **Context cancellation**: Use context.Context for cancellation and timeouts
- **Goroutine management**: Always ensure goroutines can be properly terminated

```go
// UI thread safety example
fyne.Do(func() {
    if w.calibrateBtn != nil {
        w.calibrateBtn.Enable()
    }
})
```

### 3. Configuration & Dependency Injection
- **Constructor pattern**: Pass dependencies via constructors, not globals
- **Interface-based design**: Use interfaces for testability and flexibility
- **Sensible defaults**: Provide reasonable defaults for all configuration options
- **Validation**: Validate configuration at startup

## File and Directory Structure

### Standard Layout
```
gazelle/
├── cmd/                    # Application entry points
│   ├── gazelle/           # Main application
│   └── *-test/            # Test applications
├── internal/              # Private application code
│   ├── app/              # Application lifecycle
│   ├── camera/           # Camera interface and OpenCV integration
│   ├── config/           # Configuration management
│   ├── eyetracking/      # Eye detection and calibration
│   ├── gestures/         # Gesture recognition
│   ├── integration/      # System integration (cursor control)
│   ├── models/           # Data models and types
│   ├── ui/               # User interface components
│   └── utils/            # Utility functions
├── specs/                # Feature specifications and planning
├── docs/                 # Documentation
├── assets/               # Static assets (cascades, images)
└── bin/                  # Build outputs (gitignored)
```

### File Naming Conventions
- **Go files**: Use snake_case (e.g., `camera.go`, `eye_detector.go`)
- **Test files**: `{filename}_test.go`
- **Specs**: `{number}-{feature-name}.md` (e.g., `010-camera-interface.md`)
- **Binaries**: Output to `bin/` directory to avoid git tracking

## Code Style & Standards

### Documentation
- **GoDoc comments**: Every exported function, type, and package must have clear documentation
- **Parameter documentation**: Document all parameters and return values
- **Usage examples**: Include examples for complex functions
- **Package documentation**: Start each package with a comprehensive overview

```go
// Camera provides an interface for accessing video capture devices
// and performing computer vision operations on the captured frames.
//
// Example usage:
//
//	camera := NewCamera()
//	if err := camera.Open(); err != nil {
//	    log.Fatal(err)
//	}
//	defer camera.Close()
type Camera struct {
    // ... fields
}
```

### Logging Standards
- **Structured logging**: Use logrus with consistent field names
- **Log levels**: Use appropriate levels (Debug, Info, Warn, Error)
- **Context fields**: Include relevant context in log entries
- **Error logging**: Always log errors with context

```go
logger.WithFields(logrus.Fields{
    "camera_id": cameraID,
    "resolution": resolution,
}).Info("Camera initialized successfully")
```

### Testing Requirements
- **Unit tests**: Every package must have corresponding `_test.go` files
- **Table-driven tests**: Use for functions with multiple test cases
- **Mocking**: Use interfaces and mocks for external dependencies
- **Coverage**: Aim for high test coverage, especially for critical paths
- **Integration tests**: Test complete workflows and system integration

```go
func TestCameraOpen(t *testing.T) {
    tests := []struct {
        name    string
        device  int
        wantErr bool
    }{
        {"valid device", 0, false},
        {"invalid device", 999, true},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            camera := NewCamera()
            err := camera.Open(tt.device)
            if (err != nil) != tt.wantErr {
                t.Errorf("Camera.Open() error = %v, wantErr %v", err, tt.wantErr)
            }
        })
    }
}
```

## Platform-Specific Considerations

### macOS Integration
- **Permission handling**: Handle camera and accessibility permissions gracefully
- **UI guidelines**: Follow macOS UI patterns and conventions
- **System integration**: Use robotgo for cursor control with proper error handling
- **Fullscreen support**: Handle fullscreen windows properly (especially for calibration)

### Cross-Platform Compatibility
- **Build tags**: Use build tags for platform-specific code
- **Feature detection**: Detect available features at runtime
- **Graceful fallbacks**: Provide alternatives when platform features aren't available

## Common Patterns & Anti-Patterns

### Do's
- ✅ Use interfaces for testability
- ✅ Handle errors explicitly and return them
- ✅ Use `defer` for resource cleanup
- ✅ Use `fyne.Do()` for UI updates
- ✅ Log important events and errors
- ✅ Write comprehensive tests
- ✅ Use context for cancellation
- ✅ Validate inputs and configuration

### Don'ts
- ❌ Don't use panic for normal error flow
- ❌ Don't use global variables for dependencies
- ❌ Don't ignore errors
- ❌ Don't update UI from background goroutines
- ❌ Don't create resource leaks
- ❌ Don't write untested code
- ❌ Don't use magic numbers or hardcoded values

## Development Workflow

### Feature Development
1. **Create spec**: Add specification to `specs/` folder
2. **Implement incrementally**: Build in small, testable increments
3. **Test thoroughly**: Write tests for each component
4. **Document changes**: Update relevant documentation
5. **Commit with context**: Use descriptive commit messages

### Code Review Checklist
- [ ] Follows Go idioms and conventions
- [ ] Proper error handling throughout
- [ ] Comprehensive test coverage
- [ ] Clear documentation and comments
- [ ] No resource leaks or race conditions
- [ ] UI updates are thread-safe
- [ ] Configuration is validated
- [ ] Logging is appropriate and contextual

## Performance Considerations

### Computer Vision
- **Frame processing**: Optimize frame processing loops
- **Memory management**: Reuse frame buffers when possible
- **GPU acceleration**: Consider GPU acceleration for heavy computations
- **Resolution scaling**: Scale down for processing, scale up for display

### UI Performance
- **Async operations**: Don't block UI thread with heavy computations
- **Efficient updates**: Batch UI updates when possible
- **Memory usage**: Monitor memory usage, especially with video processing

## Security & Privacy

### Data Handling
- **No data persistence**: Don't store sensitive user data unnecessarily
- **Camera permissions**: Handle camera access permissions properly
- **Input validation**: Validate all user inputs and configuration
- **Error messages**: Don't expose sensitive information in error messages

## Tooling & Development Environment

### Code Search & Analysis
- **Use ripgrep**: Prefer `rg` over `grep` for significantly faster text search
  - `rg "pattern"` for basic search
  - `rg -t go "pattern"` to search only Go files
  - `rg -A 5 -B 5 "pattern"` for context lines
  - `rg --type-add 'go:*.go' "pattern"` for custom file types
- **Go tooling**: Use `go fmt`, `goimports`, `go vet`, and `golangci-lint`
- **IDE integration**: Configure your editor to use ripgrep for search operations

### Performance Tools
- **Profiling**: Use Go's built-in profiling tools (`go tool pprof`)
- **Benchmarking**: Write benchmarks for performance-critical code
- **Memory analysis**: Use `go tool pprof` for memory profiling

## Troubleshooting & Debugging

### Common Issues
- **Race conditions**: Use proper synchronization and `fyne.Do()`
- **Resource leaks**: Ensure all resources are properly closed
- **UI freezing**: Move heavy operations to background goroutines
- **Camera access**: Handle camera permissions and device availability

### Debugging Tools
- **Logging**: Use structured logging with appropriate levels
- **Profiling**: Use Go's built-in profiling tools
- **Race detection**: Use `go run -race` for race condition detection
- **Memory profiling**: Monitor memory usage with pprof
- **Code search**: Use `rg` for fast pattern matching and code exploration

## Example Prompts for Claude

### Implementing New Features
```
Implement the eye tracking calibration system as described in specs/110-calibration-improvements.md. 
Create the calibration window in internal/ui/calibration_window.go with proper error handling, 
thread safety, and comprehensive tests. Include full GoDoc documentation.
```

### Fixing Issues
```
Fix the race condition in the calibration window closing logic. The issue is in 
internal/ui/calibration_window.go where multiple goroutines are trying to close the window 
simultaneously. Ensure proper synchronization and prevent the SIGBUS error.
```

### Refactoring
```
Refactor the camera interface in internal/camera/camera.go to use dependency injection 
and improve testability. Extract the OpenCV-specific code into a separate implementation 
and create a clean interface for camera operations.
```

---

This guidance ensures Claude generates robust, maintainable, and idiomatic Go code that follows the project's architecture and best practices.