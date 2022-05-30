//
//  PaintingProcess.swift
//  AsyncProducers
//
//  Created by Borja Arias Drake on 02.11.2021..
//

import Foundation

/// Adds concurrency to the app by creating a task group containing one task per producer,
class PaintingProcess {
    
    private var producers: [ColorProducer]
    var serializer: ImageAccessSerializer
    private var cancellableTask: Task<Void, Error>?
    
    init(producers: [ColorProducer], serializer: ImageAccessSerializer) {
        self.producers = producers
        self.serializer = serializer
    }
    
    func start() async throws {
        try await self.generatePixels()
    }
    
    func stop() {
        self.cancellableTask?.cancel()
    }
    
    private func generatePixels() async throws {
        cancellableTask = Task {
            await withThrowingTaskGroup(of: Void.self) { g in
                for producer in producers {
                    g.addTask(priority: .background) {                                            
                        for try await pixel in producer {
                            await self.serializer.addColorPixel(pixel.color, rowIndex: pixel.row, colIndex: pixel.col)
                        }
                    }
                }
            }
        }
    }
}
