//
//  NnConfig.swift
//  
//
//  Created by Nikolai Nobadi on 6/19/24.
//

/// A protocol defining the necessary properties for configuration objects.
/// These properties include the project name, the path to the configuration folder, and the name of the configuration file.
public protocol NnConfig: Codable {
    static var projectName: String { get }
    static var configFolderPath: String { get }
    static var configFileName: String { get }
}
