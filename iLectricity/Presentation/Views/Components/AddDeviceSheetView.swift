//
//  AddDeviceSheetView.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 03/09/25.
//

import SwiftUI

struct AddDeviceSheetView: View {

    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    var deviceViewModel: DeviceViewModel
    
    @State private var name: String = ""
    @State private var power: Int?
    @State private var durationPerDay: Int?
    @State private var frequencyPerMonth: Int = 30
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
                    TextField("e.g. 24", value: $durationPerDay, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
                
                Picker("Unit", selection: $durationUnit) {
                    Text("Hours").tag(DurationUnit.hours)
                    Text("Minutes").tag(DurationUnit.minutes)
                }
                .pickerStyle(.segmented)
                
                LabeledContent("Usage Frequency") {
                    HStack {
                        Picker("Unit", selection: $frequencyPerMonth) {
                            ForEach(1...30, id: \.self) { number in
                                Text("\(number)").tag(number)
                            }
                        }
                        .pickerStyle(.wheel)
                        
                        Text("Days")
                    }
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
                        
                        deviceViewModel.addDevice(
                            context, name: name,
                            power: power ?? 15,
                            durationPerDay: durationPerDay ?? 24,
                            icon: "plus",
                            frequencyPerMonth: frequencyPerMonth,
                            durationUnit: durationUnit
                        )
                        
                        dismiss()
                    } label: {
                        Text("Save")
                            .fontWeight(.bold)
                    }
                    .disabled(name.isEmpty || power == nil || durationPerDay == nil)
                }
            })
        }
    }
}

#Preview {
    // AddDeviceSheetView()
}
