//
//  SplitPDFDocument.swift
//  
//
//  Created by Artem Zhukov on 15.01.22.
//

import Foundation
import PDFKit

class SplitPDFDocument {
    
    let odd: PDFDocument
    let even: PDFDocument
    
    init(odd: PDFDocument, even: PDFDocument) {
        self.odd = odd
        self.even = even
    }
    
}
