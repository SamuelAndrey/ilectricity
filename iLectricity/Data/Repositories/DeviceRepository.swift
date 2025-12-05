//
//  DeviceRepository.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 07/09/25.
//

import Foundation
import SwiftData

protocol DeviceRepository {
    
    func fetchDevices(_ context: ModelContext, sortedBy: [SortDescriptor<Device>]) throws -> [Device]
    
    func deleteDevice(_ context: ModelContext, device: Device) throws

    func createDevice(
        _ context: ModelContext,
        name: String,
        power: Int,
        durationPerDay: Int,
        icon: String,
        frequencyPerMonth: Int,
        durationUnit: DurationUnit
    ) throws -> Device
    
    func updateDevice(_ context: ModelContext, device: Device) throws
    
}
