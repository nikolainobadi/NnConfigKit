//
//  NnFileSystemError.swift
//
//
//  Created by Nikolai Nobadi on 8/17/25.
//

import Foundation

/// Errors that can occur during file system operations
public enum NnFileSystemError: Error, LocalizedError {
    case fileNotFound(String)
    case folderNotFound(String)
    case pathIsNotFile(String)
    case readFailed(String)
    case writeFailed(String)
    case appendFailed(String)
    case createFileFailed(String)
    case stringEncodingFailed(String)
    case stringDecodingFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .fileNotFound(let path):
            return "File not found at path: \(path)"
        case .folderNotFound(let path):
            return "Folder not found at path: \(path)"
        case .pathIsNotFile(let path):
            return "Path is not a file: \(path)"
        case .readFailed(let path):
            return "Failed to read file at path: \(path)"
        case .writeFailed(let path):
            return "Failed to write file at path: \(path)"
        case .appendFailed(let path):
            return "Failed to append to file at path: \(path)"
        case .createFileFailed(let path):
            return "Failed to create file at path: \(path)"
        case .stringEncodingFailed(let path):
            return "Failed to encode string for file at path: \(path)"
        case .stringDecodingFailed(let path):
            return "Failed to decode string from file at path: \(path)"
        }
    }
}