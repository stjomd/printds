//
//  PrintService.swift
//  
//
//  Created by Artem Zhukov on 14.01.22.
//

import Foundation
import PDFKit

class PrintService: Decodable {
    
    // TODO: refactor - decouple printing/document splitting logic
    
    func go(path: String) {
        let document = PDFDocument(url: url(from: path))!
        let splitted = split(document)
        splitted.odds.printOperation(for: NSPrintInfo.shared, scalingMode: .pageScaleNone, autoRotate: false)!.run()
        splitted.evens.printOperation(for: NSPrintInfo.shared, scalingMode: .pageScaleNone, autoRotate: false)!.run()
    }

    private func split(_ document: PDFDocument) -> (odds: PDFDocument, evens: PDFDocument) {
        let docs = (PDFDocument(), PDFDocument())
        let count = document.pageCount
        let shift = count.isMultiple(of: 2) ? 0 : 1
        // Insert a blank page for the even pages set
        if (!count.isMultiple(of: 2)) {
            docs.1.insert(PDFPage(), at: 0)
        }
        // Distribute the pages of the original document
        for i in stride(from: 0, to: count, by: 1) {
            if i.isMultiple(of: 2) {
                docs.0.insert(document.page(at: i)!, at: docs.0.pageCount)
            } else {
                docs.1.insert(document.page(at: count - shift - i)!, at: docs.1.pageCount)
            }
            usleep(150000) // doesn't work otherwise :(
        }
        return docs
    }
    
    private func url(from path: String) -> URL {
        URL(string: "file://" + path)!
    }
    
}
