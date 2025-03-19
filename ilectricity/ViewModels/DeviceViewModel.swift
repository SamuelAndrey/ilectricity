//
//  DeviceViewModel.swift
//  ilectricity
//
//  Created by Samuel Andrey Aji Prasetya on 17/03/25.
//

import SwiftUI
import SwiftData

final class DeviceViewModel: ObservableObject {
    @Published var devices: [Device] = []
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchDevices()
    }
    
    func fetchDevices() {
        let descriptor = FetchDescriptor<Device>()
        do {
            devices = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch devices: \(error)")
        }
    }

    func addDevice(name: String, powerConsumption: Int, usageDuration: Int, frequencyPerMonth: Int, usageUnit: UsageUnit) {
        let newDevice = Device(name: name, powerConsumption: powerConsumption, usageDuration: usageDuration, frequencyPerMonth: frequencyPerMonth, usageUnit: usageUnit)
        modelContext.insert(newDevice)
        saveChanges()
        fetchDevices()
    }
    
    func deleteDevice(_ device: Device) {
        modelContext.delete(device)
        saveChanges()
        fetchDevices()
    }
    
    func saveChanges() {
        do {
            try modelContext.save()
            fetchDevices() // Memperbarui daftar setelah perubahan
        } catch {
            print("Failed to save changes: \(error)")
        }
    }
}
