//
//  NnFile.swift
//
//
//  Created by Nikolai Nobadi on 8/17/25.
//

import Foundation

/// A file representation that uses FileManager for file operations
public struct NnFile {
    public let path: String
    
    public init(path: String) throws {
        self.path = path
        
        // Verify the file exists
        guard FileManager.default.fileExists(atPath: path) else {
            throw NnFileSystemError.fileNotFound(path)
        }
        
        // Verify it's actually a file (not a directory)
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory),
              !isDirectory.boolValue else {
            throw NnFileSystemError.pathIsNotFile(path)
        }
    }
}

// MARK: - Reading
public extension NnFile {
    /// Reads the file contents as Data
    func read() throws -> Data {
        guard let data = FileManager.default.contents(atPath: path) else {
            throw NnFileSystemError.readFailed(path)
        }
        return data
    }
    
    /// Reads the file contents as String
    func readAsString(encoding: String.Encoding = .utf8) throws -> String {
        let data = try read()
        guard let string = String(data: data, encoding: encoding) else {
            throw NnFileSystemError.stringDecodingFailed(path)
        }
        return string
    }
}

// MARK: - Writing
public extension NnFile {
    /// Writes Data to the file
    func write(_ data: Data) throws {
        guard FileManager.default.createFile(atPath: path, contents: data, attributes: nil) else {
            throw NnFileSystemError.writeFailed(path)
        }
    }
    
    /// Writes String to the file
    func write(_ string: String, encoding: String.Encoding = .utf8) throws {
        guard let data = string.data(using: encoding) else {
            throw NnFileSystemError.stringEncodingFailed(path)
        }
        try write(data)
    }
    
    /// Appends String to the file
    func append(_ string: String, encoding: String.Encoding = .utf8) throws {
        guard let data = string.data(using: encoding) else {
            throw NnFileSystemError.stringEncodingFailed(path)
        }
        
        guard let fileHandle = FileHandle(forWritingAtPath: path) else {
            throw NnFileSystemError.appendFailed(path)
        }
        
        defer { fileHandle.closeFile() }
        
        fileHandle.seekToEndOfFile()
        fileHandle.write(data)
    }
}

// MARK: - Deletion
public extension NnFile {
    /// Deletes the file
    func delete() throws {
        try FileManager.default.removeItem(atPath: path)
    }
}