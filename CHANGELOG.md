# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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