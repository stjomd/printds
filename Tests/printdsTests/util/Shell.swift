//
//  Shell.swift
//  printdsTests
//
//  Created by Artem Zhukov on 18.01.22.
//

import Foundation

class Shell {
    // Courtesy of https://stackoverflow.com/a/50035059
    @discardableResult
    static func exec(_ command: String) throws -> String {
        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.arguments = ["-c", command]
        // Run
        try task.run()
        // Get output
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        var output = String(data: data, encoding: .utf8)!
        if let last = output.last, last == "\n" {
            output.removeLast()
        }
        return output
    }
}
