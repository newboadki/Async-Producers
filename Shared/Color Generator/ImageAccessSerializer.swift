//
//  ImageAccessSerializer.swift
//  AsyncProducers
//
//  Created by Borja Arias Drake on 02.11.2021..
//

import Combine
import Foundation
import SwiftUI

/// Protects access to an array of colors that will be used by the UI to draw a grid.
actor ImageAccessSerializer {
    @Published
    private(set) var colors: [Color]
    private let rowCount, colCount: Int

    init(rowCount: Int, colCount: Int) {
        self.rowCount = rowCount
        self.colCount = colCount
        colors = Array(repeating: .clear, count: rowCount * colCount)
    }

    func addColorPixel(_ color: Color, rowIndex: Int, colIndex: Int) {
        guard rowIndex >= 0, rowIndex < rowCount else {
            return
        }

        guard colIndex >= 0, colIndex < rowCount else {
            return
        }

        let index = rowIndex * colCount + colIndex
        colors[index] = color

        print("Added color \(color) at \(rowIndex), \(colIndex).")
    }
}
