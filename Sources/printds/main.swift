//
//  main.swift
//
//
//  Created by Artem Zhukov on 14.01.22.
//

import ArgumentParser

struct App: ParsableCommand {
    
    static var configuration = CommandConfiguration(
        commandName: "printds",
        abstract: "Print double sided documents manually with ease.",
        version: "0.0.1"
    )

    @Argument(help: "The path to the document.")
    var input: String
    
    private var printService: PrintService = PrintService()
    mutating func run() throws {
        printService.go(path: input)
    }
    
}

App.main()
