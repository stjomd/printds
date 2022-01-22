//
//  DocumentServiceTests.swift
//  printdsTests
//
//  Created by Artem Zhukov on 18.01.22.
//

import XCTest
import PDFKit.PDFDocument
@testable import printds

class DocumentServiceTests: XCTestCase {
    
    private var identifier: String!
    private var documentOdd: PDFDocument!
    private var documentEven: PDFDocument!
    
    private var documentService: DocumentService!
    
    override func setUpWithError() throws {
        let directory = try Shell.exec("pwd")
        self.identifier = UUID().description
        let fileService = MockFileService(directory: directory, name: identifier)
        self.documentService = DocumentService(fileService: fileService)
        // Save a document
        self.documentOdd = MockDocumentService.mockDocument(size: 5)
        self.documentOdd.write(to: URL(fileURLWithPath: directory).appendingPathComponent("\(identifier!).odd.pdf"))
        self.documentEven = MockDocumentService.mockDocument(size: 8)
        self.documentEven.write(to: URL(fileURLWithPath: directory).appendingPathComponent("\(identifier!).even.pdf"))
    }

    override func tearDownWithError() throws {
        try Shell.exec("rm \(identifier!)*.pdf")
        self.documentOdd = nil
        self.documentEven = nil
        self.identifier = nil
    }
    
    // MARK: - Tests

    func test_document_shouldLoadFullDocument_whenFromAndToAreNil() throws {
        let docOdd = try documentService.document(path: "\(identifier!).odd.pdf", from: nil, to: nil)
        XCTAssertEqual(docOdd.pageCount, self.documentOdd.pageCount)
        let docEven = try documentService.document(path: "\(identifier!).even.pdf", from: nil, to: nil)
        XCTAssertEqual(docEven.pageCount, self.documentEven.pageCount)
    }
    
    func test_document_shouldLoadCutDocument_whenFromNotNilAndToIsNil() throws {
        let pages = 3
        let index = documentOdd.pageCount - (pages - 1)
        let document = try documentService.document(path: "\(identifier!).odd.pdf", from: index, to: nil)
        XCTAssertEqual(document.pageCount, pages)
    }
    
    func test_document_shouldLoadCutDocument_whenFromIsNilAndToNotNil() throws {
        let index = 2
        let document = try documentService.document(path: "\(identifier!).odd.pdf", from: nil, to: index)
        XCTAssertEqual(document.pageCount, index)
    }
    
    func test_document_shouldLoadCutDocument_whenFromNotNilAndToNotNil() throws {
        let range = 2...4
        let document = try documentService.document(
            path: "\(identifier!).odd.pdf",
            from: range.lowerBound,
            to: range.upperBound
        )
        XCTAssertEqual(document.pageCount, range.count)
    }
    
    func test_document_shouldLoadFullDocument_whenFromNotNilAndToNotNilAndFullRange() throws {
        let range = 1...documentOdd.pageCount
        let document = try documentService.document(
            path: "\(identifier!).odd.pdf",
            from: range.lowerBound,
            to: range.upperBound
        )
        XCTAssertEqual(document.pageCount, self.documentOdd.pageCount)
    }
    
    func test_split_shouldReturnSplitDocsOfSameLength_whenDocOfOddLength() throws {
        let split = documentService.split(documentOdd)
        let oddCount = 1 + (self.documentOdd.pageCount / 2)
        XCTAssertEqual(split.pageCount, oddCount)
        XCTAssertEqual(split.odd!.pageCount, oddCount)
        XCTAssertEqual(split.even!.pageCount, self.documentOdd.pageCount - oddCount + 1) // adds a blank page
    }
    
    func test_split_shouldReturnSplitDocsOfSameLength_whenDocOfEvenLength() throws {
        let split = documentService.split(documentEven)
        let evenCount = self.documentEven.pageCount / 2
        XCTAssertEqual(split.pageCount, evenCount)
        XCTAssertEqual(split.odd!.pageCount, evenCount)
        XCTAssertEqual(split.even!.pageCount, evenCount)
    }

}
