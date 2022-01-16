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
    
    func log(_ message: String) {
        print(message)
    }
    
    func success(_ message: String) {
        output(message, style: .green)
    }
    
    func info(_ message: String) {
        output(message, style: .cyan)
    }
    
    func prompt(_ message: String) {
        output(message, style: .magenta)
        _ = readLine()
    }
    
    func error(_ message: String) {
        output(message, style: .red)
    }
    
    private func output(_ message: String, style: Style) {
        print(style.rawValue + message + Style.reset.rawValue)
    }
    
}
