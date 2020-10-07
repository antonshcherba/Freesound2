//
//  UserProfileView.swift
//  FreesoundClient
//
//  Created by Anton Shcherba on 9/30/20.
//  Copyright © 2020 Anton Shcherba. All rights reserved.
//

import SwiftUI

struct UserProfileView: View {
    @State private var userName = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User")) {
                    TextField("User name", text: $userName)
                }
            }
        }
        .navigationBarTitle(Text("\(userName) Info"),
                            displayMode: NavigationBarItem.TitleDisplayMode.inline)
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
