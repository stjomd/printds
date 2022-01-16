//
//  FileService.swift
//  
//
//  Created by Artem Zhukov on 16.01.22.
//

import Foundation

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
            throw Exception.exception("File not found")
        }
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
