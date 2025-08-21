//
//  NnFolder.swift
//
//
//  Created by Nikolai Nobadi on 8/17/25.
//

import Foundation

/// A folder representation that uses FileManager for directory operations
public struct NnFolder {
    public let path: String
    
    public init(path: String) throws {
        self.path = path
        
        // Verify the directory exists
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory),
              isDirectory.boolValue else {
            throw NnFileSystemError.folderNotFound(path)
        }
    }
    
    /// Convenience initializer for creating folders that don't exist yet
    public init(createPath: String) throws {
        self.path = createPath
        try FileManager.default.createDirectory(atPath: createPath, withIntermediateDirectories: true, attributes: nil)
    }
}

// MARK: - Static Properties
public extension NnFolder {
    /// The user's home directory
    static var home: NnFolder {
        let homePath = NSHomeDirectory()
        return try! NnFolder(path: homePath)
    }
    
    /// The system's temporary directory
    static var temporary: NnFolder {
        let tempPath = NSTemporaryDirectory()
        return try! NnFolder(path: tempPath)
    }
}

// MARK: - File Operations
public extension NnFolder {
    /// Gets a file with the specified name in this folder
    func file(named name: String) throws -> NnFile {
        let filePath = URL(fileURLWithPath: path).appendingPathComponent(name).path
        return try NnFile(path: filePath)
    }
    
    /// Gets a file at the specified relative path in this folder
    func file(at relativePath: String) throws -> NnFile {
        let filePath = URL(fileURLWithPath: path).appendingPathComponent(relativePath).path
        return try NnFile(path: filePath)
    }
    
    /// Creates a file with the specified name if it doesn't exist
    func createFileIfNeeded(withName name: String) throws -> NnFile {
        let filePath = URL(fileURLWithPath: path).appendingPathComponent(name).path
        
        if !FileManager.default.fileExists(atPath: filePath) {
            guard FileManager.default.createFile(atPath: filePath, contents: Data(), attributes: nil) else {
                throw NnFileSystemError.createFileFailed(filePath)
            }
        }
        
        return try NnFile(path: filePath)
    }
    
    /// Creates a file at the specified relative path if it doesn't exist
    func createFileIfNeeded(at relativePath: String) throws -> NnFile {
        let filePath = URL(fileURLWithPath: path).appendingPathComponent(relativePath).path
        
        // Create parent directories if needed
        let parentPath = URL(fileURLWithPath: filePath).deletingLastPathComponent().path
        if !FileManager.default.fileExists(atPath: parentPath) {
            try FileManager.default.createDirectory(atPath: parentPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        if !FileManager.default.fileExists(atPath: filePath) {
            guard FileManager.default.createFile(atPath: filePath, contents: Data(), attributes: nil) else {
                throw NnFileSystemError.createFileFailed(filePath)
            }
        }
        
        return try NnFile(path: filePath)
    }
}

// MARK: - Deletion
public extension NnFolder {
    /// Deletes the folder and all its contents
    func delete() throws {
        try FileManager.default.removeItem(atPath: path)
    }
}