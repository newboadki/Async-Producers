//
//  MenuButton.swift
//  AsyncProducers
//
//  Created by Borja Arias Drake on 30.05.2022..
//

import SwiftUI
struct MenuButtons: View {
    
    @EnvironmentObject var presenter: AnyGridViewPresenter
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                presenter.stop()
            } label: {
                Text("STOP")
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8)
                        .fill(Color("Blue")))
            }
            .padding(.vertical, 10)
            Spacer()
        }
    }
}

struct MenuButtons_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MenuButtons()
                .environmentObject(AnyGridViewPresenter(concrete: GridViewPreviewPresenter()))
            MenuButtons()
                .preferredColorScheme(.dark)
                .environmentObject(AnyGridViewPresenter(concrete: GridViewPreviewPresenter()))
        }
    }
}
