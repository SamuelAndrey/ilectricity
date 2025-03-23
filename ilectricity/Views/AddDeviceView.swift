//
//  AddDeviceView.swift
//  ilectricity
//
//  Created by Samuel Andrey Aji Prasetya on 18/03/25.
//

import SwiftUI

struct AddDeviceView: View {
    @EnvironmentObject var viewModel: DeviceViewModel
    @Binding var isPresented: Bool
    
    @State private var name: String = ""
    @State private var powerConsumption: Int?
    @State private var usageDuration: Int?
    @State private var frequencyPerMonth: Int? = 30
    @State private var usageUnit: UsageUnit = .hours
    
    @FocusState private var isNameFieldFocused: Bool
    
    @FocusState private var focusedField: FocusField?
    
    enum FocusField {
        case name, power, duration, frequency
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section(header: Text("Detail Perangkat")) {
                        TextField("Nama Perangkat", text: $name)
                            .focused($isNameFieldFocused)
                            .focused($focusedField, equals: .name)
                        
                        HStack {
                            Text("Daya")
                            Spacer()
                            TextField("Daya", value: $powerConsumption, format: .number)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
                                .focused($focusedField, equals: .power)
                            Text("W")
                        }
                        
                        HStack {
                            Text("Lama Pakai")
                            Spacer()
                            TextField("Lama", value: $usageDuration, format: .number)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
                                .focused($focusedField, equals: .duration)
                            
                            Picker("", selection: $usageUnit) {
                                Text("Jam").tag(UsageUnit.hours)
                                Text("Menit").tag(UsageUnit.minutes)
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(width: 80)
                        }
                        
                        HStack {
                            Text("Frekuensi")
                            Spacer()
                            TextField("Frekuensi", value: $frequencyPerMonth, format: .number)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
                                .focused($focusedField, equals: .frequency)
                            Text("hari per bulan")
                        }
                    }
                }
            }
            .navigationTitle("Tambah Perangkat")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Batal") {
                    isPresented = false
                },
                trailing: Button("Simpan") {
                    if let power = powerConsumption, let duration = usageDuration, let frequency = frequencyPerMonth {
                        viewModel.addDevice(
                            name: name,
                            powerConsumption: power,
                            usageDuration: duration,
                            frequencyPerMonth: frequency,
                            usageUnit: usageUnit
                        )
                        isPresented = false
                    }
                }
                    .disabled(name.isEmpty || powerConsumption == nil || usageDuration == nil || frequencyPerMonth == nil)
            )
            .onAppear {
                isNameFieldFocused = true
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        focusedField = nil
                        isNameFieldFocused = false
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            // Add swipe down gesture to dismiss keyboard
            .gesture(
                DragGesture(minimumDistance: 10, coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.height > 0 { // Swipe down
                            focusedField = nil
                            isNameFieldFocused = false
                        }
                    }
            )
            .padding(.top, 8)
        }
        .presentationDetents([.large, .large])
        .presentationDragIndicator(.visible)
    }
}
