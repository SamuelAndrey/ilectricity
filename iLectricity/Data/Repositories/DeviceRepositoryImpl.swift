//
//  DeviceRepositoryImpl.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 07/09/25.
//

import Foundation
import SwiftData

struct DeviceRepositoryImpl: DeviceRepository {
    
    func updateDevice(_ context: ModelContext, device: Device) throws {
        try context.save()
    }
    
    func fetchDevices(_ context: ModelContext, sortedBy: [SortDescriptor<Device>]) throws -> [Device] {
        try context.fetch(FetchDescriptor<Device>(sortBy: sortedBy))
    }
    
    func deleteDevice(_ context: ModelContext, device: Device) throws {
        context.delete(device)
        try context.save()
    }
    
    func createDevice(
        _ context: ModelContext,
        name: String, power: Int,
        durationPerDay: Int,
        icon: String,
        frequencyPerMonth: Int,
        durationUnit: DurationUnit
    ) throws -> Device {
        
        let device = Device(
            name: name,
            power: power,
            durationPerDay: durationPerDay,
            icon: icon,
            frequencyPerMonth: frequencyPerMonth,
            durationUnit: durationUnit
        )
        
        context.insert(device)
        try context.save()
        return device
    }
}
