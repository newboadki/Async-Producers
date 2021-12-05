//
//  Presenter.swift
//  AsyncProducers
//
//  Created by Borja Arias Drake on 02.11.2021..
//

import Foundation
import Combine
import SwiftUI

class Presenter: ObservableObject {

    private var process: PaintingProcess!
    private var cancellable: AnyCancellable?
    @Published var colors: [Color] = []

    var t1: Task<Void, Never>!
    var t2: Task<Void, Never>!
    
    let N: Int = 50
    
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
                                       color: .black,
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
            print()
        }
    }
    
    func stop() {
        
        self.process.stop()
        
    }
}
