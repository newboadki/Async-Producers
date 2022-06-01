//
//  ContentView.swift
//  Shared
//
//  Created by Borja Arias Drake on 02.11.2021..
//

import Combine
import Resolver
import SwiftUI

struct ContentView: View {
    @InjectedObject var presenter: AnyGridViewPresenter
    @State private var colors: [Color] = []
    @State private var cancellable: AnyCancellable?

    var body: some View {
        
        let rows: [GridItem] = Array(repeating: .init(.fixed(30)), count: presenter.n)
        let grid = LazyVGrid(columns: rows) {
            ForEach(Array(colors.enumerated()), id: \.offset) { _, color in
                RoundedRectangle(cornerRadius: 3)
                    .foregroundColor(color)
            }
            
        }
        .padding(.horizontal)

        let stack = ZStack {
            VStack {
                Text("Async Producers")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                ScrollView {
                    grid
                }
            }

            VStack {
                Spacer()
                Menu().padding(20)
            }
        }
        .environmentObject(presenter)
        .onAppear {
            cancellable = presenter.colorsPublisher
                .sink { newColors in
                    colors = newColors
                }
        }
        .onDisappear {
            cancellable?.cancel()
        }
        .task {
            await presenter.setup()
        }

        return stack
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(AnyGridViewPresenter(concrete: GridViewPreviewPresenter()))

            ContentView()
                .environmentObject(AnyGridViewPresenter(concrete: GridViewPreviewPresenter()))
                .preferredColorScheme(.dark)
        }
    }
}
