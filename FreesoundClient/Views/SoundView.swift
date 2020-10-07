//
//  SoundView.swift
//  FreesoundClient
//
//  Created by Anton Shcherba on 5/13/20.
//  Copyright © 2020 Anton Shcherba. All rights reserved.
//

import SwiftUI

struct SoundView: View {
    var sound: SoundShort
    @ObservedObject var viewModel = SoundDetailsViewModel()
    
    var body: some View {
        LoadingView(isShowing: $viewModel.loading) {
            NavigationView {
                List {
                    Image(uiImage: UIImage(data: viewModel.imageData) ?? UIImage())
                    Text(viewModel.name ?? "")
                    Text(viewModel.author ?? "").foregroundColor(.green)
                    Text(viewModel.createdDate ?? "").foregroundColor(.blue)
                    Button.init(action: {
                        viewModel.playPauseSound()
                    }, label: {
                        Text(viewModel.isPlaying ? "Pause" : "Play")
                    })
                }.onAppear(perform: {
                    viewModel.load(id: String(sound.id))
                })
            }.navigationBarTitle(Text("Sound Details"))
        }
    }
}

struct SoundView_Previews: PreviewProvider {
    static var previews: some View {
        let sound = SoundShort(id: 1234, name: "Pianot", tags: [],
                               license: "MIT License", username: "Tony Pecino")
//        let soundModel = SoundModel(sound: sound)
        return SoundView(sound: sound)
    }
}
