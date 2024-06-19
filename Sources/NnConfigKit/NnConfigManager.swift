//
//  File.swift
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
