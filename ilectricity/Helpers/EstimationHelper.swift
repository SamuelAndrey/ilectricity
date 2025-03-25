//
//  EstimationHelper.swift
//  ilectricity
//
//  Created by Samuel Andrey Aji Prasetya on 24/03/25.
//

import Foundation

struct EstimationHelper {
    
    static let electricityTariffPerKwh = 1_262.0
    
    
    /// Menghitung konsumsi energi per hari (dalam kWh)
    static func dailyEnergy(powerConsumption: Int, usageDuration: Int, usageUnit: UsageUnit) -> Double {
        let durationInHours = usageUnit == .minutes ? Double(usageDuration) / 60.0 : Double(usageDuration)
        return (Double(powerConsumption) * durationInHours) / 1000.0
    }
    
    /// Menghitung total energi per bulan untuk device termasuk koreksi
    static func monthlyEnergy(for device: Device) -> Double {
        let dailyEnergy = dailyEnergy(
            powerConsumption: device.powerConsumption,
            usageDuration: device.usageDuration,
            usageUnit: device.usageUnit
        )
        
        // Jika ada UsageCorrection
        let correctionCount = device.corrections?.count ?? 0
        let correctedDaysEnergy = dailyEnergy * Double(max(device.frequencyPerMonth - correctionCount, 0))
        
        // Tambahkan energi dari UsageCorrection secara eksplisit
        let correctionsEnergy = device.corrections?.reduce(0.0) { total, correction in
            let durationInHours = correction.usageUnit == .minutes ? correction.correction / 60.0 : correction.correction
            return total + ((Double(device.powerConsumption) * durationInHours) / 1000.0)
        } ?? 0.0
        
        return correctedDaysEnergy + correctionsEnergy
    }
    
    /// Menghitung biaya total per perangkat
    static func estimatedCost(for device: Device) -> Double {
        let totalKwh = monthlyEnergy(for: device)
        return totalKwh * self.electricityTariffPerKwh
    }
    
    /// Total energi dari semua perangkat dalam sebulan
    static func totalMonthlyEnergy(for devices: [Device]) -> Double {
        devices.reduce(0.0) { $0 + monthlyEnergy(for: $1) }
    }
    
    /// Total biaya dari semua perangkat dalam sebulan
    static func totalMonthlyCost(for devices: [Device], additionalCost: Double = 0.0) -> Double {
        totalMonthlyEnergy(for: devices) * self.electricityTariffPerKwh + additionalCost
    }
    
    /// Rata-rata biaya harian
    static func dailyCost(for devices: [Device], additionalCost: Double = 0.0) -> Double {
        totalMonthlyCost(for: devices, additionalCost: additionalCost) / 30.0
    }
    
    /// Rata-rata biaya mingguan
    static func weeklyCost(for devices: [Device], additionalCost: Double = 0.0) -> Double {
        dailyCost(for: devices, additionalCost: additionalCost) * 7.0
    }
    
    
    
    
    /// Total Biaya Keseluruhan (termasuk Biaya Beban dan PJU)
    static func overallMonthlyCost(for devices: [Device], demandCharges: Double) -> Double {
        let pju = (totalMonthlyCost(for: devices) + demandCharges) * 0.08
        return totalMonthlyCost(for: devices) + demandCharges + pju
    }
    
    /// Biaya Harian Keseluruhan
    static func overallDailyCost(for devices: [Device], demandCharges: Double) -> Double {
        overallMonthlyCost(for: devices, demandCharges: demandCharges) / 30.0
    }
    
    /// Biaya Mingguan Keseluruhan
    static func overallWeeklyCost(for devices: [Device], demandCharges: Double) -> Double {
        overallDailyCost(for: devices, demandCharges: demandCharges) * 7.0
    }
}
