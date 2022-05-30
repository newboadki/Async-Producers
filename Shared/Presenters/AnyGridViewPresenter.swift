//
//  AnyGridViewPresenter.swift
//  AsyncProducers
//
//  Created by Borja Arias Drake on 30.05.2022..
//

import Foundation
import SwiftUI

final class AnyGridViewPresenter: GridViewPresenter {
    
    private var box: _AnyGridViewPresenterBase
        
    var colorsPublished: Published<[Color]> {box.colorsPublished}
    var colorsPublisher: Published<[Color]>.Publisher { box.colorsPublisher }
    var n: Int { box.n }
        
    init<Concrete: GridViewPresenter>(concrete: Concrete) {
        self.box = _AnyGridViewPresenterBox(concrete)
    }
    
    func setup() async {
        await box.setup()
    }
    
    func stop() {
        box.stop()
    }
}

private class _AnyGridViewPresenterBase: GridViewPresenter {
    @Published
    private var _colors: [Color]
    var colorsPublished: Published<[Color]> {__colors}
    var colorsPublisher: Published<[Color]>.Publisher { $_colors }

    
    var n: Int {0}
    
    init() {
        guard type(of: self) != _AnyGridViewPresenterBase.self else {
            fatalError("_AnyQueueBase<Item> is abstract. You must subclass.")
        }
        _colors = []
    }
    
    func setup() async {
        fatalError("Must override.")
    }
    
    func stop() {
        fatalError("Must override.")
    }
    
}

private final class _AnyGridViewPresenterBox<Concrete: GridViewPresenter>: _AnyGridViewPresenterBase {
    var concrete: Concrete
    override var colorsPublished: Published<[Color]> {concrete.colorsPublished}
    override var colorsPublisher: Published<[Color]>.Publisher { concrete.colorsPublisher }
    override var n: Int {concrete.n}
    
    init(_ concrete: Concrete) {
        self.concrete = concrete
    }
    
    override func setup() async {
        await concrete.setup()
    }
    
    override func stop() {
        concrete.stop()
    }
}
