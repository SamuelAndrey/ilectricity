//
//  MonthlyEstimationDetailView.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 20/06/26.
//

import SwiftUI

struct MonthlyEstimationDetailView: View {

    @Environment(\.dismiss) var dismiss

    @ObservedObject var deviceViewModel: DeviceViewModel

    private var billingPeriod: (start: Date, end: Date) {
        deviceViewModel.billingPeriod()
    }

    private var tariffPerKwh: Int {
        UserDefaults.standard.integer(forKey: UserDefaultsKeys.tariffPerKwh)
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color.green.opacity(0.6),
                        Color.green.opacity(0.1),
                        Color.secondary.opacity(0.1),
                        Color.secondary.opacity(0.1),
                        Color.secondary.opacity(0.1),
                    ]
                ),
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            List {
                Section {
                    HStack {
                        Text("Total Cost")
                        Spacer()
                        Text("Rp \(deviceViewModel.monthlyEstimate)")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }

                    HStack {
                        Text("Billing Period")
                        Spacer()
                        Text("\(billingPeriod.start.formatted(date: .abbreviated, time: .omitted)) – \(billingPeriod.end.formatted(date: .abbreviated, time: .omitted))")
                            .foregroundColor(Color.secondary)
                    }

                    HStack {
                        Text("Tariff")
                        Spacer()
                        Text("Rp \(tariffPerKwh) / kWh")
                            .foregroundColor(Color.secondary)
                    }

                } header: {
                    HStack {
                        Text("Summary")
                            .textCase(nil)
                            .font(.headline)
                            .fontWeight(.bold)

                        Spacer()

                        Text("\(deviceViewModel.monthlyBreakdown.count)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(Color(UIColor.secondarySystemGroupedBackground)))
                    }
                }

                Section {
                    if deviceViewModel.monthlyBreakdown.isEmpty {
                        HStack {
                            Spacer()
                            Text("No devices registered")
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }

                    ForEach(deviceViewModel.monthlyBreakdown) { item in
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(Color.green.opacity(0.2))
                                    .frame(width: 40, height: 40)

                                Image(systemName: item.icon)
                                    .foregroundColor(.green)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.deviceName)
                                    .font(.headline)

                                HStack(spacing: 4) {
                                    Text("Rp \(item.defaultMonthlyCost)")
                                        .font(.subheadline)
                                        .foregroundColor(Color.secondary)

                                    if item.correctionImpact != 0 {
                                        Text("\(item.correctionImpact <= 0 ? "-" : "+")\(abs(item.correctionImpact))")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(item.correctionImpact <= 0 ? .green : .red)
                                    }
                                }
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 2) {
                                Text("Rp \(item.finalMonthlyCost)")
                                    .font(.headline)
                                    .fontWeight(.bold)

                                HStack(spacing: 2) {
                                    Text("\(item.power)W")
                                        .font(.caption)
                                        .foregroundColor(Color.secondary)

                                    Text("•")
                                        .font(.caption)
                                        .foregroundColor(Color.secondary)

                                    Text("\(item.frequencyPerMonth)d")
                                        .font(.caption)
                                        .foregroundColor(Color.secondary)
                                }
                            }
                        }
                    }

                } header: {
                    HStack {
                        Text("Per Device")
                            .textCase(nil)
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Monthly Estimation")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
        })
    }
}
