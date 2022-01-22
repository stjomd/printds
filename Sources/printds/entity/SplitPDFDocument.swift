//
//  SplitPDFDocument.swift
//  printds
//
//  Created by Artem Zhukov on 15.01.22.
//

import Foundation
import PDFKit.PDFDocument

// An object that encapsulates up to two PDF documents.
class SplitPDFDocument {
    
    /// The document with the odd pages.
    let odd: PDFDocument?
    /// The document with the even pages.
    let even: PDFDocument?
    
    /// The amount of pages required to print this document in duplex mode.
    var pageCount: Int {
        if let odd = odd, let even = even {
            return max(odd.pageCount, even.pageCount)
        } else if let odd = odd {
            return odd.pageCount
        } else if let even = even {
            return even.pageCount
        } else {
            return 0
        }
    }
    
    init(odd: PDFDocument?, even: PDFDocument?) {
        self.odd = odd
        self.even = even
    }
    
}
