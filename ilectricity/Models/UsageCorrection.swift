//
//  UsageCorrection.swift
//  ilectricity
//
//  Created by Samuel Andrey Aji Prasetya on 20/03/25.
//

import Foundation
import SwiftData

@Model
final class UsageCorrection {
    var date: Date
    var correction: Double
    var isExcess: Bool // true = kelebihan, false = kekurangan
    var usageUnit: UsageUnit

    @Relationship(inverse: \Device.corrections)
    var device: Device?

    init(date: Date, correction: Double, isExcess: Bool, usageUnit: UsageUnit) {
        self.date = date
        self.correction = correction
        self.isExcess = isExcess
        self.usageUnit = usageUnit
    }
}
