//
//  ConfigCommand.swift
//
//
//  Created by Nikolai Nobadi on 5/5/24.
//

import SwiftShell
import NnConfigGenKit
import ArgumentParser

struct ConfigCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A utility to create and manage config json files.",
        subcommands: [
            OpenFinder.self
        ]
    )
}

struct OpenFinder: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Opens the .config folder in Finder"
    )
    
    func run() throws {
        let configListFolderPath = ConfigPathFactory.makeConfigListFolderPath(withHomeDirectory: true)
        
        try runAndPrint(bash: "open -a Finder \(configListFolderPath)")
    }
}
