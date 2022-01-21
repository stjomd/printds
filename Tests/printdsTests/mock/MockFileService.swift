//
//  MockFileService.swift
//  printdsTests
//
//  Created by Artem Zhukov on 18.01.22.
//

import Foundation
import PDFKit
@testable import printds

class MockFileService: FileService {
    
    private let directory: String
    private let name: String
    
    init(directory: String, name: String) {
        self.directory = directory
        self.name = name
        super.init(console: MockConsole())
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    override func locate(_ path: String) throws -> URL {
        return URL(fileURLWithPath: "\(directory)/\(path)")
    }
    
    override func save(_ document: PDFDocument, named name: String, to path: String) throws {
        let directoryUrl = URL(fileURLWithPath: path)
        document.write(to: directoryUrl.appendingPathComponent(name))
    }
    
    override func name(from path: String) -> String {
        let from = path.lastIndex(of: "/")
        let to = path.lastIndex(of: ".")
        if let from = from {
            let begin = path.index(from, offsetBy: 1)
            if let to = to {
                return String(path[begin..<to])
            } else {
                return String(path[begin...])
            }
        } else {
            if let to = to {
                return String(path[..<to])
            } else {
                return path
            }
        }
    }
    
}
