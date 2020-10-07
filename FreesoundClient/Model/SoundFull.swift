//
//  SoundFull.swift
//  FreesoundClient
//
//  Created by Anton Shcherba on 9/2/20.
//  Copyright © 2020 Anton Shcherba. All rights reserved.
//

import Foundation

struct SoundFull: Codable {
    let id: Int?
    let url: String?
    let name: String?
    let tags: [String]?
    let soundFullDescription: String?
    let geotag: JSONNull?
    let created: String?
    let license: String?
    let type: String?
    let channels: Int?
    let filesize: Int?
    let bitrate: Int?
    let bitdepth: Int?
    let duration: Double?
    let samplerate: Int?
    let username: String?
    let pack: String?
    let packName: JSONNull?
    let download: String?
    let bookmark: String?
    let previews: Previews?
    let images: Images?
    let numDownloads: Int?
    let avgRating: Int?
    let numRatings: Int?
    let rate: String?
    let comments: String?
    let numComments: Int?
    let comment: String?
    let similarSounds: JSONNull?
    let analysis: String?
    let analysisFrames: String?
    let analysisStats: String?
    let acAnalysis: ACAnalysis?
}

// MARK: - ACAnalysis
struct ACAnalysis: Codable {
    let acTempoConfidence: Double?
    let acNoteConfidence: Double?
    let acDepth: Double?
    let acNoteMIDI: Int?
    let acTemporalCentroid: Double?
    let acWarmth: Double?
    let acLoop: Bool?
    let acHardness: Double?
    let acLoudness: Double?
    let acReverb: Bool?
    let acRoughness: Double?
    let acLogAttackTime: Double?
    let acBoominess: Double?
    let acNoteFrequency: Double?
    let acTempo: Int?
    let acBrightness: Double?
    let acSharpness: Double?
    let acTonalityConfidence: Double?
    let acDynamicRange: Double?
    let acNoteName: String?
    let acTonality: String?
    let acSingleEvent: Bool?
}

// MARK: - Images
struct Images: Codable {
    let spectralM: String?
    let spectralL: String?
    let spectralBWL: String?
    let waveformBWM: String?
    let waveformBWL: String?
    let waveformL: String?
    let waveformM: String?
    let spectralBWM: String?
    
    enum CodingKeys: String, CodingKey {
        case spectralM = "spectral_m"
        case spectralL = "spectral_l"
        case spectralBWL = "spectral_bw_l"
        case waveformBWM = "waveform_bw_m"
        case waveformBWL = "waveform_bw_l"
        case waveformL = "waveform_l"
        case waveformM = "waveform_m"
        case spectralBWM = "spectral_bw_m"
    }
}

// MARK: - Previews
struct Previews: Codable {
    let previewLqOgg: String?
    let previewLqMp3: String?
    let previewHqOgg: String?
    let previewHqMp3: String?
    
    enum CodingKeys: String, CodingKey {
        case previewLqOgg = "preview-lq-ogg"
        case previewLqMp3 = "preview-lq-mp3"
        case previewHqOgg = "preview-hq-ogg"
        case previewHqMp3 = "preview-hq-mp3"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
