//
//  Communicator.swift
//  
//
//  Created by Artem Zhukov on 15.01.22.
//

import Foundation

class Communicator: Decodable {
    
    private var documentService: DocumentService = DocumentService()
    private var printService: PrintService = PrintService()
    
    /// Runs the program in the doublesided (standard) mode.
    /// - parameter path: The path to the document to be printed.
    /// - throws: If an error occurs during execution.
    public func doublesided(_ path: String) throws {
        let document = try documentService.document(path: path)
        let split = documentService.split(document)
        
        print("You will need \(split.pageCount) sheets of paper.")
        
        try printService.print(split.odd)
        
        print("Once the printing is done, turn the pages over and insert them into the printer's paper tray.")
        print("Press enter to continue.")
        _ = readLine()
        
        try printService.print(split.even)
        
        print("Done.")
    }
    
}
