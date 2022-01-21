//
//  Communicator.swift
//  printds
//
//  Created by Artem Zhukov on 15.01.22.
//

import Foundation
import PDFKit.PDFDocument

class Communicator: Decodable {
    
    private var console: Console
    private var fileService: FileService
    private var printService: PrintService
    private var documentService: DocumentService
    
    init(console: Console, fileService: FileService, printService: PrintService, documentService: DocumentService) {
        self.console = console
        self.fileService = fileService
        self.printService = printService
        self.documentService = documentService
    }
    
    // MARK: - Public Methods
        
    /// Runs the program in the doublesided mode.
    /// - parameter args: The arguments of the program's run.
    /// - throws: If an error occurs during execution.
    public func doublesided(_ args: Arguments) throws {
        let document = try documentService.document(path: args.input, from: args.from, to: args.to)
        let split = documentService.split(document)
        let noun = (split.pageCount == 1) ? "sheet" : "sheets"
        console.info("You will need \(split.pageCount) \(noun) of paper.")
        // Output
        if let odd = split.odd {
            do {
                try self.output(odd, suffix: "odd", args: args)
            } catch Exception.initiated(let message) {
                console.error(message)
            }
        }
        if let even = split.even {
            if args.output == nil {
                console.info("Turn the printed pages over, and insert them into the paper tray.")
                console.prompt("Press enter to continue.")
            }
            do {
                try self.output(even, suffix: "even", args: args)
            } catch Exception.initiated(let message) {
                console.error(message)
            }
            if args.output != nil {
                console.info("First print the odd pages, then the even ones.")
            }
        }
        // Finish
        let saved = document.pageCount - split.pageCount
        let word = (saved == 1) ? "sheet" : "sheets"
        console.success("Done. You've saved \(saved) \(word) of paper.")
    }
    
    /// Runs the program in the singlesided mode.
    /// - parameter args: The arguments of the program's run.
    /// - throws: If an error occurs during execution.
    public func singlesided(_ args: Arguments) throws {
        let document = try documentService.document(path: args.input, from: args.from, to: args.to)
        let noun = (document.pageCount == 1) ? "sheet" : "sheets"
        console.info("You will need \(document.pageCount) \(noun) of paper.")
        // Output
        do {
            try self.output(document, suffix: "out", args: args)
        } catch Exception.initiated(let message) {
            console.error(message)
            return
        }
        console.success("Done.")
    }
    
    // MARK: - Helpers
    
    /// Either prints or saves the document, depending on the program's arguments.
    /// - parameters:
    ///   - document: The document to be output.
    ///   - suffix: The suffix appended to the document's name when saving.
    ///   - args: The program's arguments.
    /// - throws: An exception is thrown if something went wrong while printing/saving.
    private func output(_ document: PDFDocument, suffix: String, args: Arguments) throws {
        if let output = args.output {
            let name = fileService.name(from: args.input) + ".\(suffix).pdf"
            try fileService.save(document, named: name, to: output)
        } else {
            try printService.print(document)
        }
    }
    
}
