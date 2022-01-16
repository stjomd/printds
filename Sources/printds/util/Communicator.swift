//
//  Communicator.swift
//  
//
//  Created by Artem Zhukov on 15.01.22.
//

import Foundation

class Communicator: Decodable {
    
    private var console: Console
    private var fileService: FileService
    private var printService: PrintService
    private var documentService: DocumentService
    
    init(console: Console) {
        self.console = console
        self.fileService = FileService()
        self.printService = PrintService()
        self.documentService = DocumentService(fileService: fileService)
    }
    
    // MARK: - Execution modes
    
    /// Runs the program in the doublesided mode.
    /// - parameter path: The path to the document to be printed.
    /// - throws: If an error occurs during execution.
    public func doublesided(input: String, output: String?) throws {
        // Build documents
        let document = try documentService.document(path: input)
        let split = documentService.split(document)
        let noun = (split.pageCount == 1) ? "sheet" : "sheets"
        console.info("You will need \(split.pageCount) \(noun) of paper.")
        // Start printing/saving
        if let output = output {
            try fileService.save(split.odd, named: "x-odd.pdf", to: output)
            try fileService.save(split.even, named: "x-even.pdf", to: output)
            console.info("First print the odd pages, then the even ones.")
        } else {
            try printService.print(split.odd)
            console.info("Turn the printed pages over, and insert them into the paper tray.")
            console.prompt("Press enter to continue.")
            try printService.print(split.even)
        }
        // Finish
        let saved = document.pageCount - split.pageCount
        let word = (saved == 1) ? "sheet" : "sheets"
        console.success("Done. You've saved \(saved) \(word) of paper.")
    }
    
    /// Runs the program in the singlesided mode.
    /// - parameter path: The path to the document to be printed.
    /// - throws: If an error occurs during execution.
    public func singlesided(input: String, output: String?) throws {
        let document = try documentService.document(path: input)
        console.info("You will need \(document.pageCount) sheet\(document.pageCount == 1 ? "" : "s") of paper.")
        try printService.print(document)
        console.success("Done.")
    }
    
}