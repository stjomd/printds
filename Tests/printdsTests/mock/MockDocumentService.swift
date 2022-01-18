//
//  MockDocumentService.swift
//  printdsTest
//
//  Created by Artem Zhukov on 18.01.22.
//

import Foundation
import PDFKit
@testable import printds

class MockDocumentService: DocumentService {
    
    init(mockFileService: MockFileService) {
        super.init(fileService: mockFileService)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    override func document(path: String, from: Int?, to: Int?) throws -> PDFDocument {
        if let from = from, let to = to, from > to {
            throw Exception.because("Invalid parameters (from > to)")
        }
        var lower = from ?? 1
        var upper = to ?? 15
        if (upper < lower) {
            swap(&upper, &lower)
        }
        return doc(size: upper - lower + 1)
    }
    
    override func split(_ document: PDFDocument) -> SplitPDFDocument {
        var size: Int
        if document.pageCount.isMultiple(of: 2) {
            size = document.pageCount / 2
        } else {
            size = 1 + document.pageCount / 2
        }
        if document.pageCount == 1 {
            return SplitPDFDocument(odd: doc(size: size), even: nil)
        } else {
            return SplitPDFDocument(odd: doc(size: size), even: doc(size: size))
        }
    }
    
    // MARK: - Helpers
    
    private func doc(size: Int) -> PDFDocument {
        let pdf = PDFDocument()
        for _ in 0..<size {
            pdf.insert(PDFPage(), at: 0)
        }
        return pdf
    }
    
}
