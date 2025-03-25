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
    
    private let demandCharges = 61_763.0

    private var pju: Double {
        ((EstimationHelper.totalMonthlyCost(for: devices)) + demandCharges) * 0.08
    }

    private var additionalCosts: Double {
        demandCharges + pju
    }

    private var sortedDevices: [Device] {
        devices.sorted {
            EstimationHelper.estimatedCost(for: $0) > EstimationHelper.estimatedCost(for: $1)
        }
    }
    
    var body: some View {
     
        List {
            Section("DETAIL PEMAKAIAN PERANGKAT") {
                ForEach(sortedDevices) { device in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(device.name).font(.headline).bold()
                            
                            Spacer()
                            
                            Text("\(EstimationHelper.monthlyEnergy(for: device), specifier: "%.2f") kWh")
                                .font(.subheadline)
                        }
                        
                        
                        Text("Rp \(EstimationHelper.estimatedCost(for: device), specifier: "%.0f")")
                            .font(.subheadline)
                    }
                   
                }
            }
            
            Section("TOTAL ESTIMASI BULANAN") {
                HStack {
                    Text("Total Energi")
                    Spacer()
                    Text("\(EstimationHelper.totalMonthlyEnergy(for: devices), specifier: "%.2f") kWh")
                }
                .listRowBackground(Color(.secondarySystemBackground))
                HStack {
                    Text("Total Biaya Perangkat")
                    Spacer()
                    Text("Rp \(EstimationHelper.totalMonthlyCost(for: devices), specifier: "%.0f")")
                }
                HStack {
                    Text("Biaya Beban")
                    Spacer()
                    Text("Rp \(demandCharges, specifier: "%.0f")")
                }
                HStack {
                    Text("PJU 8%")
                    Spacer()
                    Text("Rp \(pju, specifier: "%.0f")")
                }
                HStack {
                    Text("Total Keseluruhan")
                        .bold()
                    Spacer()
                    Text("Rp \(EstimationHelper.totalMonthlyCost(for: devices, additionalCost: additionalCosts), specifier: "%.0f")")
                        .bold()
                }.listRowBackground(Color(.secondarySystemBackground))
            }
        }
        .listStyle(.plain)
        .navigationTitle("Detail Estimasi")
        .navigationBarTitleDisplayMode(.inline)
    }
}
