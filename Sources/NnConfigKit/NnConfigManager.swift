//
//  NnConfigManager.swift
//
//
//  Created by Nikolai Nobadi on 6/19/24.
//

import Files
import Foundation

public struct NnConfigManager<Config: NnConfig> {
    public init() { }
}


// MARK: - Load
public extension NnConfigManager {
    func loadConfig() throws -> Config {
        let configFolder = try Folder(path: Config.configFolderPath)
        let configFile = try configFolder.file(named: Config.configFileName.json)
        let data = try configFile.read()
        let decoder = JSONDecoder()
        
        return try decoder.decode(Config.self, from: data)
    }
}

// MARK: - Save
public extension NnConfigManager {
    func saveConfig(_ config: Config) throws {
        let configFolder = try createFolderIfNeeded(path: Config.configFolderPath)
        let configFile = try configFolder.createFileIfNeeded(withName: Config.configFileName.json)
        let configData = try JSONEncoder.prettyOutput().encode(config)
        
        try configFile.write(configData)
    }
    
    func appendTextToFileIfNeeded(text: String, fileToUpdate: File, asNewLine: Bool) throws {
        let existingContents = try fileToUpdate.readAsString()
        
        if !existingContents.contains(text) {
            try fileToUpdate.append(asNewLine ? "\n\(text)" : text)
        }
    }
    
    func removeTextFromFile(text: String, fileToUpdate: File) throws {
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
    func saveNestedConfigFile(contents: String, nestedFilePath: String) throws {
        let configFolder = try createFolderIfNeeded(path: Config.configFolderPath)
        let nestedFile = try configFolder.createFileIfNeeded(at: nestedFilePath)
        
        try nestedFile.write(contents)
    }
    
    func deletedNestedConfigFile(nestedFilePath: String) throws {
        if let nestedFile = try? Folder(path: Config.configFolderPath).file(at: nestedFilePath) {
            try nestedFile.delete()
        }
    }
    
    func appendTextToNestedConfigFileIfNeeded(text: String, nestedFilePath: String, asNewLine: Bool = true) throws {
        let configFolder = try createFolderIfNeeded(path: Config.configFolderPath)
        let nestedFile = try configFolder.createFileIfNeeded(at: nestedFilePath)
        
        try appendTextToFileIfNeeded(text: text, fileToUpdate: nestedFile, asNewLine: asNewLine)
    }
    
    func removeTextFromNestedConfigFile(text: String, nestedFilePath: String) throws {
        if let nestedFile = try? Folder(path: Config.configFolderPath).file(at: nestedFilePath) {
            try removeTextFromFile(text: text, fileToUpdate: nestedFile)
        }
    }
}


// MARK: - Private Methods
private extension NnConfigManager {
    func createFolderIfNeeded(path: String) throws -> Folder {
        if let folder = try? Folder(path: path) {
            return folder
        }
        
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
        
        return try Folder(path: path)
    }
}
