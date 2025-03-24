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
        ZStack {
            VStack {
                List {
                    // SECTION: Device Details
                    Section(header:
                                HStack {
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
                            Text(isEditing ? "Batal" : "Edit")
                                .textCase(.none)
                                .foregroundStyle(Color(.systemBlue))
                                .font(.body)
                        }
                    }
                        .padding(.bottom, 8)
                    ) {
                        // Nama Perangkat
                        HStack {
                            
                            Text("Nama")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            
                            Spacer()
                            
                            TextField("Nama perangkat", text: $name)
                                .focused($focusedField, equals: .name)
                                .disabled(!isEditing)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(isEditing ? .primary : .secondary)
                        }
                        .padding(.vertical, 4)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemBackground))
                                .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                        )
                        
                        // Daya
                        HStack {
                            
                            Text("Daya (Watt)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            
                            Spacer()
                            
                            TextField("Daya", text: $powerConsumption)
                                .focused($focusedField, equals: .power)
                                .disabled(!isEditing)
                                .keyboardType(.decimalPad)
                                .foregroundColor(isEditing ? .primary : .secondary)
                        }
                        .padding(.vertical, 4)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemBackground))
                                .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                        )
                        
                        // Lama Pakai
                        HStack {
                            
                            Text("Lama Pakai")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                            
                            HStack {
                                TextField("Lama", text: $usageDuration)
                                    .focused($focusedField, equals: .duration)
                                    .disabled(!isEditing)
                                    .keyboardType(.numberPad)
                                    .foregroundColor(isEditing ? .primary : .secondary)
                                
                                Picker("", selection: $usageUnit) {
                                    Text("Jam").tag(UsageUnit.hours)
                                    Text("Menit").tag(UsageUnit.minutes)
                                }
                                .pickerStyle(.segmented)
                                .frame(width: 100)
                                .accentColor(Color(.systemBlue))
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
                        .listRowBackground(Color(.systemBlue))
                        .listRowSeparator(.hidden)
                    }
                    
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
                        let hoursPerMonth = calculateHoursPerMonth()
                        
                        // Usage per month
                        HStack {
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(Color(.systemIndigo))
                                    .font(.system(size: 16))
                                
                                Text("Penggunaan Bulan ini")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            Spacer()
                            
                            Text("\(hoursPerMonth) jam")
                                .foregroundColor(Color(.label))
                                .font(.system(size: 15, weight: .medium))
                        }
                        .padding(.vertical, 4)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemBackground))
                                .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                        )
                        
                        // Power consumption
                        let powerInKwh = (Double(powerConsumption) ?? 0) / 1000 * Double(hoursPerMonth)
                        HStack {
                            HStack {
                                Image(systemName: "bolt.circle.fill")
                                    .foregroundColor(Color(.systemGreen))
                                    .font(.system(size: 16))
                                
                                Text("Konsumsi Listrik")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            Spacer()
                            
                            Text(String(format: "%.2f kWh", powerInKwh))
                                .foregroundColor(Color(.label))
                                .font(.system(size: 15, weight: .medium))
                        }
                        .padding(.vertical, 4)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemBackground))
                                .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                        )
                        
                        // Cost estimate
                        let costEstimation = powerInKwh * 1262
                        HStack {
                            HStack {
                                Image(systemName: "creditcard.fill")
                                    .foregroundColor(Color(.systemBlue))
                                    .font(.system(size: 16))
                                
                                Text("Estimasi Biaya")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            Spacer()
                            
                            Text(String(format: "Rp %.0f", costEstimation))
                                .foregroundColor(Color(.label))
                                .font(.system(size: 15, weight: .bold))
                        }
                        .padding(.vertical, 4)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemBackground))
                                .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                        )
                    }
                    .listRowSeparator(.hidden)
                    
                    // SECTION: Daily History
                    Section(header:
                                HStack {
                        Text("Riwayat Koreksi Harian")
                            .font(.title3.bold())
                            .foregroundStyle(Color(.label))
                            .textCase(.none)
                        
                        Spacer()
                        
                        Button {
                            isShowingCorrectionSheet.toggle()
                        } label: {
                            Text("Tambah")
                                .font(.body)
                                .foregroundStyle(Color(.systemBlue))
                                .textCase(.none)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                        .padding(.bottom, 8)
                        .padding(.top, 8)
                    ) {
                        if corrections.isEmpty {
                            Text("Belum ada koreksi pemakaian untuk periode ini.")
                                .font(.footnote)
                                .foregroundStyle(Color(.secondaryLabel))
                                .padding(.vertical, 8)
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.secondarySystemBackground))
                                        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                                )
                        } else {
                            ForEach(corrections) { correction in
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
                            }
                            .onDelete(perform: deleteCorrection)
                        }
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
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
                
            }
        }
        .navigationTitle("Detail Perangkat")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Perubahan Berhasil Disimpan", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) { }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusedField = nil
                }
                
            }
        }
        
        // Sheet for adding corrections
        .sheet(isPresented: $isShowingCorrectionSheet) {
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
                                            .foregroundColor(Color(.systemBlue))
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
                                        .focused($focusedField, equals: .correction)
                                        .multilineTextAlignment(.trailing)
                                        .keyboardType(.decimalPad)
                                        .frame(width: 80)
                                    
                                    Picker("", selection: $correctionUnit) {
                                        Text("Jam").tag(UsageUnit.hours)
                                        Text("Menit").tag(UsageUnit.minutes)
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(width: 80)
                                    .accentColor(Color(.systemBlue))
                                }
                                .padding(.vertical, 4)
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.secondarySystemBackground))
                                        .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                                )
                            }.listRowSeparator(.hidden)
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(.insetGrouped)
                        
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
                        .font(.headline)
                        .disabled(correctionValue.isEmpty || Double(correctionValue) == 0)
                    }
                }
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
        .onAppear {
            loadCorrections()
        }
        .gesture(
            DragGesture(minimumDistance: 10, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.height > 0 {
                        focusedField = nil
                    }
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
