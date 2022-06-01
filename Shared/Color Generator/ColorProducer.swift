//
//  ColorProduceer.swift
//  AsyncProducers
//
//  Created by Borja Arias Drake on 02.11.2021..
//

import Foundation
import SwiftUI

class PixelIterator: AsyncIteratorProtocol {
    private var count: Int
    private var color: Color
    private var maxRow: Int
    private var maxCol: Int
    private var updateInterval: TimeInterval

    init(maxRow: Int, maxCol: Int, count: Int, color: Color, updateInterval: TimeInterval) {
        self.count = count
        self.color = color
        self.maxRow = maxRow
        self.maxCol = maxCol
        self.updateInterval = updateInterval
    }

    func next() async throws -> ColorProducer.Pixel? {
        guard !Task.isCancelled else {
            return nil
        }

        guard count > 0 else {
            return nil
        }
        count -= 1
        try await Task.sleep(nanoseconds: UInt64(updateInterval) * 1_000_000_000)
        print("Iterator: \(Thread.current)")
        return ColorProducer.Pixel(color: color,
                                   row: Int.random(in: 0 ... maxRow),
                                   col: Int.random(in: 0 ... maxCol))
    }
}

/// Async Seqyuence thaat uses a pixel iterator
class ColorProducer {
    enum ProductionError: Error {
        case alreadyStarted
    }

    struct Pixel {
        let color: Color
        let row: Int
        let col: Int
    }

    private var maxRow: Int
    private var maxCol: Int
    private var color: Color
    private var count: Int
    private var timer: Timer?
    private var updateInterval: TimeInterval

    var name: String {
        return color.description
    }

    init(maxRow: Int, maxCol: Int, color: Color, count: Int, updateInterval: TimeInterval) {
        self.color = color
        self.maxRow = maxRow
        self.maxCol = maxCol
        self.count = count
        self.updateInterval = updateInterval
    }
}

// MARK: - AsyncSequence conformance

extension ColorProducer: AsyncSequence {
    typealias AsyncIterator = PixelIterator
    typealias Element = ColorProducer.Pixel

    func makeAsyncIterator() -> PixelIterator {
        PixelIterator(maxRow: maxRow, maxCol: maxRow, count: count, color: color, updateInterval: updateInterval)
    }
}
