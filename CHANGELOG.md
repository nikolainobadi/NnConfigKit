# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2025-09-19

### BREAKING CHANGES
- Removed `NnConfigKitExecutable` target and all command-line functionality
- Eliminated CLI commands including `open-finder` subcommand
- Package now provides library-only functionality

### Removed
- NnConfigKitExecutable target and associated source files
- All external dependencies (NnShellKit, NnTestKit, ArgumentParser)
- Package.resolved file
- Command-line interface functionality

### Changed
- Simplified package structure to library-only target
- Updated test suite to remove NnTestHelpers dependency
- Streamlined Package.swift configuration

### Added
- Project changelog with complete version history

## [1.1.0] - 2025-08-20

### Changed
- Updated dependency from SwiftShell to NnShellKit for shell command execution
- Replaced Files library dependency with custom file system implementation

### Added
- Custom file system components: NnFile, NnFolder, and NnFileSystemError
- Project documentation (CLAUDE.md)

### Removed
- Files library dependency
- SwiftShell dependency

## [1.0.0] - 2025-06-08

### Added
- Initial release of NnConfigKit
- Generic `NnConfigManager<Config: Codable>` for configuration file management
- Support for JSON configuration files with pretty-printing
- Command-line executable with ArgumentParser for config folder management
- Default configuration location at `~/.config/NnConfigList/{projectName}/`
- Comprehensive unit test suite
- README documentation