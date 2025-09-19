# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

NnConfigKit is a Swift package that provides configuration file management functionality. It is a focused library package that provides:

- **NnConfigKit** - The core library that provides the `NnConfigManager<Config: Codable>` generic type for managing configuration files

## Architecture

### Core Components

- **NnConfigManager** (`Sources/NnConfigKit/Manager/NnConfigManager.swift`) - Generic configuration manager that handles CRUD operations for JSON configuration files. Uses custom file system implementation.
- **JSONEncoder+Extensions** (`Sources/NnConfigKit/Extensions/JSONEncoder+Extensions.swift`) - Provides pretty-printed JSON encoding
- **File System Components** (`Sources/NnConfigKit/FileSystem/`) - Custom file system implementation with NnFile, NnFolder, and NnFileSystemError

### Key Dependencies

This package has **zero external dependencies** for maximum simplicity and reliability.

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

### Using in Your Project
```swift
// Add to Package.swift dependencies
.package(url: "https://github.com/nikolainobadi/NnConfigKit.git", from: "2.0.0")

// Import in your Swift files
import NnConfigKit
```

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
- Uses standard XCTest framework with no external dependencies
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