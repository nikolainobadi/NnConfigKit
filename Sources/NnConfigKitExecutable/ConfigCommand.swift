//
//  ConfigCommand.swift
//
//
//  Created by Nikolai Nobadi on 5/5/24.
//

import NnShellKit
import NnConfigKit
import ArgumentParser

struct ConfigCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A utility to create and manage config json files.",
        subcommands: [
            OpenFinder.self
        ]
    )
}

struct OpenFinder: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Opens the .config folder in Finder"
    )
    
    func run() throws {
        let shell = NnShell()
        try shell.bash("open -a Finder \(DEFAULT_CONFIGLIST_FOLDER_PATH)")
    }
}
