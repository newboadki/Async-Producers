//
//  Presenter.swift
//  AsyncProducers
//
//  Created by Borja Arias Drake on 02.11.2021..
//

import Combine
import Foundation
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
        _colors = []
    }

    // MARK: - GridViewPresenter

    var colorsPublished: Published<[Color]> { __colors }
    var colorsPublisher: Published<[Color]>.Publisher { $_colors }
    let n: Int

    func setup() async {
        cancellable = await process.serializer.$colors
            .throttle(for: 0.6, scheduler: DispatchQueue.global(qos: .background), latest: true)
            .receive(on: DispatchQueue.main)
            .map { matrix in
                matrix.compactMap { row in
                    row
                }
            }
            .assign(to: \._colors, on: self)
        do {
            try await process.start()
        } catch {
            print("The proccess failed to start.")
        }
    }

    func stop() {
        cancellable?.cancel()
        process.stop()
    }
}
