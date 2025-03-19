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
            fetchDevices()
        } catch {
            print("Failed to save changes: \(error)")
        }
    }
    
    // MARK: - UsageCorrection Methods
    
    func fetchCorrections(for device: Device) -> [UsageCorrection] {
        return device.corrections ?? []
    }
    
    func addCorrection(to device: Device, date: Date, correction: Double, isExcess: Bool) {
        let newCorrection = UsageCorrection(date: date, correction: correction, isExcess: isExcess)
        
        // Inisialisasi array jika belum ada
        if device.corrections == nil {
            device.corrections = []
        }
        
        // Tambahkan koreksi baru
        device.corrections?.append(newCorrection)
        
        // Simpan perubahan
        saveChanges()
    }
    
    func deleteCorrection(_ correction: UsageCorrection, from device: Device) {
        device.corrections?.removeAll(where: { $0.id == correction.id })
        modelContext.delete(correction)
        saveChanges()
    }
    
    func deleteCorrection(at offsets: IndexSet, from device: Device) {
        guard let corrections = device.corrections else { return }
        
        for index in offsets {
            if index < corrections.count {
                let correction = corrections[index]
                modelContext.delete(correction)
            }
        }
        
        // Refresh the corrections array
        device.corrections?.remove(atOffsets: offsets)
        saveChanges()
    }
}
