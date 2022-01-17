//
//  Arguments.swift
//  
//
//  Created by Artem Zhukov on 17.01.22.
//

import Foundation

struct Arguments {
    
    let input: String
    let output: String?
    
    let from: Int?
    let to: Int?
    
    init(input: String, output: String?, from: Int?, to: Int?) throws {
        self.input = input
        self.output = output
        if let from = from, let to = to, from > to {
            throw Exception
                .because("The value of option 'from' (\(from)) is larger than the value of 'to' (\(to)).")
        }
        self.from = from
        self.to = to
    }
    
}
