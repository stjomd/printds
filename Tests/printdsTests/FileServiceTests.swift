//
//  FileServiceTests.swift
//  printdsTests
//
//  Created by Artem Zhukov on 18.01.22.
//

import XCTest
import PDFKit
@testable import printds

final class FileServiceTests: XCTestCase {
    
    private var directory: String!
    private var identifier: String!
    
    private var fileService: FileService!
    
    override func setUpWithError() throws {
        self.directory = try Shell.exec("pwd")
        self.identifier = UUID().description
        self.fileService = FileService()
        try Shell.exec("touch \(identifier!).pdf")
    }

    override func tearDownWithError() throws {
        try Shell.exec("rm \(identifier!)*.pdf")
        self.directory = nil
        self.identifier = nil
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
        try Shell.exec("touch x.pdf")
        XCTAssertThrowsError(try fileService.save(PDFDocument(), named: "file.pdf", to: "x.pdf"))
        try Shell.exec("rm x.pdf")
    }
    
    func test_name_shouldAlwaysReturnName() throws {
        XCTAssertEqual(fileService.name(from: "hello.pdf"), "hello")
        XCTAssertEqual(fileService.name(from: "dir/document.pdf"), "document")
        XCTAssertEqual(fileService.name(from: "./folder/image.png"), "image")
        XCTAssertEqual(fileService.name(from: "../ordner/song.mp3"), "song")
        XCTAssertEqual(fileService.name(from: "~/Desktop/Folder/presentation.pdf"), "presentation")
        XCTAssertEqual(fileService.name(from: "something"), "something")
        XCTAssertEqual(fileService.name(from: ""), "")
    }
    
}
