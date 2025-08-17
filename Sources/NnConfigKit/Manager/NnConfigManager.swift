//
//  NnConfigManager.swift
//
//
//  Created by Nikolai Nobadi on 6/19/24.
//


import Foundation

/// The default folder path for configuration lists.
public let DEFAULT_CONFIGLIST_FOLDER_PATH = "\(NnFolder.home.path)/.config/NnConfigList"

/// A manager for handling configuration operations such as loading, saving, and managing nested configuration files.
public struct NnConfigManager<Config: Codable> {
    public let projectName: String
    public let configFolderPath: String
    public let configFileName: String
    
    /// Initializes a new configuration manager with the specified project name, configuration folder path, and configuration file name.
    /// - Parameters:
    ///   - projectName: The name of the project.
    ///   - configFolderPath: An optional custom path to the configuration folder. Defaults to a standard path based on the project name.
    ///   - configFileName: An optional custom name for the configuration file. Defaults to the project name.
    public init(projectName: String, configFolderPath: String? = nil, configFileName: String? = nil) {
        self.projectName = projectName
        self.configFolderPath = configFolderPath ?? "\(DEFAULT_CONFIGLIST_FOLDER_PATH)/\(projectName)"
        self.configFileName = configFileName ?? projectName
    }
}


// MARK: - Load
public extension NnConfigManager {
    /// Loads the configuration from the configuration file.
    /// - Throws: An error if the configuration file cannot be read or decoded.
    /// - Returns: The loaded configuration object.
    func loadConfig() throws -> Config {
        let configFolder = try NnFolder(path: configFolderPath)
        let configFile = try configFolder.file(named: configFileName.json)
        let data = try configFile.read()
        let decoder = JSONDecoder()
        return try decoder.decode(Config.self, from: data)
    }
}


// MARK: - Save
public extension NnConfigManager {
    /// Saves the configuration to the configuration file.
    /// - Parameter config: The configuration object to be saved.
    /// - Throws: An error if the configuration file cannot be written.
    func saveConfig(_ config: Config) throws {
        let configFolder = try createFolderIfNeeded(path: configFolderPath)
        let configFile = try configFolder.createFileIfNeeded(withName: configFileName.json)
        let configData = try JSONEncoder.prettyOutput().encode(config)
        try configFile.write(configData)
    }

    /// Appends text to a file if the text does not already exist in the file.
    /// - Parameters:
    ///   - text: The text to be appended.
    ///   - fileToUpdate: The file to update.
    ///   - asNewLine: Whether to append the text as a new line.
    /// - Throws: An error if the file cannot be read or written.
    func appendTextToFileIfNeeded(text: String, fileToUpdate: NnFile, asNewLine: Bool) throws {
        let existingContents = try fileToUpdate.readAsString()
        if !existingContents.contains(text) {
            try fileToUpdate.append(asNewLine ? "\n\(text)" : text)
        }
    }

    /// Removes text from a file.
    /// - Parameters:
    ///   - text: The text to be removed.
    ///   - fileToUpdate: The file to update.
    /// - Throws: An error if the file cannot be read or written.
    func removeTextFromFile(text: String, fileToUpdate: NnFile) throws {
        let existingContents = try fileToUpdate.readAsString()
        var lines = existingContents.components(separatedBy: .newlines)
        lines.removeAll { line in
            line == text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        let updatedContents = lines.joined(separator: "\n")
        try fileToUpdate.write(updatedContents)
    }
}


// MARK: - NestedConfigFiles
public extension NnConfigManager {
    /// Saves a nested configuration file with the specified contents.
    /// - Parameters:
    ///   - contents: The contents to be written to the nested file.
    ///   - nestedFilePath: The path to the nested file.
    /// - Throws: An error if the nested file cannot be created or written.
    func saveNestedConfigFile(contents: String, nestedFilePath: String) throws {
        let configFolder = try createFolderIfNeeded(path: configFolderPath)
        let nestedFile = try configFolder.createFileIfNeeded(at: nestedFilePath)
        try nestedFile.write(contents)
    }

    /// Deletes a nested configuration file at the specified path.
    /// - Parameter nestedFilePath: The path to the nested file.
    /// - Throws: An error if the nested file cannot be deleted.
    func deletedNestedConfigFile(nestedFilePath: String) throws {
        if let nestedFile = try? NnFolder(path: configFolderPath).file(at: nestedFilePath) {
            try nestedFile.delete()
        }
    }

    /// Appends text to a nested configuration file if the text does not already exist in the file.
    /// - Parameters:
    ///   - text: The text to be appended.
    ///   - nestedFilePath: The path to the nested file.
    ///   - asNewLine: Whether to append the text as a new line.
    /// - Throws: An error if the nested file cannot be created or written.
    func appendTextToNestedConfigFileIfNeeded(text: String, nestedFilePath: String, asNewLine: Bool = true) throws {
        let configFolder = try createFolderIfNeeded(path: configFolderPath)
        let nestedFile = try configFolder.createFileIfNeeded(at: nestedFilePath)
        try appendTextToFileIfNeeded(text: text, fileToUpdate: nestedFile, asNewLine: asNewLine)
    }

    /// Removes text from a nested configuration file.
    /// - Parameters:
    ///   - text: The text to be removed.
    ///   - nestedFilePath: The path to the nested file.
    /// - Throws: An error if the nested file cannot be read or written.
    func removeTextFromNestedConfigFile(text: String, nestedFilePath: String) throws {
        if let nestedFile = try? NnFolder(path: configFolderPath).file(at: nestedFilePath) {
            try removeTextFromFile(text: text, fileToUpdate: nestedFile)
        }
    }
}


// MARK: - Private Methods
private extension NnConfigManager {
    /// Creates a folder if it does not already exist.
    /// - Parameter path: The path to the folder.
    /// - Throws: An error if the folder cannot be created.
    /// - Returns: The created or existing folder.
    func createFolderIfNeeded(path: String) throws -> NnFolder {
        if let folder = try? NnFolder(path: path) {
            return folder
        }
        
        return try NnFolder(createPath: path)
    }
}


// MARK: - Extension Dependencies
extension String {
    /// Ensures the string ends with the ".json" extension.
    var json: String {
        if self.isEmpty { return "" }
        return self.hasSuffix(".json") ? self : "\(self).json"
    }
}
