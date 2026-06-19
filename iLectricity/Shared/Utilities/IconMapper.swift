//
//  IconMapper.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 20/06/26.
//

import Foundation

struct IconMapper {

    static let defaultIcon = "powerplug"

    private static let mappings: [(keywords: [String], symbol: String)] = [
        (["air conditioner", "ac", "pendingin ruangan", "pendingin", "aircond", "air cond", "air cooler", "cooler"], "air.conditioner.horizontal"),
        (["fan", "kipas angin", "kipas", "exhaust fan", "exhaust", "ceiling fan"], "fan.ceiling"),
        (["television", "tv", "televisi", "telivisi", "televison"], "tv"),
        (["lamp", "light", "lampu", "bohlam", "tl", "led", "neon"], "lightbulb"),
        (["refrigerator", "fridge", "kulkas", "lemari es", "lemari pendingin", "freezer"], "refrigerator"),
        (["washing machine", "washer", "mesin cuci", "laundry"], "washer"),
        (["microwave", "microwave oven"], "microwave"),
        (["computer", "pc", "laptop", "komputer", "desktop", "notebook", "macbook", "imac"], "laptopcomputer"),
        (["phone", "handphone", "hp", "smartphone", "charger", "pengisi daya", "casan", "cas", "pengisi baterai"], "iphone"),
        (["rice cooker", "penanak nasi", "magic com", "magicom", "magic jar", "magicjar", "ricecooker"], "frying.pan"),
        (["water pump", "pompa air", "pompa", "jet pump", "sumur", "submersible"], "spigot"),
        (["iron", "setrika", "setrikaan", "setrika listrik"], "tshirt"),
        (["water heater", "heater", "pemanas air", "waterheater", "pemanas", "boiler"], "heater.vertical"),
        (["hair dryer", "hairdryer", "pengering rambut", "hair dry"], "hairdryer"),
        (["vacuum", "vacuum cleaner", "penyedot debu", "vacum", "vacum cleaner"], "vacuum"),
        (["speaker", "audio", "speaker aktif", "sound system", "sound", "loudspeaker", "pengeras suara", "toa"], "hifispeaker"),
        (["printer", "printer", "mesin cetak"], "printer"),
        (["monitor", "display", "layar", "screen", "led monitor"], "display"),
        (["router", "modem", "wifi", "internet", "access point", "accesspoint"], "wifi"),
        (["oven", "electric oven", "pemanggang", "oven listrik", "toaster", "pemanggang roti"], "oven"),
        (["blender", "blender", "juicer", "pembuat jus", "juice"], "frying.pan"),
        (["air purifier", "purifier", "penjernih udara", "penyaring udara", "air filter", "filter udara"], "humidifier.and.droplets"),
        (["set top box", "stb", "tv cable", "decoder", "tv box", "android box", "android tv"], "tv.and.mediabox"),
        (["cctv", "camera", "kamera", "webcam", "ip camera", "kamera cctv"], "web.camera"),
        (["dispenser", "galon", "water dispenser", "water gallon", "dispenser air"], "water.dispenser"),
        (["ps", "ps5", "ps4", "ps3", "playstation", "xbox", "console", "game", "gaming", "nintendo", "nitendo"], "gamecontroller"),
        (["electric stove", "kompor listrik", "induction", "induktor", "cooktop", "kompor", "stove"], "stove"),
        (["kettle", "electric kettle", "ceret listrik", "pemanas air minum", "water boiler", "ceret", "teko listrik"], "kettle"),
        (["radio", "radio", "radio fm", "fm"], "radio"),
        (["clock", "jam dinding", "jam digital", "jam", "wall clock"], "clock"),
        (["mixer", "hand mixer", "mixer kue", "pengaduk", "pengaduk kue"], "frying.pan"),
        (["coffee maker", "coffee machine", "mesin kopi", "pembuat kopi", "coffeemaker", "coffee", "kopi", "coffe"], "mug"),
        (["drone", "drone", "drone camera"], "drone"),
        (["homepod", "smart speaker", "home speaker", "alexa", "google home", "google nest"], "homepod"),
        (["apple tv", "appletv", "apple tv 4k"], "appletv"),
        (["solder", "solder iron", "solder listrik", "timah"], "pencil.and.scribble"),
        (["amplifier", "amp", "ampli", "penguat"], "hifispeaker"),
        (["server", "server", "nas", "storage"], "server.rack"),
        (["humidifier", "humidifier", "pelembab udara", "pelembab"], "humidifier"),
        (["electric fan", "kipas listrik", "stand fan", "kipas berdiri"], "fan"),
        (["desk lamp", "lampu meja", "lampu belajar", "lampu baca"], "lightbulb"),
        (["guitar", "gitar", "bass", "gitar listrik", "amplifier gitar"], "guitars"),
        (["keyboard", "keyboard", "piano", "piano listrik", "organ", "electone"], "pianokeys"),
        (["curtain", "gorden", "tirai", "curtain motor", "motorized curtain", "roller blind"], "curtains.closed"),
        (["charger ev", "ev charger", "mobil listrik", "electric car", "electric vehicle", "car charger"], "ev.charger"),
        (["cable", "kabel", "roll kabel", "extension", "extension cord", "terminal", "stop kontak", "colokan"], "cable.connector"),
        (["tablet", "ipad", "tab", "tablet", "android tablet", "samsung tab"], "apps.ipad"),
    ]

    static func icon(for name: String) -> String {
        let normalized = name
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: .diacriticInsensitive, locale: .current)

        guard !normalized.isEmpty else { return defaultIcon }

        for mapping in mappings {
            for keyword in mapping.keywords {
                if normalized.contains(keyword) {
                    return mapping.symbol
                }
            }
        }

        return defaultIcon
    }
}
