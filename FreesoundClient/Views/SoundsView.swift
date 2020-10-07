//
//  SoundsView.swift
//  FreesoundClient
//
//  Created by Anton Shcherba on 5/5/20.
//  Copyright © 2020 Anton Shcherba. All rights reserved.
//

import SwiftUI

struct SoundsView: View {
    @State private var sounds: [SoundShort] = []
    @ObservedObject var viewModel = SoundsViewModel()
    
    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchText)
            List(viewModel.sounds) { sound in
                VStack {
                    NavigationLink(sound.name, destination: SoundView(sound: sound))
                    Text(sound.username)
                        .font(.subheadline).foregroundColor(.secondary)
                }
            }
            .onAppear {
                self.viewModel.firstLoad()
            }
        }
        .navigationBarTitle(Text("Sounds"))
    }
}

struct SoundsView_Previews: PreviewProvider {
    static var previews: some View {
        SoundsView()
    }
}
