//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 5/5/24.
//

import Files

public enum ConfigPathFactory {
    public static func makeConfigListFolderPath(withHomeDirectory: Bool = false) -> String {
        let pathSuffix = ".config/NnConfigList/"
        
        return withHomeDirectory ? "\(Folder.home.path)/\(pathSuffix)" : pathSuffix
    }
    
    public static func makeConfigFilePath(projectName name: String, withHomeDirectory: Bool = false) -> String {
        return "\(makeConfigListFolderPath(withHomeDirectory: withHomeDirectory))/\(name)/\(name.withJSONExtension)"
    }
}


// MARK: - Dependencies
extension String {
    var withJSONExtension: String {
        return "\(self).json"
    }
}
