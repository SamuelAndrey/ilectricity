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
    @State private var frequencyPerMonth: Int = 30
    @State private var usageUnit: UsageUnit = .hours
    
    @FocusState private var isNameFieldFocused: Bool
    @FocusState private var focusedField: FocusField?
    
    enum FocusField {
        case name, power, duration
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Form {
                        Section(header: Text("Detail Perangkat")
                            .font(.headline)
                            .foregroundColor(Color(.label))
                            .textCase(.none)
                            .padding(.bottom, 8)
                        ) {
                            // Nama Perangkat
                            HStack {
                                HStack {
                                    Image(systemName: "tag.fill")
                                        .foregroundColor(Color(.systemBlue))
                                        .font(.system(size: 16))
                                    
                                    Text("Nama")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                }
                                
                                Spacer()
                                
                                TextField("Nama perangkat", text: $name)
                                    .focused($isNameFieldFocused)
                                    .focused($focusedField, equals: .name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.vertical, 8)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.secondarySystemBackground))
                                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                            )
                            
                            // Daya
                            HStack {
                                HStack {
                                    Image(systemName: "bolt.fill")
                                        .foregroundColor(Color(.systemYellow))
                                        .font(.system(size: 16))
                                    
                                    Text("Daya (Watt)")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                Spacer()
                                
                                TextField("Daya perangkat", value: $powerConsumption, format: .number)
                                    .keyboardType(.numberPad)
                                    .focused($focusedField, equals: .power)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                            .padding(.vertical, 8)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.secondarySystemBackground))
                                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                            )
                            
                            
                            // Lama Pakai
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    HStack {
                                        Image(systemName: "timer.circle.fill")
                                            .foregroundColor(Color(.systemTeal))
                                            .font(.system(size: 16))
                                        Text("Pemakaian")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    
                                    Spacer()
                                    
                                    TextField("Durasi per hari", value: $usageDuration, format: .number)
                                        .keyboardType(.numberPad)
                                        .focused($focusedField, equals: .duration)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.vertical, 8)
                                    
                                }.padding(.bottom, 10)
                                
                                Picker("Unit", selection: $usageUnit) {
                                    Text("Jam").tag(UsageUnit.hours)
                                    Text("Menit").tag(UsageUnit.minutes)
                                }
                                .pickerStyle(.segmented)
                                
                                Text("Durasi pemakaian adalah waktu yang dihabiskan perangkat dalam satu hari.")
                                    .font(.footnote)
                                    .foregroundColor(Color(.secondaryLabel))
                                
                            }
                            .padding(.vertical, 4)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.secondarySystemBackground))
                                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                            )
                            
                            
                            
                            
                            // Frekuensi
                            VStack {
                                HStack {
                                    
                                    Image(systemName: "repeat.circle.fill")
                                        .foregroundColor(Color(.systemOrange))
                                        .font(.system(size: 16))
                                    Text("Frekuensi")
                                    Picker("", selection: $frequencyPerMonth) {
                                        ForEach(1...31, id: \.self) { day in
                                            Text("\(day)").tag(day)
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                    .frame(width: 80, height: 100)
                                    .clipped()
                                    Text("Hari per Bulan")
                                        .foregroundColor(Color(.systemGray))
                                    
                                    
                                }
                                Text("Frekuensi pemakaian adalah jumlah hari perangkat digunakan dalam satu bulan.")
                                    .font(.footnote)
                                    .foregroundColor(Color(.secondaryLabel))
                                
                            }
                            .padding(.vertical, 4)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.secondarySystemBackground))
                                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                            )
                            
                            
                            
                            
                        }
                        .listRowSeparator(.hidden)
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.insetGrouped)
                }
            }
            .hideKeyboardWhenTappedAround()
            .navigationTitle("Tambah Perangkat")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Batal") {
                    isPresented = false
                },
                trailing: Button("Simpan") {
                    if let power = powerConsumption, let duration = usageDuration {
                        viewModel.addDevice(
                            name: name,
                            powerConsumption: power,
                            usageDuration: duration,
                            frequencyPerMonth: frequencyPerMonth,
                            usageUnit: usageUnit
                        )
                        isPresented = false
                    }
                }
                    .disabled(name.isEmpty || powerConsumption == nil || usageDuration == nil)
                    .font(.headline)
            )
            .onAppear {
                isNameFieldFocused = true
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                        isNameFieldFocused = false
                    }
                }
            }
            
            
            .scrollDismissesKeyboard(.interactively)
            .gesture(
                DragGesture(minimumDistance: 10, coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.height > 0 {
                            focusedField = nil
                            isNameFieldFocused = false
                        }
                    }
            )
            .padding(.top, 8)
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}
