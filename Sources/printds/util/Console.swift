//
//  Console.swift
//  
//
//  Created by Artem Zhukov on 16.01.22.
//

import Foundation

class Console: Decodable {
    
    private enum Style: String {
        case red = "\u{001B}[0;31m"
        case green = "\u{001B}[0;32m"
        case magenta = "\u{001B}[0;35m"
        case cyan = "\u{001B}[0;36m"
        case reset = "\u{001B}[0m"
    }
    
    /// Print a message to the console.
    /// - parameter message: The message to be printed.
    func log(_ message: String) {
        print(message)
    }
    
    /// Print a success message (in green) to the console.
    /// - parameter message: The message to be printed.
    func success(_ message: String) {
        output(message, style: .green)
    }
    
    /// Print an info message (in cyan) to the console.
    /// - parameter message: The message to be printed.
    func info(_ message: String) {
        output(message, style: .cyan)
    }
    
    /// Print an error message (in red) to the console.
    /// - parameter message: The message to be printed.
    func error(_ message: String) {
        output(message, style: .red)
    }
    
    /// Print a promt (in magenta) to the console, and wait for
    /// - parameter message: The message to be printed.
    @discardableResult func prompt(_ message: String) -> String? {
        output(message, style: .magenta)
        return readLine()
    }
    
    private func output(_ message: String, style: Style) {
        print(style.rawValue + message + Style.reset.rawValue)
    }
    
}
