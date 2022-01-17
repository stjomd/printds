//
//  main.swift
//
//
//  Created by Artem Zhukov on 14.01.22.
//

import Foundation

Resolver.register(Console())
Resolver.register(FileService())
Resolver.register(PrintService())
Resolver.register(DocumentService())
Resolver.register(Communicator())

App.main()
