//
//  ImageAccessSerializer.swift
//  AsyncProducers
//
//  Created by Borja Arias Drake on 02.11.2021..
//

import Foundation
import SwiftUI
import Combine

/// Protects access to an array of rows of colors that will be used by the UI to draw a grid.
actor ImageAccessSerializer {
    
    @Published private(set) var rows: [[Color]]
            
    init (rowCount: Int, colCount: Int) {
        var r: [[Color]] = []
        for _ in 0..<rowCount {
            r.append(Array<Color>(repeating: Color.white, count: colCount))
        }
        self.rows = r
    }
    
    func addColorPixel(_ color: Color, rowIndex: Int, colIndex: Int) {
        guard (rowIndex >= 0) && (rowIndex < self.rows.count) else {
            return
        }
        
        var row = self.rows[rowIndex]
        guard (colIndex >= 0) && (colIndex < row.count) else {
            return
        }

        row[colIndex] = color
        rows[rowIndex] = row
        
        print("Added color \(color) at \(rowIndex), \(colIndex).")
    }
}
