//
//  ilectricityApp.swift
//  ilectricity
//
//  Created by Samuel Andrey Aji Prasetya on 17/03/25.
//

import SwiftUI
import SwiftData

@main
struct ilectricityApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Device.self,
            UsageCorrection.self,
        ])
        
        do {
            return try ModelContainer(for: schema)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @StateObject private var viewModel: DeviceViewModel
    
    init() {
        let modelContext = sharedModelContainer.mainContext
        _viewModel = StateObject(wrappedValue: DeviceViewModel(modelContext: modelContext))
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(.dark)
                .modelContainer(sharedModelContainer)
                .environmentObject(viewModel)
        }
    }
}
