//
//  FileService.swift
//  printds
//
//  Created by Artem Zhukov on 16.01.22.
//

import Foundation
import PDFKit

/// An object that communicates with the file system.
class FileService: Decodable {
    
    private var console: Console
    
    init(console: Console) {
        self.console = console
    }
    
    // MARK: - Public Methods
    
    /// Checks whether a file specified by a path string exists in the local directory (current directory of the shell), or globally.
    /// - parameter path: The path to the file, a string.
    /// - returns: A URL associated with the file.
    /// - throws: An exception is thrown if the file couldn't be found.
    public func locate(_ path: String) throws -> URL {
        let correctedPath = path.replacingOccurrences(of: "\\ ", with: " ")
        let globalUrl = URL(fileURLWithPath: correctedPath)
        let localUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            .appendingPathComponent(correctedPath)
        if FileManager.default.fileExists(atPath: localUrl.path) {
            return localUrl
        } else if FileManager.default.fileExists(atPath: globalUrl.path) {
            return globalUrl
        } else {
            throw Exception.because("The path \(path) doesn't exist.")
        }
    }
    
    /// Writes a document to the disk.
    /// - parameters:
    ///   - document: The document to be saved.
    ///   - name: The name of the document.
    ///   - path: The path (a directory) where the document should be saved.
    /// - throws: An exception is thrown if the path couldn't be found, or if the path is not a directory.
    public func save(_ document: PDFDocument, named name: String, to path: String) throws {
        let directoryUrl = try self.locate(path)
        if try self.isDirectory(at: directoryUrl) {
            try self.check(fileWithName: name, overwritesIn: directoryUrl)
            document.write(to: directoryUrl.appendingPathComponent(name))
        } else {
            throw Exception.because("The output path \(path) is not a directory.")
        }
    }
    
    /// Retrieves the name of a file or directory from a path string.
    /// - parameter path: The path to the file or directory.
    /// - returns: The name, or an empty string if it couldn't be determined.
    public func name(from path: String) -> String {
        let dotIndex = path.lastIndex(of: ".") ?? path.endIndex
        // Attempt to return the name of the file (.../dir/doc.pdf -> doc)
        for i in stride(from: path.count - 1, to: 0, by: -1) {
            let index = path.index(path.startIndex, offsetBy: i)
            if path[index] == "/" {
                let cutIndex = path.index(index, offsetBy: 1)
                return String(path[cutIndex..<dotIndex])
            }
        }
        // No slashes in the string: (doc.pdf -> doc) or (doc -> doc)
        if dotIndex != path.endIndex {
            return String(path[..<dotIndex])
        } else {
            return path
        }
    }
    
    // MARK: - Helpers
    
    /// Checks whether the path specidied by a URL is a directory.
    /// - parameter url: The URL to be checked.
    /// - returns: `true` if the path is a directory, and `false` otherwise.
    /// - throws: An exception is thrown if the check couldn't be performed.
    private func isDirectory(at url: URL) throws -> Bool {
        if let check = try url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory {
            return check
        } else {
            throw Exception.because("Couldn't check whether the path \(url.path) is a directory.")
        }
    }
    
    /// Checks whether saving the file would overwrite an existing one; and prompts the user whether the file should be overwritten in this case.
    /// If the user agreed, the method simply returns.
    /// - parameters:
    ///   - name: The name of the future file.
    ///   - url: The URL of the directory where the file will be saved.
    /// - throws: If the response didn't indicate that the overwrite should be performed, or if EOF was reached.
    private func check(fileWithName name: String, overwritesIn url: URL) throws {
        if FileManager.default.fileExists(atPath: url.appendingPathComponent(name).path) {
            let response = console.prompt("The file with the name \(name) already exists. Overwrite? [y/n] ")
            if let response = response?.lowercased() {
                if response.starts(with: "y") {
                    return
                } else {
                    throw Exception.initiated("Declined to save \(name).")
                }
            } else {
                throw Exception.because("Did not receive an answer to the prompt.")
            }
        }
    }
    
}
