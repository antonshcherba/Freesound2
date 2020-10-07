//
//  AuthView.swift
//  FreesoundClient
//
//  Created by Anton Shcherba on 4/30/20.
//  Copyright © 2020 Anton Shcherba. All rights reserved.
//

import SwiftUI
import WebKit

let authHandler = AuthHandler(configurator: Configurator.configs)

struct AuthView: View, WebProviding {    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var webViewStore = WebViewStore()
        
    var body: some View {
        WebView(webView: webViewStore.webView).onAppear {
            self.webViewStore.webView.navigationDelegate = authHandler
            authHandler.webProvider = self
            authHandler.startAuth()
        }
    }
    
    func load(request: URLRequest) {
        webViewStore.webView.load(request)
    }
    
    func finished() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
