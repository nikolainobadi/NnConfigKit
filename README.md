# NnConfigKit

![Swift Version](https://badgen.net/badge/swift/6.0%2B/purple)
![Platforms](https://img.shields.io/badge/platforms-macOS%2012%2B-blue)
![License](https://img.shields.io/badge/license-MIT-lightgray)

`NnConfigKit` is a lightweight Swift package designed to handle the loading, saving, and managing of configuration files for projects. It uses a custom file system implementation with zero external dependencies and provides a generic approach using `Codable` for configuration objects.

## Features

- **Zero dependencies** - Lightweight and reliable
- **Generic design** - Works with any `Codable` configuration type
- **Pretty-printed JSON** - Human-readable configuration files
- **Default location** - Automatically manages config files in `~/.config/NnConfigList/{projectName}/`
- **Nested file support** - Manage additional files within config directories
- **Custom paths** - Override default locations when needed

## Installation

To use `NnConfigKit` in your project, you can add it as a dependency in your `Package.swift` file:

```swift
.package(url: "https://github.com/nikolainobadi/NnConfigKit.git", from: "2.0.0")
```

## Usage

### Define Your Configuration
First, create a struct that conforms to the `Codable` protocol:

```swift
struct MyConfig: Codable {
    let appName: String
    let version: String
    let debugMode: Bool

    init(appName: String = "MyApp", version: String = "1.0.0", debugMode: Bool = false) {
        self.appName = appName
        self.version = version
        self.debugMode = debugMode
    }
}
```

### Initialize NnConfigManager
Create an instance of `NnConfigManager` with your project name and optionally specify the configuration folder path and configuration file name:

```swift
import NnConfigKit

// Default: saves to ~/.config/NnConfigList/MyProject/config.json
let configManager = NnConfigManager<MyConfig>(projectName: "MyProject")

// Custom location and filename
let customConfigManager = NnConfigManager<MyConfig>(
    projectName: "MyProject",
    configFolderPath: "/custom/path/to/config",
    configFileName: "settings.json"
)
```

### Loading Configuration
To load your configuration file, use the `NnConfigManager`:

```swift
do {
    let config = try configManager.loadConfig()
    
    // use config
} catch {
    print("Failed to load configuration: \(error)")
}
```

### Saving Configuration
To save your configuration, use the `NnConfigManager`:

```swift
let config = MyConfig(appName: "MyAwesomeApp", version: "2.1.0", debugMode: true)

do {
    try configManager.saveConfig(config)
    print("Configuration saved successfully!")
} catch {
    print("Failed to save configuration: \(error)")
}
```

### Managing Nested Configuration Files
You can also manage nested configuration files using the `NnConfigManager`:

```swift
import NnConfigKit

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
