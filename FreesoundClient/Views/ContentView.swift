//
//  ContentView.swift
//  FreesoundClient
//
//  Created by Anton Shcherba on 4/21/20.
//  Copyright © 2020 Anton Shcherba. All rights reserved.
//

import SwiftUI
import Combine
import OAuthSwift

struct ContentView: View {
    var cancellabel: AnyCancellable?
    
    var body: some View {
        TabView() {
            NavigationView {
                SoundsView()
            }
            .tabItem {
                Image("sounds-tab-icon")
                Text("Sounds")
            }
            UserTabView().tabItem {
                Image("user-profile-tab-icon")
                Text("User")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
