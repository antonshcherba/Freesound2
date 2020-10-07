//
//  UserTabView.swift
//  FreesoundClient
//
//  Created by Anton Shcherba on 9/29/20.
//  Copyright © 2020 Anton Shcherba. All rights reserved.
//

import SwiftUI

struct UserTabView: View {
    var body: some View {
        NavigationView {
        Form {
            Section(header: Text("User")) {
                NavigationLink("Profile", destination: UserProfileView())
                NavigationLink("Login user", destination: AuthView())
            }
        }
        }
    }
}

struct UserTabView_Previews: PreviewProvider {
    static var previews: some View {
        UserTabView()
    }
}
