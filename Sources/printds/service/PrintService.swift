//
//  PrintService.swift
//  printds
//
//  Created by Artem Zhukov on 14.01.22.
//

import Foundation
import PDFKit

class PrintService: Decodable {
    
    /// Sends a PDF document to the OS's printer.
    /// - parameter document: The PDF document to be printed.
    /// - throws: An exception is thrown if a NSPrintOperation couldn't be retrieved from the document.
    func print(_ document: PDFDocument) throws {
        guard let operation = document.printOperation(
            for: NSPrintInfo.shared,
            scalingMode: .pageScaleToFit,
            autoRotate: true
        ) else {
            throw Exception.because("Couldn't retrieve a print operation object.")
        }
        operation.run()
    }
    
}
