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
    
    @State private var correctionToDelete: UsageCorrection?
    @State private var isShowingCorrectionDeleteConfirmation = false
    
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
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    // Header
                    HStack {
                        Text("Detail Perangkat")
                            .font(.title3.bold())
                            .foregroundStyle(Color(.label))
                        Spacer()
                        Button {
                            toggleEditMode()
                        } label: {
                            Text(isEditing ? "Batal" : "Ubah")
                                .foregroundStyle(.blue)
                                .font(.body)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
                    VStack(spacing: 8) {
                        deviceDetailRow(label: "Nama", value: $name, placeholder: "Nama perangkat", isEditing: isEditing, iconField: "tag.fill", iconColor: .blue)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 15)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                        
                        deviceDetailRow(label: "Daya (Watt)", value: $powerConsumption, placeholder: "Daya", isEditing: isEditing, keyboardType: .numberPad, iconField: "bolt.fill", iconColor: .yellow)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 15)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                        
                        usageDurationRow
                            .padding(.vertical, 10)
                            .padding(.horizontal, 15)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                        
                        frequencyRow
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                    }
                }
                
                if isEditing {
                    saveChangesButton
                }
                
                dailyCorrectionHistorySection
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Estimasi")
                            .font(.title3.bold())
                            .foregroundStyle(Color(.label))
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("Penggunaan Bulan Ini")
                            Spacer()
                            Text("\(device.totalMonthlyUsageInHours, specifier: "%.2f") Jam")
                                .foregroundColor(Color(.label))
                                .font(.system(size: 15, weight: .medium))
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 15)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)

                        HStack {
                            Text("Konsumsi Listrik")
                            Spacer()
                            Text("\(EstimationHelper.monthlyEnergy(for: device), specifier: "%.2f") kWh")
                                .font(.system(size: 15, weight: .medium))
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 15)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)

                        HStack {
                            Text("Estimasi Biaya")
                            Spacer()
                            Text("Rp \(EstimationHelper.estimatedCost(for: device), specifier: "%.0f")")
                                .font(.system(size: 15, weight: .bold))
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 15)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    }
                }
                .padding(.bottom, 10)
                
                deleteDeviceButton
                
            }
            .padding(.horizontal, 15)
        }
        .hideKeyboardWhenTappedAround()
        .navigationTitle("\(name)")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Perubahan Berhasil Disimpan", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) { }
        }
        .confirmationDialog("Apakah Anda yakin ingin menghapus koreksi ini?",
                             isPresented: $isShowingCorrectionDeleteConfirmation,
                             titleVisibility: .visible) {
            Button("Hapus", role: .destructive) {
                deleteCorrection()
            }
            Button("Batal", role: .cancel) {
                correctionToDelete = nil
            }
        }
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

    
    private var deviceInformationSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Header
            HStack {
                Text("Perangkat")
                    .font(.title3.bold())
                    .foregroundStyle(Color(.label))
                
                Spacer()
                
                editToggleButton
            }
            .padding(.horizontal, 10)
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            VStack(spacing: 15) {
                deviceDetailRow(
                    label: "Nama",
                    value: $name,
                    placeholder: "Nama perangkat",
                    isEditing: isEditing,
                    keyboardType: .numberPad,
                    iconField: "tag.fill",
                    iconColor: .blue
                )
                
                deviceDetailRow(
                    label: "Daya (Watt)",
                    value: $powerConsumption,
                    placeholder: "Daya",
                    isEditing: isEditing,
                    keyboardType: .numberPad,
                    iconField: "bolt.fill",
                    iconColor: .yellow
                )
                
                usageDurationRow
                
                frequencyRow
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
        }
    }
    
    private var editToggleButton: some View {
        Text(isEditing ? "Batal" : "Ubah")
            .font(.body)
            .foregroundStyle(.blue)
            .onTapGesture {
                toggleEditMode()
            }
    }
    
    private var usageDurationRow: some View {
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
    }
    
    private var frequencyRow: some View {
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
                .disabled(!isEditing)
                .scaleEffect(0.8)
                
                Text("Hari per Bulan")
                    .foregroundColor(Color(.systemGray))
            }
        }
    }
    
    private var saveChangesButton: some View {
        Button {
            saveChanges()
            isEditing = false
        } label: {
            Text("Simpan Perubahan")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
        }
    }
    
    private var emptyCorrectionsView: some View {
        Text("Belum ada koreksi pemakaian untuk periode ini.")
            .font(.footnote)
            .foregroundStyle(Color(.secondaryLabel))
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
    }
    
    private var dailyCorrectionHistorySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Riwayat Koreksi Harian")
                    .font(.title3.bold())
                    .foregroundStyle(Color(.label))
                
                Spacer()
                
                Text("Tambah")
                    .font(.body)
                    .foregroundStyle(.blue)
                    .onTapGesture {
                        isShowingCorrectionSheet.toggle()
                    }
            }
            .padding(.horizontal, 10)
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            if corrections.isEmpty {
                emptyCorrectionsView
            } else {
                correctionsList
            }
        }
    }

    private var correctionsList: some View {
        ForEach(corrections.sorted(by: { $0.date > $1.date }), id: \.self) { correction in
            correctionRowView(correction)
                .contextMenu {
                    Button(role: .destructive) {
                        correctionToDelete = correction
                        isShowingCorrectionDeleteConfirmation = true
                    } label: {
                        Label("Hapus", systemImage: "trash")
                    }
                }
        }
    }
    
    private func correctionRowView(_ correction: UsageCorrection) -> some View {
        HStack {
            correctionIcon(for: correction)
            
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
            
            // Tombol hapus tambahan
//            Button(role: .destructive) {
//                correctionToDelete = correction
//                isShowingCorrectionDeleteConfirmation = true
//            } label: {
//                Image(systemName: "trash")
//                    .foregroundStyle(.red)
//                    .padding(.leading, 8)
//            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .onTapGesture(count: 1) {
                correctionToDelete = correction
                isShowingCorrectionDeleteConfirmation = true
            }
    }
    
    private func correctionIcon(for correction: UsageCorrection) -> some View {
        ZStack {
            Circle()
                .fill(correction.isExcess ? Color(.systemRed).opacity(0.2) : Color(.systemGreen).opacity(0.2))
                .frame(width: 40, height: 40)
            
            Image(systemName: correction.isExcess ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                .font(.system(size: 18))
                .foregroundColor(correction.isExcess ? Color(.systemRed) : Color(.systemGreen))
        }
    }
    
    private var deleteDeviceButton: some View {
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
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
        }
    }
    
    private func deviceDetailRow(
        label: String,
        value: Binding<String>,
        placeholder: String,
        isEditing: Bool,
        keyboardType: UIKeyboardType = .default,
        iconField: String,
        iconColor: Color
        
    ) -> some View {
        HStack {
            HStack {
                Image(systemName: "\(iconField)")
                    .foregroundColor(Color(iconColor))
                    .font(.system(size: 16))
                Text(label)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            
            Spacer()
            
            TextField(placeholder, text: value)
                .disabled(!isEditing)
                .keyboardType(keyboardType)
                .foregroundColor(isEditing ? .primary : .secondary)
        }
    }
    
    private func toggleEditMode() {
        isEditing.toggle()
        if !isEditing {
            name = device.name
            powerConsumption = String(device.powerConsumption)
            usageDuration = String(device.usageDuration)
            frequencyPerMonth = String(device.frequencyPerMonth)
            usageUnit = device.usageUnit
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
            let calculatedExcess: Bool
            if correctionUnit == .hours {
                calculatedExcess = Double(usageDuration)! < value
            } else {
                let durationInMinutes = Int(usageDuration)! * 60
                calculatedExcess = Double(durationInMinutes) < value
            }
            
            self.isExcess = calculatedExcess
            
            viewModel.addCorrection(to: device, date: correctionDate, correction: value, isExcess: self.isExcess, usageUnit: correctionUnit)
            
            correctionValue = ""
            correctionDate = Date()
            isExcess = false
            
            loadCorrections()
            isShowingCorrectionSheet = false
        }
    }
    
    private func deleteCorrection() {
        if let correction = correctionToDelete {
            modelContext.delete(correction)
            try? modelContext.save()
            loadCorrections()
            correctionToDelete = nil
        }
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
