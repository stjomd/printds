//
//  App.swift
//  
//
//  Created by Artem Zhukov on 17.01.22.
//

import ArgumentParser
import PDFKit

struct App: ParsableCommand {
    
    // MARK: - Dependencies
    
    @Resolved private var console: Console!
    @Resolved private var communicator: Communicator!
    
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
    
    @Option(name: .shortAndLong, help: "The number of the page to be considered the first.")
    var from: Int?
    
    @Option(name: .shortAndLong, help: "The number of the page to be considered the last.")
    var to: Int?
    
    @Flag(name: .shortAndLong, help: "Print a usual single-sided document.")
    var single: Bool = false
    
    @Flag(name: .long, help: "Do not style output to the console.")
    var plain: Bool = false
    
    // MARK: - Entry point
    
    mutating func run() throws {
        console.plain(plain)
        do {
            let args = try Arguments(input: input, output: output, from: from, to: to)
            if single {
                try communicator.singlesided(args)
            } else {
                try communicator.doublesided(args)
            }
        } catch Exception.because(let message) {
            console.error("Error: \(message)")
        }
    }
    
}
