//
//  Resolver.swift
//  
//
//  Created by Artem Zhukov on 16.01.22.
//

import Foundation

@propertyWrapper
struct Resolved<T>: Decodable {
    var wrappedValue: T? {
        Resolver.resolve(T.self)
    }
}

// Not real dependency injection - rather meant for more readability
// (dependency tree is really simple)
class Resolver {
    
    static let shared = Resolver()
    
    private static var registry: [String : Any] = [:]
    
    public static func register<T>(_ object: T) {
        let identifier = String(describing: type(of: object.self))
        registry[identifier] = object
    }
    
    public static func resolve<T>(_ type: T.Type) -> T? {
        return registry[String(describing: type)] as? T
    }
    
}
