//
//  main.swift
//
//
//  Created by Artem Zhukov on 14.01.22.
//

import ArgumentParser
import PDFKit

struct App: ParsableCommand {
    
    // MARK: - Dependencies
    private var console: Console
    private var communicator: Communicator
    
    init() {
        self.console = Console()
        self.communicator = Communicator(console: console)
    }
    
    // MARK: - Argument parsing
    static var configuration = CommandConfiguration(
        commandName: "printds",
        abstract: "Print double sided documents manually with ease.",
        version: "0.0.1"
    )

    @Argument(help: "The path to the document.")
    var input: String
    
    // MARK: - Entry point
    mutating func run() throws {
        do {
            try communicator.doublesided(input)
        } catch Exception.exception(let message) {
            console.error("Exception: \(message)")
        }
    }
    
}

App.main()
