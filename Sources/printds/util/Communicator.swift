//
//  Communicator.swift
//  
//
//  Created by Artem Zhukov on 15.01.22.
//

import Foundation

class Communicator: Decodable {
    
    private var console: Console
    private var documentService: DocumentService = DocumentService()
    private var printService: PrintService = PrintService()
    
    init(console: Console) {
        self.console = console
    }
    
    // MARK: - Execution modes
    
    /// Runs the program in the doublesided mode.
    /// - parameter path: The path to the document to be printed.
    /// - throws: If an error occurs during execution.
    public func doublesided(_ path: String) throws {
        // Build documents
        let document = try documentService.document(path: path)
        let split = documentService.split(document)
        let noun = (split.pageCount == 1) ? "sheet" : "sheets"
        console.info("You will need \(split.pageCount) \(noun) of paper.")
        // Start printing
        try printService.print(split.odd)
        console.info("Turn the printed pages over, and insert them into the paper tray.")
        console.prompt("Press enter to continue.")
        try printService.print(split.even)
        // Finish
        let saved = document.pageCount - split.pageCount
        let word = (saved == 1) ? "sheet" : "sheets"
        console.success("Done. You've saved \(saved) \(word) of paper.")
    }
    
    /// Runs the program in the singlesided mode.
    /// - parameter path: The path to the document to be printed.
    /// - throws: If an error occurs during execution.
    public func singlesided(_ path: String) throws {
        let document = try documentService.document(path: path)
        console.info("You will need \(document.pageCount) sheet\(document.pageCount == 1 ? "" : "s") of paper.")
        try printService.print(document)
        console.success("Done.")
    }
    
}
