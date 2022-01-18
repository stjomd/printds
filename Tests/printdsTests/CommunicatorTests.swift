//
//  CommunicatorTests.swift
//  printdsTests
//
//  Created by Artem Zhukov on 18.01.22.
//

import XCTest
import PDFKit
@testable import printds

class CommunicatorTests: XCTestCase {
    
    private var identifier: String!
    
    private var printService: MockPrintService!
    private var communicator: Communicator!

    override func setUpWithError() throws {
        let directory = try Shell.exec("pwd")
        print(directory)
        self.identifier = UUID().description
        let fileService = MockFileService(directory: directory, name: identifier)
        self.printService = MockPrintService()
        let documentService = MockDocumentService(mockFileService: fileService)
        self.communicator = Communicator(
            console: MockConsole(),
            fileService: fileService,
            printService: printService,
            documentService: documentService
        )
    }

    override func tearDownWithError() throws {
        try Shell.exec("rm \(identifier!)*.pdf")
        self.communicator = nil
        self.printService = nil
        self.identifier = nil
    }
    
    // MARK: - Tests

    func test_doublesided_shouldPrintTwice_whenOutputIsNil() throws {
        XCTAssertEqual(printService.counter, 0)
        let args = try Arguments(input: "\(identifier!).pdf", output: nil, from: nil, to: nil)
        try communicator.doublesided(args)
        XCTAssertEqual(printService.counter, 2)
    }
    
    func test_doublesided_shouldSaveTwoDocs_whenOutputNotNil() throws {
        let args = try Arguments(input: "\(identifier!).pdf", output: ".", from: nil, to: nil)
        try communicator.doublesided(args)
        XCTAssertEqual(printService.counter, 0)
        let ls = try Shell.exec("ls \(identifier!)*.pdf").split(separator: "\n")
        XCTAssertTrue(ls.contains("\(identifier!)-odd.pdf"))
        XCTAssertTrue(ls.contains("\(identifier!)-even.pdf"))
    }

}
