//
//  TestableFileService.swift
//  printdsTests
//
//  Created by Artem Zhukov on 22.01.22.
//

import Foundation
import PDFKit.PDFDocument
@testable import printds

class TestableFileService: FileService {
    
    private(set) var counter = 0
    
    override func save(_ document: PDFDocument, named name: String, to path: String) throws {
        counter += 1
        try super.save(document, named: name, to: path)
    }
    
}
