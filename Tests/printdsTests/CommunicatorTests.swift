//
//  CommunicatorTests.swift
//  printdsTests
//
//  Created by Artem Zhukov on 18.01.22.
//

import XCTest
import PDFKit.PDFDocument
@testable import printds

class CommunicatorTests: XCTestCase {
    
    // Integration tests
    
    private var directory: String!
    private var identifier: String!
    
    private var console: TestableConsole!
    private var fileService: TestableFileService!
    private var printService: MockPrintService!
    private var communicator: Communicator!

    override func setUpWithError() throws {
        self.directory = try Shell.exec("pwd")
        self.identifier = UUID().description
        self.console = TestableConsole()
        self.fileService = TestableFileService(console: self.console)
        self.printService = MockPrintService() // doesn't open the print panel, but increments a counter
        self.communicator = Communicator(
            console: self.console,
            fileService: self.fileService,
            printService: self.printService,
            documentService: DocumentService(fileService: self.fileService)
        )
        // Create a document
        MockDocumentService.mockDocument(size: 5)
            .write(to: URL(fileURLWithPath: directory).appendingPathComponent("\(identifier!).pdf"))
    }

    override func tearDownWithError() throws {
        try Shell.exec("rm \(identifier!)*.pdf")
        self.communicator = nil
        self.printService = nil
        self.identifier = nil
        self.directory = nil
    }
    
    // MARK: - Tests

    func test_doublesided_shouldPrintTwice_whenOutputIsNil() throws {
        XCTAssertEqual(printService.counter, 0)
        XCTAssertEqual(fileService.counter, 0)
        let args = try Arguments(input: "\(directory!)/\(identifier!).pdf", output: nil, from: nil, to: nil)
        try communicator.doublesided(args)
        XCTAssertEqual(printService.counter, 2)
        XCTAssertEqual(fileService.counter, 0)
    }
    
    func test_doublesided_shouldPrintOnce_whenOnlyOnePage() throws {
        XCTAssertEqual(printService.counter, 0)
        XCTAssertEqual(fileService.counter, 0)
        let args = try Arguments(input: "\(identifier!).pdf", output: nil, from: 2, to: 2)
        try communicator.doublesided(args)
        XCTAssertEqual(printService.counter, 1)
        XCTAssertEqual(fileService.counter, 0)
    }
    
    func test_doublesided_shouldSaveTwoDocs_whenOutputNotNil() throws {
        XCTAssertEqual(printService.counter, 0)
        XCTAssertEqual(fileService.counter, 0)
        let args = try Arguments(input: "\(directory!)/\(identifier!).pdf", output: ".", from: nil, to: nil)
        try communicator.doublesided(args)
        XCTAssertEqual(printService.counter, 0)
        XCTAssertEqual(fileService.counter, 2)
        let ls = try Shell.exec("ls \(identifier!)*.pdf").split(separator: "\n")
        XCTAssertTrue(ls.contains("\(identifier!).odd.pdf"))
        XCTAssertTrue(ls.contains("\(identifier!).even.pdf"))
    }
    
    func test_doublesided_shouldSaveOneDoc_whenOutputNotNilAndOnlyOnePage() throws {
        XCTAssertEqual(printService.counter, 0)
        XCTAssertEqual(fileService.counter, 0)
        let args = try Arguments(input: "\(identifier!).pdf", output: ".", from: 3, to: 3)
        try communicator.doublesided(args)
        XCTAssertEqual(printService.counter, 0)
        XCTAssertEqual(fileService.counter, 1)
        let ls = try Shell.exec("ls \(identifier!)*.pdf").split(separator: "\n")
        XCTAssertTrue(ls.contains("\(identifier!).odd.pdf"))
        XCTAssertFalse(ls.contains("\(identifier!).even.pdf"))
    }
    
    func test_doublesided_shouldNotThrow_whenDeclinedToOverwrite() throws {
        XCTAssertEqual(fileService.counter, 0)
        try fileService.save(PDFDocument(), named: "\(identifier!).odd.pdf", to: ".")
        try fileService.save(PDFDocument(), named: "\(identifier!).even.pdf", to: ".")
        XCTAssertEqual(fileService.counter, 2)
        // Test if throws
        XCTAssertEqual(printService.counter, 0)
        XCTAssertEqual(fileService.counter, 2)
        let args = try Arguments(input: "\(identifier!).pdf", output: ".", from: nil, to: nil)
        console.response = "n"
        XCTAssertNoThrow(try communicator.doublesided(args))
        XCTAssertEqual(printService.counter, 0)
        XCTAssertEqual(fileService.counter, 4)
    }
    
    func test_singlessided_shouldPrintOnce_whenOutputIsNil() throws {
        XCTAssertEqual(printService.counter, 0)
        XCTAssertEqual(fileService.counter, 0)
        let args = try Arguments(input: "\(directory!)/\(identifier!).pdf", output: nil, from: nil, to: nil)
        try communicator.singlesided(args)
        XCTAssertEqual(printService.counter, 1)
        XCTAssertEqual(fileService.counter, 0)
    }
    
    func test_singlessided_shouldSaveOneDoc_whenOutputNotNil() throws {
        XCTAssertEqual(printService.counter, 0)
        XCTAssertEqual(fileService.counter, 0)
        let args = try Arguments(input: "\(identifier!).pdf", output: ".", from: nil, to: nil)
        try communicator.singlesided(args)
        XCTAssertEqual(printService.counter, 0)
        XCTAssertEqual(fileService.counter, 1)
        let ls = try Shell.exec("ls \(identifier!)*.pdf").split(separator: "\n")
        XCTAssertTrue(ls.contains("\(identifier!).out.pdf"))
    }
    
    func test_singlesided_shouldNotThrow_whenDeclinedToOverwrite() throws {
        XCTAssertEqual(fileService.counter, 0)
        try fileService.save(PDFDocument(), named: "\(identifier!).out.pdf", to: ".")
        XCTAssertEqual(fileService.counter, 1)
        // Check if throws
        XCTAssertEqual(printService.counter, 0)
        XCTAssertEqual(fileService.counter, 1)
        let args = try Arguments(input: "\(identifier!).pdf", output: ".", from: nil, to: nil)
        console.response = "n"
        XCTAssertNoThrow(try communicator.singlesided(args))
        XCTAssertEqual(printService.counter, 0)
        XCTAssertEqual(fileService.counter, 2)
    }

}
