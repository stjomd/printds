//
//  DocumentService.swift
//  printds
//
//  Created by Artem Zhukov on 15.01.22.
//

import Foundation
import PDFKit

class DocumentService: Decodable {
    
    private var fileService: FileService
    
    init(fileService: FileService) {
        self.fileService = fileService
    }
    
    // MARK: - Public methods
        
    /// Loads a PDF document from a specified path.
    /// - parameters:
    ///   - path: The path to the document.
    ///   - from: The page to be treated as the first.
    ///   - to:   The page to be treates as the last.
    /// - returns: A PDFDocument instance.
    /// - throws: An exception is thrown if the document couldn't be loaded (invalid path, nonexistent file, etc.), or if the range is invalid (out of bounds).
    public func document(path: String, from: Int?, to: Int?) throws -> PDFDocument {
        let url = try fileService.locate(path)
        guard let document = PDFDocument(url: url) else {
            throw Exception.because("Couldn't open the document at \(path).")
        }
        try cut(document, from: from, to: to)
        return document
    }
    
    /// Splits a PDF document into two, ready for double-sided printing.
    /// - parameter document: The PDF document to be split.
    /// - returns: A SplitPDFDocument instance.
    public func split(_ document: PDFDocument) -> SplitPDFDocument {
        let docs = (PDFDocument(), PDFDocument())
        let count = document.pageCount
        let shift = count.isMultiple(of: 2) ? 0 : 1
        // Insert a blank page for the even pages document
        if (!count.isMultiple(of: 2)) {
            docs.1.insert(PDFPage(), at: 0)
        }
        // Distribute the pages of the original document
        for i in stride(from: 0, to: count, by: 1) {
            if i.isMultiple(of: 2) {
                docs.0.insert(document.page(at: i)!, at: docs.0.pageCount)
            } else {
                docs.1.insert(document.page(at: count - shift - i)!, at: docs.1.pageCount)
            }
        }
        if document.pageCount == 1 {
            return SplitPDFDocument(odd: docs.0, even: nil)
        } else {
            return SplitPDFDocument(odd: docs.0, even: docs.1)
        }
    }
    
    // MARK: - Helpers
    
    /// Removes pages from the document that lie outside the specified range.
    /// - parameters:
    ///   - document: The document to be processed.
    ///   - from:     The number of the future first page.
    ///   - to:       The number of the future last page.
    /// - throws: An exception is thrown if the parameters `from` and/or `to` lie outside the bounds (1 to page count).
    private func cut(_ document: PDFDocument, from: Int?, to: Int?) throws {
        // Validate
        var (lowerBound, upperBound) = (1, document.pageCount)
        if let from = from {
            lowerBound = from
        }
        if let to = to {
            upperBound = to
        }
        if lowerBound < 1 || lowerBound > document.pageCount {
            throw Exception.because("The value of option 'from' (\(lowerBound)) is out of bounds.")
        } else if upperBound < 1 || upperBound > document.pageCount {
            throw Exception.because("The value of option 'to' (\(upperBound)) is out of bounds.")
        }
        // Cut document
        while (document.pageCount > upperBound) {
            document.removePage(at: document.pageCount - 1)
        }
        for _ in 0..<(lowerBound-1) {
            document.removePage(at: 0)
        }
    }
    
}
