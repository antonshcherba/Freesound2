//
//  SoundDetailsViewModel.swift
//  FreesoundClient
//
//  Created by Anton Shcherba on 9/2/20.
//  Copyright © 2020 Anton Shcherba. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class SoundDetailsViewModel: ObservableObject {
    var publishers = [AnyCancellable]()
    
    @Published var loading: Bool = false
    @Published var name: String? = nil
    @Published var author: String? = nil
    @Published var createdDate: String? = nil
    @Published var imageData: Data = Data()
    @Published var isPlaying: Bool = false
    @Published private var sound: SoundFull? = nil
    
    let aaa = PassthroughSubject<String,Never>()
    var cancelable: AnyCancellable?
    
    private let soundsProvider: SoundsProvider = SoundsApi()
    private let downloadsProvider: DownloadsProvider = DownloadsApi()
    @ObservedObject private var soundsService: SoundService = SoundService()
    
    func load(id: String? = nil)  {
        
        loading = true
        self.soundsProvider.soundDetails(id: id)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("completed")
                case .failure(let error):
                    self?.loading = false
                    print("Error", error)
                }
            }) { [weak self] sound in
                self?.loading = false
                self?.setup(data: sound)
                print("Results", sound)
            }.store(in: &publishers)
    }
    
    func setup(data: SoundFull) {
        sound = data
        name = data.name
        author = data.username
        
        setupPlotImage(data: data)
        setupCreatedDate(data: data)
        setupSound(data: data)
    }
    
    private func setupPlotImage(data: SoundFull) {
        guard let url = URL(string: data.images?.waveformL ?? "") else { return }
        downloadsProvider.download(with: url) { (result) in
            switch result {
            case let .success(data):
                self.imageData = data
            case let .failure(error):
                print("Error loading image", error)
            }
        }
    }
    
    private func setupCreatedDate(data: SoundFull) {
        let dateParser = DateFormatter()
        dateParser.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        guard let created = data.created,
              let date = dateParser.date(from: created) else { return }
        
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        createdDate = formatter.string(from: date)
    }
    
    private func setupSound(data: SoundFull) {
        loading = true
        guard let url = URL(string: data.previews?.previewHqMp3 ?? "") else { return }
        downloadsProvider.download(with: url) { [weak self] (result) in
            guard let self = self else { return }
            self.loading = false
            
            switch result {
            case let .success(soundData):
                self.soundsService.setup(with: soundData, fileType: data.type ?? "")
            case let .failure(error):
                print("Error loading image", error)
            }
        }
    }
    
    func playPauseSound() {
        soundsService.playPause()
        isPlaying = soundsService.playing
    }
}
