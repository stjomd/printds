//
//  Exception.swift
//  printds
//
//  Created by Artem Zhukov on 15.01.22.
//

import Foundation

/// The error type used in the `printds` application.
enum Exception: Error {
    case fatal(String)      // Finishes execution immediately, exits with code 1
    case initiated(String)  // User initiated wish to stop, exits with code 0
}
