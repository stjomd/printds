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
    
    /// Runs the program in the doublesided (standard) mode.
    /// - parameter path: The path to the document to be printed.
    /// - throws: If an error occurs during execution.
    public func doublesided(_ path: String) throws {
        console.log("Processing...")
        
        let document = try documentService.document(path: path)
        let split = documentService.split(document)
        
        console.info("You will need \(split.pageCount) sheet\(split.pageCount == 1 ? "s" : "") of paper.")
        
        try printService.print(split.odd)
        
        console.info("Turn the printed pages over, and insert them into the paper tray.")
        console.prompt("Press enter to continue.")
        
        try printService.print(split.even)
        
        console.success("Done.")
    }
    
}
