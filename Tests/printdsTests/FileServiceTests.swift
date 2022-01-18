//
//  FileServiceTests.swift
//  printds
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
        self.directory = shell("pwd")
        self.identifier = UUID().description
        self.fileService = FileService()
        shell("touch", "\(identifier!).pdf")
    }

    override func tearDownWithError() throws {
        shell("rm", "\(identifier!).pdf")
        self.directory = nil
        self.identifier = nil
        self.fileService = nil
    }
    
    // MARK: - Tests
    
    func testLocateLocal() throws {
        if let directory = directory, let identifier = identifier {
            let url = URL(string: "file://\(directory)/\(identifier).pdf")!
            XCTAssertEqual(try fileService.locate("\(identifier).pdf"), url)
        } else {
            XCTFail("Set up failed – no directory and/or identifier present")
        }
    }
    
    func testLocateGlobal() throws {
        if let directory = directory, let identifier = identifier {
            let path = "\(directory)/\(identifier).pdf"
            let url = URL(string: "file://\(directory)/\(identifier).pdf")!
            XCTAssertEqual(try fileService.locate(path), url)
        } else {
            XCTFail("Set up failed – no directory and/or identifier present")
        }
    }
    
    func testSave() throws {
        let fileName = "\(identifier!)-save.pdf"
        try fileService.save(PDFDocument(), named: fileName, to: directory)
        XCTAssertEqual(shell("ls", fileName), fileName)
        shell("rm", fileName)
        XCTAssertNotEqual(shell("ls", fileName), fileName)
    }
    
    func testName() throws {
        XCTAssertEqual(fileService.name(from: "hello.pdf"), "hello")
        XCTAssertEqual(fileService.name(from: "dir/document.pdf"), "document")
        XCTAssertEqual(fileService.name(from: "./folder/image.png"), "image")
        XCTAssertEqual(fileService.name(from: "../ordner/song.mp3"), "song")
        XCTAssertEqual(fileService.name(from: "~/Desktop/Folder/presentation.pdf"), "presentation")
        XCTAssertEqual(fileService.name(from: "something"), "something")
        XCTAssertEqual(fileService.name(from: ""), "")
    }
    
    // MARK: - Helpers
    
    @discardableResult
    private func shell(_ args: String...) -> String {
        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        // Get output
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        var output = String(data: data, encoding: .utf8)!
        if let last = output.last, last == "\n" {
            output.removeLast()
        }
        return output
    }
    
}
