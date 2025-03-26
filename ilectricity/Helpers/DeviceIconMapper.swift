//
//  DetectIcon.swift
//  ilectricity
//
//  Created by Samuel Andrey Aji Prasetya on 23/03/25.
//

struct DeviceIconMapper {
    static let iconMapping: [String: String] = [
        "ac": "air.conditioner.horizontal",
        "kipas": "fan.floor",
        "laptop": "laptopcomputer",
        "charger": "battery.100.bolt",
        "lampu": "lightbulb",
        "setrika": "tshirt",
        "tv": "tv",
        "speaker": "speaker.wave.3",
        "printer": "printer",
        "rice cooker": "takeoutbag.and.cup.and.straw",
        "kompor": "stove",
        "komputer": "desktopcomputer",
        "dispenser": "water.waves",
        "kulkas": "refrigerator",
        "cuci": "dishwasher",
        
        "hp": "iphone",
        "smartphone": "iphone",
        "iphone": "iphone",
    ]
    
    static func detectIcon(for name: String) -> String {
        let lowercasedName = name.lowercased()
        return iconMapping.first(where: { lowercasedName.contains($0.key) })?.value ?? "questionmark.circle"
    }
}
