//
//  ContentView.swift
//  Shared
//
//  Created by Borja Arias Drake on 02.11.2021..
//

import SwiftUI
import Resolver
import Combine

struct ContentView: View {
    
    @InjectedObject var presenter: AnyGridViewPresenter
    @State private var colors: [Color] = []
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        let rows: [GridItem] = Array(repeating: .init(.flexible()), count: presenter.n)
        let grid = LazyVGrid(columns: rows) {
            ForEach(Array(colors.enumerated()), id: \.offset) { _, color in
                RoundedRectangle(cornerRadius: 3)
                    .foregroundColor(color)
            }
        }
        
        let stack = ZStack {
            ScrollView {
                grid
            }
            
            VStack {
                Spacer()
                Menu()
            }
        }
        .environmentObject(presenter)
        .onAppear() {
            cancellable = presenter.colorsPublisher
                .sink { newColors in
                    colors = newColors
                }
        }
        .onDisappear() {
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
        ContentView()
            .environmentObject(AnyGridViewPresenter(concrete: GridViewPreviewPresenter()))
    }
}
