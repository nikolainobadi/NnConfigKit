# NnConfigKit

![Swift Version](https://badgen.net/badge/swift/6.0%2B/purple)
![Platforms](https://img.shields.io/badge/platforms-macOS%2012%2B-blue)
![License](https://img.shields.io/badge/license-MIT-lightgray)

`NnConfigKit` is a Swift package designed to handle the loading, saving, and managing of configuration files for projects. It leverages the `Files` library to manage file operations and provides a protocol-based approach to ensure that your configuration objects conform to the necessary structure.

## Features

- Define configuration objects using the `Codable` protocol.
- Load and save configuration files with ease.
- Manage nested configuration files.
- Append or remove text in configuration files.

## Installation

To use `NnConfigKit` in your project, you can add it as a dependency in your `Package.swift` file:

```swift
    .package(url: "https://github.com/nikolainobadi/NnConfigKit.git", from: "1.0.0")
```

## Usage

### Define Your Configuration
First, create a struct that conforms to the `Codable` protocol:

```swift
struct MyConfig: Codable {
    // codable properties here
}
```

### Initialize NnConfigManager
Create an instance of `NnConfigManager` with your project name and optionally specify the configuration folder path and configuration file name:

```swift
import NnConfigKit

// only passing in projectName will save the config file in .config/NnConfigList/\(projectName) in your home directory
let configManager = NnConfigManager<MyConfig>(projectName: "MyProject")

// provide configFolderPath and configFileName to customize the location of the config file
let configFolderPath = "path/to/your/config/folder"
let configFileName = "myConfig.json"
let customConfigManager = NnConfigManager<MyConfig>(projectName: "MyProject", configFolderPath: configFolderName, configFileName: configFileName)
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
let config = MyConfig()

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
