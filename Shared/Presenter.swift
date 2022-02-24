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
    private var t1: Task<Void, Never>!
    private var t2: Task<Void, Never>!
    private var process: PaintingProcess!
    private var cancellable: AnyCancellable?
        
    // MARK: - Internal properties
    @Published var colors: [Color] = []
    let N: Int = 50
    
    // MARK: - Internal API
    func setup() async {
        let producers = [ColorProducer(maxRow: N,
                                       maxCol: N,
                                       color: .yellow,
                                       count: 9000,
                                       updateInterval: 0.5),
                         ColorProducer(maxRow: N,
                                       maxCol: N,
                                       color: .purple,
                                       count: 9000,
                                       updateInterval: 0.5),
                         ColorProducer(maxRow: N,
                                       maxCol: N,
                                       color: .green,
                                       count: 18000,
                                       updateInterval: 1.1)]
        let serializer = await ImageAccessSerializer(rowCount: N, colCount: N)
        
        self.cancellable = await serializer.$rows
            .receive(on: DispatchQueue.main)
            .map { matrix in
                return matrix.flatMap { row in
                    return row
                }
            }
            .assign(to: \.colors, on: self)
        
        self.process = PaintingProcess(producers: producers, serializer: serializer)
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
