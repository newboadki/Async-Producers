//
//  ContentView.swift
//  Shared
//
//  Created by Borja Arias Drake on 02.11.2021..
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var presenter: Presenter = Presenter()
    
    var body: some View {
        let rows: [GridItem] = Array(repeating: .init(.flexible()), count: presenter.N)
        let grid = LazyVGrid(columns: rows) {
            ForEach(Array(presenter.colors.enumerated()), id: \.offset) { index, color in
                Rectangle()
                    .foregroundColor(color)
            }
        }
        .task {
            await presenter.setup()
        }
        
        let stack = VStack {
            grid                        
        }        
        
        return stack
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
