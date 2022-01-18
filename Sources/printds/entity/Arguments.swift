//
//  Arguments.swift
//  printds
//
//  Created by Artem Zhukov on 17.01.22.
//

import Foundation

/// A struct responsible for storing and validating arguments for this program.
struct Arguments {
    
    let input: String
    let output: String?
    
    let from: Int?
    let to: Int?
    
    /// Initializes this struct.
    /// - throws: If the validation fails.
    init(input: String, output: String?, from: Int?, to: Int?) throws {
        self.input = input
        self.output = output
        self.from = from
        self.to = to
        try self.validate()
    }
    
    /// Checks whether the arguments are valid.
    /// - throws: If the validation fails.
    private func validate() throws {
        if let from = from, let to = to, from > to {
            throw Exception
                .because("The value of option 'from' (\(from)) is larger than the value of 'to' (\(to)).")
        }
    }
    
}
