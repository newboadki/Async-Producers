//
//  Menu.swift
//  AsyncProducers
//
//  Created by Borja Arias Drake on 30.05.2022..
//

import SwiftUI

struct Menu: View {
    @EnvironmentObject var presenter: AnyGridViewPresenter

    var body: some View {
        Rectangle()
            .fill(.clear)
            .background(.ultraThinMaterial)
            .frame(height: 75)
            .mask(RoundedRectangle(cornerRadius: 16))
            .clipped()
            .shadow(color: .gray, radius: 16, x: 2, y: 2)
            .overlay {
                MenuButtons()
            }
    }
}

final class GridViewPreviewPresenter: GridViewPresenter {
    var colorsPublished: Published<[Color]> { _colors }
    var colorsPublisher: Published<[Color]>.Publisher { $colors }

    @Published
    private var colors: [Color] = []
    var n: Int = 50

    func setup() async {}
    func stop() {}
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
            .environmentObject(AnyGridViewPresenter(concrete: GridViewPreviewPresenter()))
    }
}
