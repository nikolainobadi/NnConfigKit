//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 5/5/24.
//

import Files

public enum ConfigPathFactory {
    static var configListPathSuffix: String {
        return ".config/NnConfigList/"
    }
}


// MARK: - Helper Methods
public extension ConfigPathFactory {
    static func makeConfigListFolderPath() -> String {
        return "\(Folder.home.path)/\(configListPathSuffix)"
    }
    
    static func makeProjectConfigFolderPath(projectName: String) -> String {
        return "\(makeConfigListFolderPath())/\(projectName)"
    }
    
    static func makeProjectConfigFilePath(projectName name: String) -> String {
        return "\(makeProjectConfigFolderPath(projectName: name))/\(name.json)"
    }
}


// MARK: - Dependencies
extension String {
    var json: String {
        return "\(self).json"
    }
}
