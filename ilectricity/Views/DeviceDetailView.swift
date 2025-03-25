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
    
    @State private var isEditing = false
    
    @FocusState private var focusedField: Bool
    
    init(device: Device) {
        self.device = device
        _name = State(initialValue: device.name)
        _powerConsumption = State(initialValue: String(device.powerConsumption))
        _usageDuration = State(initialValue: String(device.usageDuration))
        _frequencyPerMonth = State(initialValue: String(device.frequencyPerMonth))
        _usageUnit = State(initialValue: device.usageUnit)
    }
    
    var body: some View {
        
        VStack {
            List {
                // SECTION: Device Details
                Section(header: HStack {
                    Text("Perangkat")
                        .font(.title3.bold())
                        .foregroundStyle(Color(.label))
                        .textCase(.none)
                    
                    Spacer()
                    
                    Button {
                        isEditing.toggle()
                        if !isEditing {
                            // Reset ke data awal
                            name = device.name
                            powerConsumption = String(device.powerConsumption)
                            usageDuration = String(device.usageDuration)
                            frequencyPerMonth = String(device.frequencyPerMonth)
                            usageUnit = device.usageUnit
                        }
                    } label: {
                        Text(isEditing ? "Batal" : "Ubah")
                            .textCase(.none)
                            .foregroundStyle(Color(.blue))
                            .font(.body)
                    }
                }
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
                            .disabled(!isEditing)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(isEditing ? .primary : .secondary)
                            .focused($focusedField)
                    }
                    .padding(.vertical, 4)
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
                        
                        TextField("Daya", text: $powerConsumption)
                            .disabled(!isEditing)
                            .keyboardType(.decimalPad)
                            .foregroundColor(isEditing ? .primary : .secondary)
                            .focused($focusedField)
                    }
                    .padding(.vertical, 4)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                            .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                    )
                    
                    // Lama Pakai
                    HStack {
                        HStack {
                            Image(systemName: "timer.circle.fill")
                                .foregroundColor(Color(.systemTeal))
                                .font(.system(size: 16))
                            Text("Lama Pakai")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Spacer()
                        
                        HStack {
                            TextField("Lama", text: $usageDuration)
                                .disabled(!isEditing)
                                .keyboardType(.numberPad)
                                .foregroundColor(isEditing ? .primary : .secondary)
                                .focused($focusedField)
                            
                            Picker("", selection: $usageUnit) {
                                Text("Jam").tag(UsageUnit.hours)
                                Text("Menit").tag(UsageUnit.minutes)
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 100)
                            .accentColor(Color(.blue))
                            .disabled(!isEditing)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    .padding(.vertical, 4)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                            .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                    )
                    
                    // Frekuensi
                    HStack {
                        Image(systemName: "repeat.circle.fill")
                            .foregroundColor(Color(.systemOrange))
                            .font(.system(size: 16))
                        
                        Text("Frekuensi")
                        
                        Spacer()
                        
                        HStack {
                            
                            Picker("", selection: $frequencyPerMonth) {
                                ForEach(1...31, id: \.self) { day in
                                    Text("\(day)").tag("\(day)")
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 80, height: 80)
                            .scaleEffect(0.8)
                            .disabled(!isEditing)
                            .clipped()
                            
                            Text("hari per bulan")
                                .foregroundColor(Color(.systemGray))
                        }
                        
                        
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                            .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                    )
                }
                .listRowSeparator(.hidden)
                
                // SECTION: Save Changes Button
                if isEditing {
                    Section {
                        Button {
                            saveChanges()
                            isEditing = false
                        } label: {
                            Text("Simpan Perubahan")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(Color.white)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .listRowBackground(Color(.blue))
                    .listRowSeparator(.hidden)
                }
                
                // SECTION: Daily History
                Section(header: HStack {
                    Text("Riwayat Koreksi Harian")
                        .font(.title3.bold())
                        .foregroundStyle(Color(.label))
                        .textCase(.none)
                    
                    Spacer()
                    
                    Button {
                        isShowingCorrectionSheet.toggle()
                    } label: {
                        HStack {
                            Text("Tambah")
                                .font(.body)
                                .foregroundStyle(Color(.blue))
                                .textCase(.none)
                        }
                        
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                    .padding(.bottom, 8)
                    .padding(.top, 8)
                ) {
                    
                    if corrections.isEmpty {
                        HStack {
                            Text("Belum ada koreksi pemakaian untuk periode ini.")
                                .font(.footnote)
                                .foregroundStyle(Color(.secondaryLabel))
                                .padding(.vertical, 8)
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.secondarySystemBackground))
                                        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                                )
                        }
                        
                    } else {
                        
                        ForEach(device.corrections ?? []) { correction in
                            HStack {
                                
                                ZStack {
                                    Circle()
                                        .fill(correction.isExcess ? Color(.systemRed).opacity(0.2) : Color(.systemGreen).opacity(0.2))
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: correction.isExcess ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(correction.isExcess ? Color(.systemRed) : Color(.systemGreen))
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(formattedDate(correction.date))
                                        .font(.headline)
                                    
                                    Text(correction.isExcess ? "Kelebihan" : "Kekurangan")
                                        .font(.subheadline)
                                        .foregroundStyle(correction.isExcess ? Color(.systemRed) : Color(.systemGreen))
                                }
                                
                                Spacer()
                                
                                Text("\(correction.correction, specifier: "%.0f") \(correction.usageUnit == .hours ? "jam" : "menit")")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(correction.isExcess ? Color(.systemRed) : Color(.systemGreen))
                            }
                            .padding(.vertical, 4)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.secondarySystemBackground))
                                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                            )
                        }.onDelete(perform: deleteCorrection)
                    }
                }
                .listRowSeparator(.hidden)
                
                // SECTION: Estimation
                Section(header:
                    HStack {
                        Text("Estimasi")
                            .font(.title3.bold())
                            .foregroundStyle(Color(.label))
                            .textCase(.none)
                        Spacer()
                    }
                    .padding(.bottom, 8)
                    .padding(.top, 8)
                ) {

                    // Penggunaan Bulan ini (durasi total)
                    HStack {
                        Text("Penggunaan Bulan Ini")
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Spacer()

                        Text("\(device.totalMonthlyUsageInHours, specifier: "%.2f") Jam")
                            .foregroundColor(Color(.label))
                            .font(.system(size: 15, weight: .medium))

                    }
                    .padding(.vertical, 4)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                            .padding(.vertical, 4)
                    )

                    // Konsumsi listrik dalam kWh
                    HStack {
                        Text("Konsumsi Listrik")
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Spacer()

                        Text("\(EstimationHelper.monthlyEnergy(for: device), specifier: "%.2f") kWh")
                            .foregroundColor(Color(.label))
                            .font(.system(size: 15, weight: .medium))
                    }
                    .padding(.vertical, 4)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                            .padding(.vertical, 4)
                    )

                    // Estimasi biaya listrik bulanan untuk perangkat ini
                    HStack {
                        Text("Estimasi Biaya")
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Spacer()

                        Text("Rp \(EstimationHelper.estimatedCost(for: device), specifier: "%.0f")")
                            .foregroundColor(Color(.label))
                            .font(.system(size: 15, weight: .bold))
                    }
                    .padding(.vertical, 4)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                            .padding(.vertical, 4)
                    )
                }
                .listRowSeparator(.hidden)

                
                
                // SECTION: Delete Device Button
                Section {
                    Button {
                        deleteDevice()
                    } label: {
                        HStack {
                            Image(systemName: "trash.fill")
                                .font(.system(size: 16))
                                .foregroundStyle(Color.red)
                            
                            Text("Hapus Perangkat")
                                .font(.headline)
                                .foregroundStyle(Color.red)
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color.white)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                .listRowSeparator(.hidden)
            }
            .scrollIndicators(.hidden)
            
        }
        
        .hideKeyboardWhenTappedAround()
        .navigationTitle("Detail Perangkat")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Perubahan Berhasil Disimpan", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) { }
        }
        
        
        // Sheet for adding corrections
        .sheet(isPresented: $isShowingCorrectionSheet) {
            UsageCorrectionSheet(
                isShowingCorrectionSheet: $isShowingCorrectionSheet,
                correctionDate: $correctionDate,
                correctionValue: $correctionValue,
                correctionUnit: $correctionUnit,
                onSave: addCorrection
            )
        }
        .onAppear {
            loadCorrections()
        }
    }
    
    private func loadCorrections() {
        corrections = device.corrections?.sorted(by: { $0.date > $1.date }) ?? []
    }
    
    private func saveChanges() {
        device.name = name
        device.powerConsumption = Int(powerConsumption) ?? 0
        device.usageDuration = Int(usageDuration) ?? 0
        device.frequencyPerMonth = Int(frequencyPerMonth) ?? 0
        device.usageUnit = usageUnit
        
        viewModel.saveChanges()
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
//    private func deleteCorrection(at offsets: IndexSet) {
//        viewModel.deleteCorrection(at: offsets, from: device)
//        loadCorrections()
//    }
    
    private func deleteCorrection(at offsets: IndexSet) {
        guard let correctionsArray = device.corrections else { return }
        
        for index in offsets {
            let correctionToDelete = correctionsArray[index]
            modelContext.delete(correctionToDelete)
        }
        
        // Opsional: Save perubahan ke model
        try? modelContext.save()
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
