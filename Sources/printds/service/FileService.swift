//
//  FileService.swift
//  
//
//  Created by Artem Zhukov on 16.01.22.
//

import Foundation
import PDFKit

class FileService: Decodable {
    
    /// Checks whether a file specified by a path string exists in the local directory (current directory of the shell), or globally.
    /// - parameter path: The path to the file, a string.
    /// - returns: A URL associated with the file.
    /// - throws: An exception is thrown if the file couldn't be found.
    public func locate(_ path: String) throws -> URL {
        let correctedPath = path.replacingOccurrences(of: "\\ ", with: " ")
        let globalUrl = try self.url(from: "~").appendingPathComponent(correctedPath)
        let localUrl = try self.url(from: FileManager.default.currentDirectoryPath)
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
            document.write(to: directoryUrl.appendingPathComponent(name))
        } else {
            throw Exception.because("The output path \(path) is not a directory.")
        }
    }
    
    /// Retrieves the name of a file or directory from a path string.
    /// - parameter path: The path to the file or directory.
    /// - returns: The name, or an empty string if it couldn't be determined.
    public func name(from path: String) -> String {
        var dotIndex = path.endIndex
        // Attempt to return the name of the file (.../dir/doc.pdf -> doc)
        for i in stride(from: path.count - 1, to: 0, by: -1) {
            let index = path.index(path.startIndex, offsetBy: i)
            if path[index] == "." {
                dotIndex = index
            } else if path[index] == "/" {
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
    
    /// Creates a URL instance from a path string.
    /// - parameter path: The path to a file, a string.
    /// - returns: The URL with the equivalent path.
    /// - throws: An exception is thrown if the URL cannot be constructed.
    private func url(from path: String) throws -> URL {
        guard let url = URL(string: "file://" + path) else {
            throw Exception.because("Invalid path \(path).")
        }
        return url
    }
    
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
    
}
