//
//  UsageCorrection.swift
//  ilectricity
//
//  Created by Samuel Andrey Aji Prasetya on 20/03/25.
//

import Foundation
import SwiftData

// Model untuk koreksi pemakaian
@Model
final class UsageCorrection {
    var date: Date
    var correction: Double
    var isExcess: Bool // true = kelebihan, false = kekurangan
    
    // Relasi ke perangkat
    @Relationship(inverse: \Device.corrections)
    var device: Device?
    
    init(date: Date, correction: Double, isExcess: Bool) {
        self.date = date
        self.correction = correction
        self.isExcess = isExcess
    }
}
