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

    @AppStorage(UserDefaultsKeys.hasCompletedOnboarding) private var hasCompletedOnboarding = false

    init() {
        registerDefaultSettings()
    }

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
    } ()

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                RootView()
            } else {
                OnboardingView()
            }
        }
        .modelContainer(sharedModelContainer)
    }

    func registerDefaultSettings() {
        UserDefaults.standard.register(defaults: [
            UserDefaultsKeys.tariffPerKwh: 1262,
            UserDefaultsKeys.resetDate: 28
        ])
    }

}
