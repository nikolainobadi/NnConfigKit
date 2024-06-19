//
//  NnConfig.swift
//  
//
//  Created by Nikolai Nobadi on 6/19/24.
//

public protocol NnConfig: Codable {
    static var projectName: String { get }
    static var configFolderPath: String { get }
    static var configFileName: String { get }
}

extension NnConfig {
    static var configFolderPath: String {
        return "~/.config/NnConfigList/\(projectName)"
    }
    
    static var configFileName: String {
        return projectName
    }
}
