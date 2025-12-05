//
//  RootView.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 01/09/25.
//

import SwiftUI

struct RootView: View {
    
    var body: some View {
        TabView {
            DeviceView()
                .tabItem {
                    Label("Devices", systemImage: "lightbulb")
                        .foregroundColor(Color.green)
                }
                .tag(0)
            
            SettingView()
                .tabItem { Label("Setting", systemImage: "gearshape") }
                .tag(1)
        }
        .accentColor(.primary)
    }
}

#Preview {
    RootView()
}
