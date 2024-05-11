// NnConfigGenKit.swift
// Generated by NnProjectGenerator on May 5, 2024

import Files
import Foundation

public enum NnConfigGen<Config: NnConfig> {
    static var projectConfigFolderPath: String {
        return "\(ConfigPathFactory.configListPathSuffix)/\(Config.projectName)"
    }
}


// MARK: - Save/Load project config
public extension NnConfigGen {
    static func saveConfig(_ config: Config) throws {
        let configFile = try Folder.home.createFileIfNeeded(at: makeProjectConfigFilePath())
        print("creating config at path: \(configFile.path)")
        let encoder = JSONEncoder.prettyOutput()
        let configData = try encoder.encode(config)
        
        try configFile.write(configData)
    }
    
    static func loadConfig() throws -> Config {
        let configFile = try File(path: makeProjectConfigFilePath())
        let data = try configFile.read()
        let decoder = JSONDecoder()
        
        return try decoder.decode(Config.self, from: data)
    }
}


// MARK: - Save/Update/Delete nested project config files
public extension NnConfigGen {
    static func saveNestedFile(contents: String, nestedFilePath path: String) throws {
        try createNestedFileIfNeeded(nestedPath: path).write(contents)
    }
    
    static func deleteNestedFile(nestedFilePath path: String) throws {
        try getNestedFile(path: path)?.delete()
    }
    
    static func appendToNestedFileIfNeeded(text: String, nestedFilePath path: String, asNewLine: Bool) throws {
        let fileToUpdate = try createNestedFileIfNeeded(nestedPath: path)
        
        try appendToFileIfNeeded(text: text, fileToUpdate: fileToUpdate, asNewLine: asNewLine)
    }
    
    static func removeFromNestedFile(textToRemove text: String, nestedFilePath path: String) throws {
        guard let fileToUpdate = getNestedFile(path: path) else { return }
        
        try removeFromFile(textToRemove: text, fileToUpdate: fileToUpdate)
    }
}


// MARK: - Helper Methods
public extension NnConfigGen {
    static func appendToZSHRCFileIfNeeded(text: String, asNewLine: Bool) throws {
        let fileToUpdate = try Folder.home.createFileIfNeeded(withName: ".zshrc")
        
        try appendToFileIfNeeded(text: text, fileToUpdate: fileToUpdate, asNewLine: true)
    }
}


// MARK: - Private Methods
private extension NnConfigGen {
    static func makeProjectConfigFilePath() -> String {
        return ConfigPathFactory.makeProjectConfigFilePath(projectName: Config.projectName)
    }
    
    @discardableResult
    static func createNestedFileIfNeeded(nestedPath: String) throws -> File {
        let projectConfigFolder = try Folder.home.createSubfolderIfNeeded(at: projectConfigFolderPath)
        
        return try projectConfigFolder.createFileIfNeeded(at: nestedPath)
    }
    
    static func appendToFileIfNeeded(text: String, fileToUpdate: File, asNewLine: Bool) throws {
        let existingContents = try fileToUpdate.readAsString()
        
        if !existingContents.contains(text) {
            try fileToUpdate.append(asNewLine ? "\n\(text)" : text)
        }
    }
    
    static func removeFromFile(textToRemove text: String, fileToUpdate: File) throws {
        let existingContents = try fileToUpdate.readAsString()
        var lines = existingContents.components(separatedBy: .newlines)
        lines.removeAll { line in
            line == text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        let updatedContents = lines.joined(separator: "\n")
        
        try fileToUpdate.write(updatedContents)
    }
    
    static func getNestedFile(path: String) -> File? {
        return try? Folder.home.subfolder(at: projectConfigFolderPath).file(at: path)
    }
}


// MARK: - Dependencies
public protocol NnConfig: Codable {
    static var projectName: String { get }
}


// MARK: - Extension Dependencies
public extension JSONEncoder {
    static func prettyOutput() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        return encoder
    }
}
