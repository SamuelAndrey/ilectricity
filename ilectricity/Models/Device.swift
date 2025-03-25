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
    
        var totalMonthlyUsageInHours: Double {
            
            let dailyUsageInHours = usageUnit == .minutes ? Double(usageDuration) / 60.0 : Double(usageDuration)
            
            // Total hari tanpa koreksi
            let correctionCount = corrections?.count ?? 0
            let correctedRegularUsage = dailyUsageInHours * Double(max(frequencyPerMonth - correctionCount, 0))
            
            // Total jam dari koreksi secara eksplisit
            let correctionsUsageInHours = corrections?.reduce(0.0) { total, correction in
                let durationInHours = correction.usageUnit == .minutes ? correction.correction / 60.0 : correction.correction
                return total + durationInHours
            } ?? 0.0
            
            // Total jam keseluruhan (regular + koreksi)
            return correctedRegularUsage + correctionsUsageInHours
        }
}


enum UsageUnit: String, Codable {
    case minutes = "Menit"
    case hours = "Jam"
}

