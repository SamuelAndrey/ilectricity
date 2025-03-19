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
    
    @State private var isShowingCorrectionSheet = false
    @State private var correctionDate = Date()
    @State private var correctionValue = ""
    @State private var correctionUnit: UsageUnit = .hours
    @State private var isExcess: Bool = false
    @State private var corrections: [UsageCorrection] = []
    
    @FocusState private var focusedField: FocusField?
    
    enum FocusField {
        case name, power, duration, frequency, correction
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
                    Text("hari per bulan")
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
            
            /// Section untuk koreksi pemakaian harian
            Section(header:
                HStack {
                    Text("Koreksi Pemakaian Harian")
                        .font(.title3.bold())
                        .foregroundStyle(.red)
                        .textCase(.none)
                    Spacer()
                }
                .padding(.leading, -20)
                .padding(.bottom, 8)
            ) {
                if corrections.isEmpty {
                    Text("Belum ada data koreksi")
                        .foregroundStyle(.secondary)
                        .italic()
                } else {
                    ForEach(corrections) { correction in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(formattedDate(correction.date))
                                    .font(.headline)
                                Text(correction.isExcess ? "Kelebihan" : "Kekurangan")
                                    .font(.subheadline)
                                    .foregroundStyle(correction.isExcess ? .red : .green)
                            }
                            
                            Spacer()
                            
                            Text("\(correction.correction, specifier: "%.0f") \(correction.usageUnit == .hours ? "jam" : "menit")")
                                .font(.headline)
                                .foregroundStyle(correction.isExcess ? .red : .green)


                        }
                    }
                    .onDelete(perform: deleteCorrection)
                }
            }
            
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
            Button("OK", role: .cancel) { }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    focusedField = nil
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isShowingCorrectionSheet.toggle()
                }) {
                    Image(systemName: "plus")
                        .foregroundStyle(.green).bold()
                }
            }
        }
        
        /// Sheet untuk menambahkan koreksi pemakaian
        .sheet(isPresented: $isShowingCorrectionSheet) {
            NavigationView {
                Form {
                    Section(header: Text("Data Koreksi")) {
                        DatePicker("Tanggal", selection: $correctionDate, displayedComponents: .date)
                        
                        HStack {
                            Text("Lama Pakai")
                            Spacer()
                            TextField("Lama", text: $correctionValue)
                                .focused($focusedField, equals: .correction)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                            
                            Picker("", selection: $correctionUnit) {
                                Text("Jam").tag(UsageUnit.hours)
                                Text("Menit").tag(UsageUnit.minutes)
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(width: 80)
                        }

                    }
                }
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
                            addCorrection()
                            isShowingCorrectionSheet = false
                        }
                        .disabled(correctionValue.isEmpty || Double(correctionValue) == 0)
                    }
                    
                    ToolbarItem(placement: .keyboard) {
                        Button("Done") {
                            focusedField = nil
                        }
                    }
                }
            }
        }
        .onAppear {
            loadCorrections()
        }
        .gesture(
            TapGesture().onEnded {
                focusedField = nil
            }
        )
    }
    
    private func loadCorrections() {
        corrections = device.corrections?.sorted(by: { $0.date > $1.date }) ?? []
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
        
        viewModel.saveChanges()
        focusedField = nil
        showSuccessAlert = true
    }
    
    private func deleteDevice() {
        viewModel.deleteDevice(device)
        dismiss()
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.string(from: date)
    }
    

    private func addCorrection() {
        if let value = Double(correctionValue), value > 0 {
            // Tentukan apakah koreksi adalah kelebihan atau kekurangan berdasarkan unit
            let calculatedExcess: Bool
            if correctionUnit == .hours {
                calculatedExcess = Double(usageDuration)! < value
            } else {
                let durationInMinutes = Int(usageDuration)! * 60
                calculatedExcess = Double(durationInMinutes) < value
            }
            
            // Memastikan isExcess terupdate dengan nilai yang dihitung
            self.isExcess = calculatedExcess
            
            // Tambahkan koreksi baru melalui view model, sertakan usageUnit
            viewModel.addCorrection(to: device, date: correctionDate, correction: value, isExcess: self.isExcess, usageUnit: correctionUnit)
            
            // Reset nilai input setelah penambahan koreksi
            correctionValue = ""
            correctionDate = Date()
            isExcess = false  // Mengatur kembali ke default setelah input
            
            // Refresh data koreksi
            loadCorrections()
        }
    }

    
    // Fungsi untuk menghapus koreksi
    private func deleteCorrection(at offsets: IndexSet) {
        viewModel.deleteCorrection(at: offsets, from: device)
        loadCorrections()
    }
}



#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Device.self, UsageCorrection.self, configurations: config)
        let context = container.mainContext
        
        let sampleDevice = Device(
            name: "AC Kamar",
            powerConsumption: 950,
            usageDuration: 5,
            frequencyPerMonth: 30,
            usageUnit: .hours
        )
        
        context.insert(sampleDevice)
        
        let correction1 = UsageCorrection(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, correction: 1.5, isExcess: true, usageUnit: .hours)
        let correction2 = UsageCorrection(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, correction: 0.75, isExcess: false, usageUnit: .hours)
        
        if sampleDevice.corrections == nil {
            sampleDevice.corrections = []
        }
        sampleDevice.corrections?.append(contentsOf: [correction1, correction2])
        
        let viewModel = DeviceViewModel(modelContext: context)
        
        return NavigationView {
            DeviceDetailView(device: sampleDevice)
                .modelContainer(container)
                .environmentObject(viewModel)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
