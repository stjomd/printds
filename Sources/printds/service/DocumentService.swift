//
//  DocumentService.swift
//  
//
//  Created by Artem Zhukov on 15.01.22.
//

import Foundation
import PDFKit

class DocumentService: Decodable {
    
    /// Loads a PDF document from a specifie path.
    /// - parameter path: The path to the document.
    /// - returns: A PDFDocument instance.
    /// - throws: An exception is thrown if the document couldn't be loaded (invalid path, nonexistent file, etc.)
    public func document(path: String) throws -> PDFDocument {
        let url = try self.url(from: path)
        guard let document = PDFDocument(url: url) else {
            throw Exception.exception("Couldn't open the document")
        }
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
        return SplitPDFDocument(odd: docs.0, even: docs.1)
    }
    
    /// Creates a URL instance from a path string.
    /// - parameter path: The path to a file, a string.
    /// - returns: The URL with the equivalent path.
    /// - throws: An exception is thrown if the URL cannot be constructed.
    private func url(from path: String) throws -> URL {
        guard let url = URL(string: "file://" + path) else {
            throw Exception.exception("Invalid file path")
        }
        return url
    }
    
}
