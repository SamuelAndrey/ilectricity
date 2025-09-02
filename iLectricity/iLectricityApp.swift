//
//  iLectricityApp.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 31/08/25.
//

import SwiftUI
import SwiftData

@main
struct iLectricityApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Device.self,
            Session.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(sharedModelContainer)
    }
}
