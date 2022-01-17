//
//  Exception.swift
//  
//
//  Created by Artem Zhukov on 15.01.22.
//

import Foundation

/// The error type used in the `printds` application.
enum Exception: Error {
    case because(String)
}
