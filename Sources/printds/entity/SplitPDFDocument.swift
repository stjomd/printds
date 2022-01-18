//
//  SplitPDFDocument.swift
//  printds
//
//  Created by Artem Zhukov on 15.01.22.
//

import Foundation
import PDFKit

class SplitPDFDocument {
    
    /// The document with the odd pages.
    let odd: PDFDocument
    /// The document with the even pages.
    let even: PDFDocument
    
    /// The amount of pages required to print this document in duplex mode.
    var pageCount: Int {
        max(odd.pageCount, even.pageCount)
    }
    
    init(odd: PDFDocument, even: PDFDocument) {
        self.odd = odd
        self.even = even
    }
    
}
