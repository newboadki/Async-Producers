//
//  Presenter.swift
//  AsyncProducers
//
//  Created by Borja Arias Drake on 02.11.2021..
//

import Foundation
import Combine
import SwiftUI

@MainActor
class Presenter: ObservableObject {

    // MARK: - Private properties
    private var process: PaintingProcess
    private var cancellable: AnyCancellable?
        
    init(process: PaintingProcess, n: Int) {
        self.process = process
        self.n = n
    }
        
    // MARK: - Internal properties
    @Published
    private(set) var colors: [Color] = []
    let n: Int
    
    // MARK: - Internal API
    func setup() async {
        self.cancellable = await process.serializer.$rows
            .receive(on: DispatchQueue.main)
            .map { matrix in
                return matrix.flatMap { row in
                    return row
                }
            }
            .assign(to: \.colors, on: self)                
        do {
            try await self.process.start()
        } catch {
            print("The proccess failed to start.")
        }
    }
    
    func stop() {
        self.process.stop()
    }
}
