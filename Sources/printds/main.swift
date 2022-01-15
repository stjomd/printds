//
//  main.swift
//
//
//  Created by Artem Zhukov on 14.01.22.
//

import ArgumentParser
import PDFKit

struct App: ParsableCommand {
    
    static var configuration = CommandConfiguration(
        commandName: "printds",
        abstract: "Print double sided documents manually with ease.",
        version: "0.0.1"
    )

    @Argument(help: "The path to the document.")
    var input: String
    
    private var documentService: DocumentService = DocumentService()
    private var printService: PrintService = PrintService()
    mutating func run() throws {
        do {
            let url = try documentService.url(from: input)
            let document = PDFDocument(url: url)!
            let split = documentService.split(document)
            try printService.print(split.odd)
            try printService.print(split.even)
        } catch Exception.exception(let message) {
            print("Errorx: \(message)")
        }
    }
    
}

App.main()
