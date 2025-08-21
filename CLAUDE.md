# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

NnConfigKit is a Swift package that provides configuration file management functionality. It consists of two main targets:

1. **NnConfigKit** - The core library that provides the `NnConfigManager<Config: Codable>` generic type for managing configuration files
2. **NnConfigKitExecutable** - A command-line utility built with ArgumentParser for config folder management

## Architecture

### Core Components

- **NnConfigManager** (`Sources/NnConfigKit/Manager/NnConfigManager.swift`) - Generic configuration manager that handles CRUD operations for JSON configuration files. Uses the Files library for file system operations.
- **JSONEncoder+Extensions** (`Sources/NnConfigKit/Extensions/JSONEncoder+Extensions.swift`) - Provides pretty-printed JSON encoding
- **ConfigCommand** (`Sources/NnConfigKitExecutable/ConfigCommand.swift`) - ArgumentParser-based CLI with subcommands for config management

### Key Dependencies

- **Files** (JohnSundell/Files) - File system operations for the core library
- **NnShellKit** (nikolainobadi/NnShellKit) - Shell command execution for the executable
- **ArgumentParser** (apple/swift-argument-parser) - CLI interface
- **NnTestKit** (nikolainobadi/NnTestKit) - Custom testing utilities

### Configuration Management

The `NnConfigManager` operates with these patterns:
- Default config location: `~/.config/NnConfigList/{projectName}/`
- Config files are stored as pretty-printed JSON
- Supports nested file management within config directories
- Generic over any `Codable` configuration type

## Development Commands

### Building
```bash
swift build
```

### Testing
```bash
swift test
```

### Running the Executable
```bash
swift run NnConfigKitExecutable [subcommand]
```

Available subcommands:
- `open-finder` - Opens the .config folder in Finder

### Testing Specific Components
```bash
# Run specific test class
swift test --filter NnConfigManagerTests

# Run specific test method
swift test --filter NnConfigManagerTests.test_saves_config_in_default_folder_and_overwrites_config_when_updating
```

## Code Patterns

### Generic Configuration Manager Usage
```swift
// Create manager for any Codable type
let manager = NnConfigManager<MyConfig>(projectName: "MyApp")

// With custom paths
let customManager = NnConfigManager<MyConfig>(
    projectName: "MyApp",
    configFolderPath: "/custom/path",
    configFileName: "custom.json"
)
```

### Testing Approach
- Uses `NnTestHelpers` from NnTestKit for assertion utilities
- Test setup/teardown handles config folder cleanup
- Uses mock configuration objects that conform to `Codable` and `Equatable`
- Tests both default and custom configuration folder scenarios

## File Header Convention

New Swift files should include the standard header:
```swift
//
//  FileName.swift
//
//
//  Created by Nikolai Nobadi on DATE.
//
```