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
    
    public func doublesided(_ path: String) throws {
        let document = try documentService.document(path: path)
        let split = documentService.split(document)
        try printService.print(split.odd)
        try printService.print(split.even)
    }
    
}
