//
//  SoundsViewModel.swift
//  FreesoundClient
//
//  Created by Anton Shcherba on 5/5/20.
//  Copyright © 2020 Anton Shcherba. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class SoundsViewModel: ObservableObject {
    let soundsProvider: SoundsProvider = SoundsApi()
    var publishers = [AnyCancellable]()
    @Published var sounds: [SoundShort] = []
    @Published var searchText: String = ""
    let aaa = PassthroughSubject<String,Never>()
    var cancelable: AnyCancellable?
    
    init() {        
        cancelable = $searchText.removeDuplicates().sink { text in
            self.load(searchText: text)
        }
    }
    
    func firstLoad() {
        load(searchText: searchText)
    }
    
    func load(searchText: String? = nil)  {
        self.soundsProvider.soundsList(searchText: searchText)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("completed")
                case .failure(let error):
                    print("Error", error)
                }
            }) { page in
                self.sounds = page.results
                print("Results", page)
            }.store(in: &publishers)
    }
}
