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
final class GridViewDefaultPresenter: GridViewPresenter {

    // MARK: - Private properties
    @Published
    private var _colors: [Color]
    private var process: PaintingProcess
    private var cancellable: AnyCancellable?
        
    // MARK: - Initializers
    
    init(process: PaintingProcess, n: Int) {
        self.process = process
        self.n = n
        self._colors = []
    }
        
    // MARK: - GridViewPresenter
    
    var colorsPublished: Published<[Color]> {__colors}
    var colorsPublisher: Published<[Color]>.Publisher { $_colors }
    let n: Int
        
    func setup() async {
        self.cancellable = await process.serializer.$colors            
            .throttle(for: 0.6, scheduler: DispatchQueue.global(qos: .background), latest: true)
            .receive(on: DispatchQueue.main)
            .map { matrix in
                return matrix.compactMap { row in
                    return row
                }
            }
            .assign(to: \._colors, on: self)
        do {
            try await self.process.start()
        } catch {
            print("The proccess failed to start.")
        }
    }
    
    func stop() {
        self.cancellable?.cancel()
        self.process.stop()
    }
}
