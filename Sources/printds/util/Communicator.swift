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
    
    init(console: Console,
         fileService: FileService, printService: PrintService, documentService: DocumentService) {
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
        // Build documents
        let document = try documentService.document(path: args.input, from: args.from, to: args.to)
        let split = documentService.split(document)
        let noun = (split.pageCount == 1) ? "sheet" : "sheets"
        console.info("You will need \(split.pageCount) \(noun) of paper.")
        // Start printing/saving
        if let output = args.output {
            let name = fileService.name(from: args.input)
            let (oddName, evenName) = ("\(name)-odd.pdf", "\(name)-even.pdf")
            try fileService.save(split.odd, named: oddName, to: output)
            try fileService.save(split.even, named: evenName, to: output)
            console.info("First print \(oddName), then \(evenName).")
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
    /// - parameter args: The arguments of the program's run.
    /// - throws: If an error occurs during execution.
    public func singlesided(_ args: Arguments) throws {
        let document = try documentService.document(path: args.input, from: args.from, to: args.to)
        let noun = (document.pageCount == 1) ? "sheet" : "sheets"
        console.info("You will need \(document.pageCount) \(noun) of paper.")
        if let output = args.output {
            let name = fileService.name(from: args.input)
            try fileService.save(document, named: "\(name)-out.pdf", to: output)
        } else {
            try printService.print(document)
        }
        console.success("Done.")
    }
    
}
