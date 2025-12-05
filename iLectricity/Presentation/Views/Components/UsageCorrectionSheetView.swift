//
//  UsageCorrectionSheetView.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 03/09/25.
//

import SwiftUI

struct UsageCorrectionSheetView: View {
    
    @Environment(\.dismiss) var dismiss

    @State private var correctionDate: Date = Date.now
    @State private var durationPerDay: Int?
    @State private var durationUnit: DurationUnit = .hours
    
    var body: some View {
        NavigationStack {
            Form {
                
                LabeledContent("Date") {
                    DatePicker("", selection: $correctionDate, displayedComponents: .date)
                        .labelsHidden()
                }
                
                LabeledContent("Daily Duration") {
                    TextField("e.g. 2", value: $durationPerDay, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
                
                Picker("Unit", selection: $durationUnit) {
                    Text("Hours").tag(DurationUnit.hours)
                    Text("Minutes").tag(DurationUnit.minutes)
                }
                .pickerStyle(.segmented)
                
            }
            .hideKeyboardWhenTappedAround()
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
            .navigationTitle("Daily usage correction")
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
                        //
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
    UsageCorrectionSheetView()
}
