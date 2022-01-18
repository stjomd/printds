//
//  MockConsole.swift
//  printdsTests
//
//  Created by Artem Zhukov on 18.01.22.
//

import Foundation
import PDFKit
@testable import printds

class MockConsole: Console {
    
    override init() {
        super.init()
        self.plain(true)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    override func prompt(_ message: String) -> String? {
        super.log(message)
        return nil
    }
    
}
