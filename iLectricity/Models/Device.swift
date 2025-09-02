//
//  Device.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 31/08/25.
//

import SwiftData
import Foundation

@Model
final class Device {
    @Attribute(.unique) var id: UUID
    var name: String
    var power: Int
    var durationPerDay: Int
    var icon: String
    var frequencyPerMonth: Int
    var durationUnit: DurationUnit
    
    @Relationship(deleteRule: .cascade)
    var sessions: [Session] = []
    
    init(id: UUID = UUID(),
         name: String = "",
         power: Int,
         durationPerDay: Int,
         icon: String,
         frequencyPerMonth: Int,
         durationUnit: DurationUnit
    ) {
        self.id = id
        self.name = name
        self.power = power
        self.icon = icon
        self.durationPerDay = durationPerDay
        self.frequencyPerMonth = frequencyPerMonth
        self.durationUnit = durationUnit
    }
}
