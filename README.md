# NnConfigKit

`NnConfigKit` is a Swift package designed to handle the loading, saving, and managing of configuration files for projects. It leverages the `Files` library to manage file operations and provides a protocol-based approach to ensure that your configuration objects conform to the necessary structure.

## Features

- Define configuration objects using the `NnConfig` protocol.
- Load and save configuration files with ease.
- Manage nested configuration files.
- Append or remove text in configuration files.

## Installation

To use `NnConfigKit` in your project, you can add it as a dependency in your `Package.swift` file:

```swift
// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "YourProjectName",
    dependencies: [
        .package(url: "https://github.com/nikolainobadi/NnConfigKit.git", branch: "main")
    ],
    targets: [
        .target(
            name: "YourProjectName",
            dependencies: ["NnConfigKit"]),
        .testTarget(
            name: "YourProjectNameTests",
            dependencies: ["YourProjectName"]),
    ]
)
```

## Usage

### Define Your Configuration

First, create a struct that conforms to the `NnConfig` protocol:

```swift
import NnConfigKit

struct MyConfig: NnConfig {
    static var projectName: String = "MyProject"
}
```

### Loading Configuration

To load your configuration file, use the `NnConfigManager`:

```swift
import NnConfigKit

let configManager = NnConfigManager<MyConfig>()
do {
    let config = try configManager.loadConfig()
    print(config)
} catch {
    print("Failed to load configuration: \(error)")
}
```

### Saving Configuration

To save your configuration, use the `NnConfigManager`:

```swift
import NnConfigKit

let config = MyConfig()
let configManager = NnConfigManager<MyConfig>()
do {
    try configManager.saveConfig(config)
} catch {
    print("Failed to save configuration: \(error)")
}
```

### Managing Nested Configuration Files

You can also manage nested configuration files using the `NnConfigManager`:

```swift
import NnConfigKit

let configManager = NnConfigManager<MyConfig>()

// Save a nested file
do {
    try configManager.saveNestedConfigFile(contents: "Nested file contents", nestedFilePath: "nestedFile.txt")
} catch {
    print("Failed to save nested configuration file: \(error)")
}

// Append text to a nested file
do {
    try configManager.appendTextToNestedConfigFileIfNeeded(text: "New line of text", nestedFilePath: "nestedFile.txt")
} catch {
    print("Failed to append text to nested configuration file: \(error)")
}

// Remove text from a nested file
do {
    try configManager.removeTextFromNestedConfigFile(text: "Line of text to remove", nestedFilePath: "nestedFile.txt")
} catch {
    print("Failed to remove text from nested configuration file: \(error)")
}

// Delete a nested file
do {
    try configManager.deletedNestedConfigFile(nestedFilePath: "nestedFile.txt")
} catch {
    print("Failed to delete nested configuration file: \(error)")
}
```

## License

`NnConfigKit` is released under the MIT license. See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue on GitHub.
