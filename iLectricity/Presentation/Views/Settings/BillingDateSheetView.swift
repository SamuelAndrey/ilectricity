//
//  BillingDateView.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 03/09/25.
//

import SwiftUI

struct BillingDateSheetView: View {
    
    @Environment(\.dismiss) var dismiss
        
    @State private var name: String = ""
    @State private var power: Int?
    @State private var durationPerDay: Int?
    @State private var durationUnit: DurationUnit = .hours
    @Binding var frequency: Int
    
    var body: some View {
        NavigationStack {
            Form {
                
                VStack {
                    Text("Day of the month the bill is issued")
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    Picker("Billing Date", selection: $frequency) {
                        ForEach(1...28, id: \.self) { number in
                            Text("Day \(number)").tag(number)
                        }
                    }
                    .pickerStyle(.wheel)
                }
            }
            .hideKeyboardWhenTappedAround()
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
            .navigationTitle("Billing date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        UserDefaults.standard.set(frequency, forKey: UserDefaultsKeys.resetDate)
                        dismiss()
                    } label: {
                        Text("Save")
                            .fontWeight(.bold)
                    }
                }
            })
        }
    }
}

#Preview {
    BillingDateSheetView(frequency: .constant(28))
}
