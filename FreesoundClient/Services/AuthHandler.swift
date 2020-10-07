//
//  AuthHandler.swift
//  FreesoundClient
//
//  Created by Anton Shcherba on 4/30/20.
//  Copyright © 2020 Anton Shcherba. All rights reserved.
//

import Foundation
import OAuthSwift
import WebKit
import KeychainAccess
import Combine

protocol WebProviding {
    func load(request: URLRequest)
    func finished()
}

class AuthHandler: NSObject, OAuthSwiftURLHandlerType, WKNavigationDelegate, ObservableObject {
    enum Const {
        static let freesoundServiceTokenStorage = "org.freesound.token"
        static let storageToken = "tokenKey"
        static let storageTokenSecret = "tokenSecretKey"
        static let storageTokenVersion = "tokenVersion"
    }
    
    let oauthSwift: OAuth2Swift
    let configurator: Configurator
    
    var authToken: String { oauthSwift.client.credential.oauthToken }
    var webProvider: WebProviding?
    
    private let keychain = Keychain(service: Const.freesoundServiceTokenStorage)
    
    init(configurator: Configurator) {
        self.configurator = configurator
        self.oauthSwift = OAuth2Swift(configurator: configurator,
                                      credentials: AuthHandler.credentials(from: keychain))
        super.init()
        oauthSwift.authorizeURLHandler = self
        
        oauthSwift.client.credential
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        if let url = navigationAction.request.url, url.absoluteString.hasPrefix("https://freesound.org/home/app_permissions/permission_granted") {
            OAuthSwift.handle(url: url)
        }
        decisionHandler(.allow, preferences)
    }
    
    func handle(_ url: URL) {
        let request = URLRequest.init(url: url)
        webProvider?.load(request: request)
    }
    
    func startAuth() {
        self.oauthSwift.authorize(withCallbackURL: URL(string: "https://freesound.org/home/app_permissions/permission_granted/")!,
                                  scope: "",
                                  state: "stattt") { (result) in
                                    switch result {
                                    case let .success(credential, response, parameters):
                                        self.storeCredentials()
                                        
                                        self.webProvider?.finished()
                                    case .failure(let error):
                                        print("AuthError:", error)
                                    }
                                    
        }
    }
    
    private func storeCredentials() {
        keychain[Const.storageToken] = oauthSwift.client.credential.oauthToken
        keychain[Const.storageTokenSecret] = oauthSwift.client.credential.oauthTokenSecret
    }
    
    static func credentials(from keychain: Keychain) -> OAuthSwiftCredential? {
        guard let token = keychain[Const.storageToken],
              let tokenSecret = keychain[Const.storageTokenSecret] else { return nil }
        
        let credentials = OAuthSwiftCredential.init(consumerKey: "", consumerSecret: "")
        credentials.oauthToken = token
        credentials.oauthTokenSecret = tokenSecret
        return credentials
    }
}

extension OAuth2Swift {
    convenience init(configurator: Configurator) {
        let authData = configurator.getAuthData()
        self.init(consumerKey: authData.consumerKey,
                    consumerSecret: authData.consumerSecret,
                    authorizeUrl: authData.authorizeUrl,
                    accessTokenUrl: authData.accessTokenUrl,
                    responseType: authData.responseType)
    }
    
    convenience init(configurator: Configurator, credentials: OAuthSwiftCredential?) {
        self.init(configurator: configurator)
        
        guard let credentials = credentials else { return }
        client = OAuthSwiftClient(consumerKey: client.credential.consumerKey,
                                  consumerSecret: client.credential.consumerKey,
                                  oauthToken: credentials.oauthToken,
                                  oauthTokenSecret: credentials.oauthTokenSecret,
                                  version: .oauth2)
    }
}
