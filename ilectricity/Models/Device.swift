//
//  Device.swift
//  ilectricity
//
//  Created by Samuel Andrey Aji Prasetya on 17/03/25.
//

import SwiftUI
import SwiftData

@Model
final class Device {
    @Attribute(.unique) var id: UUID
    var name: String
    var powerConsumption: Int
    var usageDuration: Int
    var frequencyPerMonth: Int
    var usageUnit: UsageUnit
    
    @Relationship(deleteRule: .cascade)
        var corrections: [UsageCorrection]?
    
    init(name: String, powerConsumption: Int, usageDuration: Int, frequencyPerMonth: Int, usageUnit: UsageUnit) {
        self.id = UUID()
        self.name = name
        self.powerConsumption = powerConsumption
        self.usageDuration = usageDuration
        self.frequencyPerMonth = frequencyPerMonth
        self.usageUnit = usageUnit
    }
}


enum UsageUnit: String, Codable {
    case minutes = "Menit"
    case hours = "Jam"
}

