//
//  EstimationView.swift
//  ilectricity
//
//  Created by Samuel Andrey Aji Prasetya on 18/03/25.
//

import SwiftUI
import SwiftData

struct EstimationDetailView: View {
    @Query private var devices: [Device]
    
    // Misalnya ingin menambahkan pajak/admin
    private let additionalCosts = 0.0 // tinggal isi manual
    
    var sortedDevices: [Device] {
        devices.sorted {
            EstimationHelper.estimatedCost(for: $0) > EstimationHelper.estimatedCost(for: $1)
        }
    }
    
    var body: some View {
        List {
            Section("Detail Pemakaian Perangkat") {
                ForEach(sortedDevices) { device in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(device.name).font(.headline)
                        
                        Text("\(EstimationHelper.monthlyEnergy(for: device), specifier: "%.2f") kWh • Rp \(EstimationHelper.estimatedCost(for: device), specifier: "%.0f")")
                            .font(.subheadline)
                    }
                    .padding(.vertical, 4)
                }
            }
            
            Section("Total Keseluruhan") {
                HStack {
                    Text("Total Energi")
                    Spacer()
                    Text("\(EstimationHelper.totalMonthlyEnergy(for: devices), specifier: "%.2f") kWh")
                }
                HStack {
                    Text("Total Biaya Perangkat")
                    Spacer()
                    Text("Rp \(EstimationHelper.totalMonthlyCost(for: devices), specifier: "%.0f")")
                }
                HStack {
                    Text("Biaya Lain-lain")
                    Spacer()
                    Text("Rp \(additionalCosts, specifier: "%.0f")")
                }
                HStack {
                    Text("Total Keseluruhan")
                        .bold()
                    Spacer()
                    Text("Rp \(EstimationHelper.totalMonthlyCost(for: devices, additionalCost: additionalCosts), specifier: "%.0f")")
                        .bold()
                }
            }
        }
        .navigationTitle("Rincian Estimasi")
        .navigationBarTitleDisplayMode(.inline)
    }
}
