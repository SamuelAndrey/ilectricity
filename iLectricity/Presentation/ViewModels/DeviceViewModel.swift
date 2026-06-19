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
        do {
            try deviceRepository.updateDevice(context, device: device)
            self.loadDevices(context: context)
        } catch {
            print("Failed update device: \(error)")
        }
    }
    
    func addSession(_ context: ModelContext, device: Device, date: Date, correction: Int, durationUnit: DurationUnit) {
        let session = Session(date: date, correction: correction, durationUnit: durationUnit)
        session.device = device
        device.sessions.append(session)
        do {
            try context.save()
            self.loadDevices(context: context)
        } catch {
            print("Failed add session: \(error)")
        }
    }
    
    func deleteSession(_ context: ModelContext, session: Session) {
        context.delete(session)
        do {
            try context.save()
            self.loadDevices(context: context)
        } catch {
            print("Failed delete session: \(error)")
        }
    }
    
    // MARK: - Estimation Calculations
    
    private var tariffPerKwh: Int {
        UserDefaults.standard.integer(forKey: UserDefaultsKeys.tariffPerKwh)
    }
    
    private var billingDay: Int {
        UserDefaults.standard.integer(forKey: UserDefaultsKeys.resetDate)
    }
    
    func billingPeriod() -> (start: Date, end: Date) {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month], from: now)
        
        guard let thisMonthBilling = calendar.date(from: DateComponents(year: components.year, month: components.month, day: billingDay)) else {
            return (now, now)
        }
        
        let start: Date
        if now >= thisMonthBilling {
            start = thisMonthBilling
        } else {
            start = calendar.date(byAdding: .month, value: -1, to: thisMonthBilling) ?? now
        }
        
        let end = calendar.date(byAdding: .month, value: 1, to: start) ?? now
        
        return (start, end)
    }
    
    private func durationInHours(value: Int, unit: DurationUnit) -> Double {
        unit == .hours ? Double(value) : Double(value) / 60.0
    }
    
    var dailyEstimate: Int {
        devices.reduce(0) { total, device in
            let hours = durationInHours(value: device.durationPerDay, unit: device.durationUnit)
            let kwh = Double(device.power) * hours / 1000.0
            return total + Int(kwh * Double(tariffPerKwh))
        }
    }
    
    var weeklyEstimate: Int {
        dailyEstimate * 7
    }
    
    var monthlyEstimate: Int {
        let (periodStart, periodEnd) = billingPeriod()
        
        let totalCost = devices.reduce(0.0) { total, device in
            let defaultHours = durationInHours(value: device.durationPerDay, unit: device.durationUnit)
            let defaultDailyKwh = Double(device.power) * defaultHours / 1000.0
            var deviceTotalKwh = defaultDailyKwh * Double(device.frequencyPerMonth)
            
            let sessionsInPeriod = device.sessions.filter { session in
                guard let date = session.date else { return false }
                return date >= periodStart && date < periodEnd
            }
            
            for session in sessionsInPeriod {
                let sessionHours = durationInHours(value: session.correction, unit: session.durationUnit)
                let sessionKwh = Double(device.power) * sessionHours / 1000.0
                deviceTotalKwh += (sessionKwh - defaultDailyKwh)
            }
            
            return total + (deviceTotalKwh * Double(tariffPerKwh))
        }
        
        return Int(totalCost)
    }
    
    var monthlyBreakdown: [DeviceMonthlyCost] {
        let (periodStart, periodEnd) = billingPeriod()
        
        return devices.map { device in
            let defaultHours = durationInHours(value: device.durationPerDay, unit: device.durationUnit)
            let defaultDailyKwh = Double(device.power) * defaultHours / 1000.0
            let defaultMonthlyKwh = defaultDailyKwh * Double(device.frequencyPerMonth)
            let defaultMonthlyCost = Int(defaultMonthlyKwh * Double(tariffPerKwh))
            
            let sessionsInPeriod = device.sessions.filter { session in
                guard let date = session.date else { return false }
                return date >= periodStart && date < periodEnd
            }
            
            var adjustmentKwh: Double = 0
            for session in sessionsInPeriod {
                let sessionHours = durationInHours(value: session.correction, unit: session.durationUnit)
                let sessionKwh = Double(device.power) * sessionHours / 1000.0
                adjustmentKwh += (sessionKwh - defaultDailyKwh)
            }
            
            let correctionImpact = Int(adjustmentKwh * Double(tariffPerKwh))
            let finalMonthlyCost = defaultMonthlyCost + correctionImpact
            
            return DeviceMonthlyCost(
                id: device.id,
                deviceName: device.name,
                icon: device.icon,
                power: device.power,
                defaultDuration: device.durationPerDay,
                durationUnit: device.durationUnit,
                frequencyPerMonth: device.frequencyPerMonth,
                defaultMonthlyCost: defaultMonthlyCost,
                correctionCount: sessionsInPeriod.count,
                correctionImpact: correctionImpact,
                finalMonthlyCost: finalMonthlyCost
            )
        }
    }
}
