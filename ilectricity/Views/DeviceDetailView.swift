//
//  DeviceDetailView.swift
//  ilectricity
//
//  Created by Samuel Andrey Aji Prasetya on 18/03/25.
//

import SwiftUI
import SwiftData

struct DeviceDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var viewModel: DeviceViewModel
    
    var device: Device
    
    @State private var name: String
    @State private var powerConsumption: String
    @State private var usageDuration: String
    @State private var frequencyPerMonth: String
    @State private var usageUnit: UsageUnit
    @State private var showSuccessAlert = false
    
    @FocusState private var focusedField: FocusField?
    
    enum FocusField {
        case name, power, duration, frequency
    }
    
    init(device: Device) {
        self.device = device
        _name = State(initialValue: device.name)
        _powerConsumption = State(initialValue: String(device.powerConsumption))
        _usageDuration = State(initialValue: String(device.usageDuration))
        _frequencyPerMonth = State(initialValue: String(device.frequencyPerMonth))
        _usageUnit = State(initialValue: device.usageUnit)
    }
    
    var body: some View {
        Form {
            Section(header:
                HStack {
                    Text("Detail Perangkat")
                        .font(.title3.bold())
                        .foregroundStyle(.red)
                        .textCase(.none)
                    Spacer()
                }
                .padding(.leading, -20)
                .padding(.bottom, 8)
            ) {
                TextField("Nama Perangkat", text: $name)
                    .focused($focusedField, equals: .name)
                
                HStack {
                    Text("Daya")
                    Spacer()
                    TextField("Daya", text: $powerConsumption)
                        .focused($focusedField, equals: .power)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                    Text("W")
                }
                
                HStack {
                    Text("Lama Pakai")
                    Spacer()
                    TextField("Lama", text: $usageDuration)
                        .focused($focusedField, equals: .duration)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                    
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
                    TextField("Frekuensi", text: $frequencyPerMonth)
                        .focused($focusedField, equals: .frequency)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                    Text("hari/bulan")
                }
            }
            
            Section {
                Button("Simpan Perubahan") {
                    saveChanges()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .tint(.black)
                .contentShape(Rectangle())
                .bold()
            }
            .listRowBackground(Color.green)
            
            Section(header:
                HStack {
                    Text("Estimasi Penggunaan")
                        .font(.title3.bold())
                        .foregroundStyle(.red)
                        .textCase(.none)
                    Spacer()
                }
                .padding(.leading, -20)
                .padding(.bottom, 8)
            ) {
                let hoursPerMonth = calculateHoursPerMonth()
                LabeledContent("Penggunaan per Bulan", value: "\(hoursPerMonth) jam")
                
                let powerInKwh = (Double(powerConsumption) ?? 0) / 1000 * Double(hoursPerMonth)
                LabeledContent("Konsumsi Listrik", value: String(format: "%.2f kWh", powerInKwh))
                
                let costEstimation = powerInKwh * 1262
                LabeledContent("Estimasi Biaya", value: String(format: "Rp %.0f", costEstimation))
            }
            
            Section {
                Button("Hapus Perangkat") {
                    deleteDevice()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundStyle(.white)
                .contentShape(Rectangle())
                .bold()
            }
            .listRowBackground(Color.red)
        }
        .navigationTitle("Detail Perangkat")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Perubahan Berhasil Disimpan", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) {
                
            }
        }
        
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    focusedField = nil
                }
            }
        }
    }
    
    private func calculateHoursPerMonth() -> Int {
        let duration = Int(usageDuration) ?? 0
        let frequency = Int(frequencyPerMonth) ?? 0
        return usageUnit == .hours ? duration * frequency : (duration * frequency) / 60
    }
    
    private func saveChanges() {
        device.name = name
        device.powerConsumption = Int(powerConsumption) ?? 0
        device.usageDuration = Int(usageDuration) ?? 0
        device.frequencyPerMonth = Int(frequencyPerMonth) ?? 0
        device.usageUnit = usageUnit
        
        focusedField = nil
        showSuccessAlert = true
    }
    
    private func deleteDevice() {
        viewModel.deleteDevice(device)
        dismiss()
    }
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Device.self, configurations: config)
        let context = container.mainContext
        
        let sampleDevice = Device(
            name: "AC Kamar",
            powerConsumption: 950,
            usageDuration: 5,
            frequencyPerMonth: 30,
            usageUnit: .hours
        )
        context.insert(sampleDevice)
        
        return NavigationView {
            DeviceDetailView(device: sampleDevice)
                .modelContainer(container)
                .environmentObject(DeviceViewModel(modelContext: context))
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
