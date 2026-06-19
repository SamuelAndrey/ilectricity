//
//  DeviceMonthlyCost.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 20/06/26.
//

import Foundation

struct DeviceMonthlyCost: Identifiable {
    let id: UUID
    let deviceName: String
    let icon: String
    let power: Int
    let defaultDuration: Int
    let durationUnit: DurationUnit
    let frequencyPerMonth: Int
    let defaultMonthlyCost: Int
    let correctionCount: Int
    let correctionImpact: Int
    let finalMonthlyCost: Int
}
