//
//  Resolver.swift
//  
//
//  Created by Artem Zhukov on 16.01.22.
//

import Foundation

/// The annotattion that resolves objects automatically.
@propertyWrapper
struct Resolved<T>: Decodable {
    var wrappedValue: T? {
        Resolver.resolve(T.self)
    }
}

// Not real dependency injection - rather meant for more readability
// (dependency tree is really simple)
class Resolver {
        
    /// The registry that stores all registered objects.
    private static var registry: [String : Any] = [:]
    
    /// Registers an object.
    /// - parameter object: The object to be registered.
    public static func register<T>(_ object: T) {
        let identifier = String(describing: type(of: object.self))
        registry[identifier] = object
    }
    
    /// Resolves the object of a specified type.
    /// - parameter type: The type of the object.
    /// - returns: The object of the specified type, or `nil` if it hasn't been registered.
    public static func resolve<T>(_ type: T.Type) -> T? {
        return registry[String(describing: type)] as? T
    }
    
}
