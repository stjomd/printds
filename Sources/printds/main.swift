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
    
    @Injected private var console: Console!
    @Injected private var communicator: Communicator!
    
    // MARK: - Argument parsing
    
    static var configuration = CommandConfiguration(
        commandName: "printds",
        abstract: "Print double sided documents manually with ease.",
        version: "0.0.1"
    )

    @Argument(help: "The path to the document.")
    var input: String
    
    @Option(name: .shortAndLong, help: "The directory to save files to instead of printing.")
    var output: String?
    
    @Flag(name: .shortAndLong, help: "Print a usual single-sided document.")
    var single: Bool = false
    
    @Flag(name: .long, help: "Do not style output to the console.")
    var plain: Bool = false
    
    // MARK: - Entry point
    
    mutating func run() throws {
        do {
            console.plain(plain)
            if single {
                try communicator.singlesided(input: input, output: output)
            } else {
                try communicator.doublesided(input: input, output: output)
            }
        } catch Exception.because(let message) {
            console.error("Error: \(message)")
        }
    }
    
}

DependencyResolver.register(Console())
DependencyResolver.register(FileService())
DependencyResolver.register(PrintService())
DependencyResolver.register(DocumentService())
DependencyResolver.register(Communicator())

App.main()
