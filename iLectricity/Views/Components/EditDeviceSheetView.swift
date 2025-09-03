//
//  EditDeviceSheetView.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 03/09/25.
//

import SwiftUI

struct EditDeviceSheetView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var power: Int?
    @State private var durationPerDay: Int?
    @State private var frequency: Int?
    @State private var durationUnit: DurationUnit = .hours
    
    var body: some View {
        NavigationStack {
            Form {
                
                LabeledContent("Device Name") {
                    TextField("e.g. Air Conditioner", text: $name)
                        .multilineTextAlignment(.trailing)
                }
                
                LabeledContent("Power (Watt)") {
                    TextField("e.g. 450", value: $power, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
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
                
                LabeledContent("Usage Frequency") {
                    Picker("Unit", selection: $frequency) {
                        ForEach(1...30, id: \.self) { number in
                            Text("\(number)").tag(number)
                        }
                    }
                    .pickerStyle(.wheel)
                }
            }
            .hideKeyboardWhenTappedAround()
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
            .navigationTitle("Add New Device")
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
    EditDeviceSheetView()
}
