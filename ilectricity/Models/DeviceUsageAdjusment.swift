//
//  DeviceUsageAdjusment.swift
//  ilectricity
//
//  Created by Samuel Andrey Aji Prasetya on 19/03/25.
//

import SwiftUI
import SwiftData

@Model
final class DeviceUsageAdjustment {
    @Attribute(.unique) var id: UUID
    var deviceID: UUID
    var date: Date
    var frequencyAdjustment: Int
    
    init(deviceID: UUID, date: Date, frequencyAdjustment: Int) {
        self.id = UUID()
        self.deviceID = deviceID
        self.date = date
        self.frequencyAdjustment = frequencyAdjustment
    }
}
