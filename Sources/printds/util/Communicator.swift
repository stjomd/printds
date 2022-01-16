//
//  Communicator.swift
//  
//
//  Created by Artem Zhukov on 15.01.22.
//

import Foundation

class Communicator: Decodable {
    
    @Injected private var console: Console!
    @Injected private var fileService: FileService!
    @Injected private var printService: PrintService!
    @Injected private var documentService: DocumentService!
    
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
            let name = self.name(from: input)
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
    /// - parameter path: The path to the document to be printed.
    /// - throws: If an error occurs during execution.
    public func singlesided(input: String, output: String?) throws {
        let document = try documentService.document(path: input)
        console.info("You will need \(document.pageCount) sheet\(document.pageCount == 1 ? "" : "s") of paper.")
        if let output = output {
            let name = self.name(from: input)
            try fileService.save(document, named: "\(name)-out.pdf", to: output)
        } else {
            try printService.print(document)
        }
        console.success("Done.")
    }
    
    // MARK: - Helpers
    
    private func name(from path: String) -> String {
        var dotIndex = path.endIndex
        for i in stride(from: path.count - 1, to: 0, by: -1) {
            let index = path.index(path.startIndex, offsetBy: i)
            if path[index] == "." {
                dotIndex = index
            } else if path[index] == "/" {
                let cutIndex = path.index(index, offsetBy: 1)
                return String(path[cutIndex..<dotIndex])
            }
        }
        return ""
    }
    
}
