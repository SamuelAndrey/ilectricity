//
//  DeviceViewModel.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 07/09/25.
//

import Foundation
import SwiftData

@MainActor
final class DeviceViewModel: ObservableObject {
    
    @Published var devices: [Device] = []
    
    private let deviceRepository: DeviceRepository
    
    init(deviceRepository: DeviceRepository = DeviceRepositoryImpl()) {
        self.deviceRepository = deviceRepository
    }
    
    func loadDevices(context: ModelContext) {
        do {
            devices = try deviceRepository.fetchDevices(context, sortedBy: [SortDescriptor(\.name)])
        } catch {
            print("Fetch devices failed: \(error)")
        }
    }
    
    func addDevice(_ context: ModelContext, name: String, power: Int, durationPerDay: Int, icon: String, frequencyPerMonth: Int, durationUnit: DurationUnit) {
        do {
            _ = try deviceRepository.createDevice(context, name: name, power: power, durationPerDay: durationPerDay, icon: icon, frequencyPerMonth: frequencyPerMonth, durationUnit: durationUnit)
            self.loadDevices(context: context)
        } catch {
            print("Failed add device: \(error)")
        }
    }
    
    func destroyDevice(_ context: ModelContext, device: Device) {
        do {
            _ = try deviceRepository.deleteDevice(context, device: device)
            self.loadDevices(context: context)
        } catch {
            print("Failed delete device: \(error)")
        }
    }
    
    func updateDevice(_ context: ModelContext, device: Device) {
        
    }
}
