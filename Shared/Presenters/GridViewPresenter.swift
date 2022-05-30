//
//  GridViewPresenter.swift
//  AsyncProducers
//
//  Created by Borja Arias Drake on 30.05.2022..
//

import SwiftUI

@MainActor
protocol GridViewPresenter: ObservableObject {
    var colorsPublished: Published<[Color]> {get}
    var colorsPublisher: Published<[Color]>.Publisher {get}
    var n: Int {get}
    func setup() async
    func stop()
}
