//
//  DetectIcon.swift
//  ilectricity
//
//  Created by Samuel Andrey Aji Prasetya on 23/03/25.
//

struct DeviceIconMapper {
    static let iconMapping: [String: String] = [
        "ac": "wind",
        "kipas": "fanblades",
        "laptop": "laptopcomputer",
        "charger": "battery.100.bolt",
        "lampu": "lightbulb",
        "setrika": "iron",
        "tv": "tv",
        "speaker": "speaker.wave.3",
        "printer": "printer",
        "rice": "takeoutbag.and.cup.and.straw"
    ]
    
    static func detectIcon(for name: String) -> String {
        let lowercasedName = name.lowercased()
        return iconMapping.first(where: { lowercasedName.contains($0.key) })?.value ?? "questionmark.circle"
    }
}
