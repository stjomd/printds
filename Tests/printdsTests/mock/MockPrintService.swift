//
//  MockPrintService.swift
//  printdsTests
//
//  Created by Artem Zhukov on 18.01.22.
//

import Foundation
import PDFKit.PDFDocument
@testable import printds

class MockPrintService: PrintService {
    
    private(set) var counter = 0
    
    override func print(_ document: PDFDocument) throws {
        counter += 1
    }
    
}
