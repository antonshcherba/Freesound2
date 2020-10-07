//
//  SoundService.swift
//  FreesoundClient
//
//  Created by Anton Shcherba on 9/4/20.
//  Copyright © 2020 Anton Shcherba. All rights reserved.
//

import Foundation
import AVFoundation
import Combine

class SoundService: NSObject, ObservableObject {
    @Published var playing: Bool = false
    private var player: AVAudioPlayer?
    private var soundData: Data?
    
    func setup(with data: Data, fileType: String) {
        soundData = data
        
        player = try? AVAudioPlayer(data: data, fileTypeHint: fileType)
        player?.delegate = self
        player?.prepareToPlay()
    }
    
    func play() {
        playing = true
        player?.play()
    }
    
    func pause() {
        playing = false
        player?.pause()
    }
    
    func playPause() {
        player?.isPlaying ?? false ? pause() : play()
    }
}

extension SoundService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playing = false
    }
}
