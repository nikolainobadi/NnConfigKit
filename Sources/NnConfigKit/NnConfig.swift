//
//  NnConfig.swift
//  
//
//  Created by Nikolai Nobadi on 6/19/24.
//

import Files

public protocol NnConfig: Codable {
    static var projectName: String { get }
    static var configFolderPath: String { get }
    static var configFileName: String { get }
}


// MARK: - Helpers
let DEFAULT_CONFIGLIST_FOLDER_PATH = "\(Folder.home.path).config/NnConfigList"

extension NnConfig {
    static var configFolderPath: String {
        return "\(DEFAULT_CONFIGLIST_FOLDER_PATH)/\(projectName)"
    }
    
    static var configFileName: String {
        return projectName
    }
}
