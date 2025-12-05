//
//  Int+Extension.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 05/12/25.
//

extension Int {
    var ordinal: String {
        let suffix: String
        
        switch self % 100 {
        case 11, 12, 13:
            suffix = "th"
        default:
            switch self % 10 {
            case 1: suffix = "st"
            case 2: suffix = "nd"
            case 3: suffix = "rd"
            default: suffix = "th"
            }
        }
        
        return "\(self)\(suffix)"
    }
}
