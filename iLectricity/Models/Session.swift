//
//  Session.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 31/08/25.
//

import Foundation
import SwiftData

@Model
final class Session {
    @Attribute(.unique) var id: UUID
    var date: Date?
    var correction: Int
    var durationUnit: DurationUnit
    var device: Device?
    
    init(id: UUID = UUID(), date: Date? = nil, correction: Int, durationUnit: DurationUnit) {
        self.id = id
        self.date = date
        self.correction = correction
        self.durationUnit = durationUnit
    }
}
