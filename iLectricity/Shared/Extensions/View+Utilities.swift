//
//  View+Utilities.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 03/09/25.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboardWhenTappedAround() -> some View {
        return self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
