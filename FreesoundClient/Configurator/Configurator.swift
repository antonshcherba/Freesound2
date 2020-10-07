//
//  Configurator.swift
//  FreesoundClient
//
//  Created by Anton Shcherba on 9/1/20.
//  Copyright © 2020 Anton Shcherba. All rights reserved.
//

import Foundation
import Keys

struct AuthSecretData {
    let consumerKey: String
    let consumerSecret: String
    let authorizeUrl = "https://freesound.org/apiv2/oauth2/authorize/"
    let accessTokenUrl = "https://freesound.org/apiv2/oauth2/access_token/"
    let responseType = "code"
    
    init() {
        let keys = FreesoundKeys()
        consumerKey = keys.consumerKey
        consumerSecret = keys.consumerSecret
    }
}

class Configurator {
    static let configs = Configurator()
    
    func getAuthData() -> AuthSecretData {
        AuthSecretData()
    }
}
