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
            ForEach(Array(presenter.colors.enumerated()), id: \.offset) { _, color in
                Rectangle()
                    .foregroundColor(color)
            }
        }
        .task {
            await presenter.setup()
        }
        
        let stack = VStack {
            ScrollView {
                grid // Takes the whole screen ignorig edges and siblings
            }
            .frame(height: 600) // Tested on iPhone 13 mini
            
            Spacer()
            
            Button {
                presenter.stop()
            } label: {
                HStack {
                    Image(systemName: "stop")
                    Text("Cancel")
                }
            }
        }        
        
        return stack
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
