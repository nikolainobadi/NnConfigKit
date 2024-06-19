//
//  ConfigCommand.swift
//
//
//  Created by Nikolai Nobadi on 5/5/24.
//

import Files
import SwiftShell
import NnConfigKit
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
        try runAndPrint(bash: "open -a Finder \(Folder.home.path).config/NnConfigList")
    }
}
