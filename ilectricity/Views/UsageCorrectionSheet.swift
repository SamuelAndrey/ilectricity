//
//  UsageCorrectionSheet.swift
//  ilectricity
//
//  Created by Samuel Andrey Aji Prasetya on 25/03/25.
//

import SwiftUI

struct UsageCorrectionSheet: View {
    @Binding var isShowingCorrectionSheet: Bool
    @Binding var correctionDate: Date
    @Binding var correctionValue: String
    @Binding var correctionUnit: UsageUnit
    
    @FocusState private var focusedField: Bool
    
    var onSave: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Form {
                        Section(header: Text("Data Koreksi")
                            .font(.headline)
                            .foregroundColor(Color(.label))
                            .textCase(.none)
                            .padding(.bottom, 8)
                        ) {
                            // Date
                            HStack {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(Color(.blue))
                                        .font(.system(size: 16))
                                    
                                    Text("Tanggal")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                Spacer()
                                
                                DatePicker("", selection: $correctionDate, displayedComponents: .date)
                                    .labelsHidden()
                            }
                            .padding(.vertical, 4)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.secondarySystemBackground))
                                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                            )
                            
                            // Usage time
                            HStack {
                                HStack {
                                    Image(systemName: "timer.circle.fill")
                                        .foregroundColor(Color(.systemTeal))
                                        .font(.system(size: 16))
                                    
                                    Text("Lama Pakai")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                Spacer()
                                
                                TextField("Lama", text: $correctionValue)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.decimalPad)
                                    .frame(width: 80)
                                    .focused($focusedField)
                                
                                Picker("", selection: $correctionUnit) {
                                    Text("Jam").tag(UsageUnit.hours)
                                    Text("Menit").tag(UsageUnit.minutes)
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(width: 80)
                                .accentColor(Color(.blue))
                            }
                            .padding(.vertical, 4)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.secondarySystemBackground))
                                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                            )
                        }.listRowSeparator(.hidden)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .hideKeyboardWhenTappedAround()
            .navigationTitle("Tambah Koreksi")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Batal") {
                        isShowingCorrectionSheet = false
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Simpan") {
                        onSave()
                        isShowingCorrectionSheet = false
                    }
                    .font(.headline)
                    .disabled(correctionValue.isEmpty || Double(correctionValue) == 0)
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}
