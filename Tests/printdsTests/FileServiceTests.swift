//
//  FileServiceTests.swift
//  printdsTests
//
//  Created by Artem Zhukov on 18.01.22.
//

import XCTest
import PDFKit.PDFDocument
@testable import printds

final class FileServiceTests: XCTestCase {
    
    private var directory: String!
    private var identifier: String!
    
    private var console: TestableConsole!
    private var fileService: FileService!
    
    override func setUpWithError() throws {
        self.directory = try Shell.exec("pwd")
        self.identifier = UUID().description
        self.console = TestableConsole()
        self.fileService = FileService(console: self.console)
        try Shell.exec("touch \(identifier!).pdf")
    }

    override func tearDownWithError() throws {
        try Shell.exec("rm \(identifier!)*.pdf")
        self.directory = nil
        self.identifier = nil
        self.console = nil
        self.fileService = nil
    }
    
    // MARK: - Tests
    
    func test_locate_shouldLocate_whenPathIsLocal() throws {
        if let directory = directory, let identifier = identifier {
            // "identifier.pdf" is a local path
            let url = URL(fileURLWithPath: "\(directory)/\(identifier).pdf")
            XCTAssertEqual(try fileService.locate("\(identifier).pdf"), url)
        } else {
            XCTFail("Set up failed – no directory and/or identifier present")
        }
    }
    
    func test_locate_shouldLocate_whenPathIsGlobal() throws {
        if let directory = directory, let identifier = identifier {
            // "path/identifier.pdf" is a global path
            let path = "\(directory)/\(identifier).pdf"
            let url = URL(fileURLWithPath: "\(directory)/\(identifier).pdf")
            XCTAssertEqual(try fileService.locate(path), url)
        } else {
            XCTFail("Set up failed – no directory and/or identifier present")
        }
    }
    
    func test_locate_shouldThrow_whenPathDoesNotExist() throws {
        if let identifier = identifier {
            // "identifier-x.pdf" is a non-existent path
            XCTAssertThrowsError(try fileService.locate("\(identifier)-x.pdf"))
        } else {
            XCTFail("Set up failed – no identifier present")
        }
    }
    
    func test_save_shouldSave_whenToDirectory() throws {
        // Save an empty PDF document
        let fileName = "\(identifier!)-save.pdf"
        try fileService.save(PDFDocument(), named: fileName, to: directory)
        XCTAssertEqual(try Shell.exec("ls \(fileName)"), fileName)
        // Restore - remove document
        try Shell.exec("rm \(fileName)")
        let ls = try Shell.exec("ls \(fileName)")
        XCTAssertEqual(ls.split(separator: ":").last, " No such file or directory")
    }
    
    func test_save_shouldThrow_whenNotToDirectory() throws {
        try Shell.exec("touch \(identifier!)-x.pdf")
        XCTAssertThrowsError(try fileService.save(PDFDocument(), named: "file.pdf", to: "\(identifier!)-x.pdf"))
        try Shell.exec("rm \(identifier!)-x.pdf")
    }
    
    func test_save_shouldThrow_whenDeclinedToOverwrite() throws {
        let fileName = "\(identifier!)-y.pdf"
        XCTAssertNoThrow(try fileService.save(PDFDocument(), named: fileName, to: directory!))
        self.console.response = "no"
        XCTAssertThrowsError(try fileService.save(PDFDocument(), named: fileName, to: directory!))
        try Shell.exec("rm \(fileName)")
    }
    
    func test_save_shouldNotThrow_whenAgreedToOverwrite() throws {
        let fileName = "\(identifier!)-y.pdf"
        XCTAssertNoThrow(try fileService.save(PDFDocument(), named: fileName, to: directory!))
        self.console.response = "yes"
        XCTAssertNoThrow(try fileService.save(PDFDocument(), named: fileName, to: directory!))
        try Shell.exec("rm \(fileName)")
    }
    
    func test_name_shouldAlwaysReturnName() throws {
        XCTAssertEqual(fileService.name(from: "hello.pdf"), "hello")
        XCTAssertEqual(fileService.name(from: "hello.out.pdf"), "hello.out")
        XCTAssertEqual(fileService.name(from: "dir/document.pdf"), "document")
        XCTAssertEqual(fileService.name(from: "./folder/image.image.png"), "image.image")
        XCTAssertEqual(fileService.name(from: "../ordner/song.mp3"), "song")
        XCTAssertEqual(fileService.name(from: "~/Desktop/Folder/presentation.ppt.pdf"), "presentation.ppt")
        XCTAssertEqual(fileService.name(from: "something"), "something")
        XCTAssertEqual(fileService.name(from: ""), "")
    }
    
}
