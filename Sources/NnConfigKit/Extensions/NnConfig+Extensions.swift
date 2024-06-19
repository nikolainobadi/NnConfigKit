//
//  NnConfig+Extensions.swift
//
//
//  Created by Nikolai Nobadi on 6/19/24.
//

import Files

/// The default folder path for configuration lists.
let DEFAULT_CONFIGLIST_FOLDER_PATH = "\(Folder.home.path).config/NnConfigList"

public extension NnConfig {
    /// Computes the path to the configuration folder based on the project name.
    static var configFolderPath: String {
        return "\(DEFAULT_CONFIGLIST_FOLDER_PATH)/\(projectName)"
    }

    /// Computes the configuration file name based on the project name.
    static var configFileName: String {
        return projectName
    }
}
