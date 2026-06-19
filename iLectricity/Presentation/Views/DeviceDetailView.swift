//
//  DeviceDetailView.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 02/09/25.
//

import SwiftUI
import SwiftData

struct DeviceDetailView: View {

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context

    @StateObject private var deviceViewModel = DeviceViewModel()

    @State private var isPresentedEditSheet: Bool = false
    @State private var isPresentedUsageAdjustmentSheet: Bool = false

    let device: Device

    private var billingPeriod: (start: Date, end: Date) {
        let calendar = Calendar.current
        let billingDay = UserDefaults.standard.integer(forKey: UserDefaultsKeys.resetDate)
        let now = Date()
        let components = calendar.dateComponents([.year, .month], from: now)

        guard let thisMonthBilling = calendar.date(from: DateComponents(year: components.year, month: components.month, day: billingDay)) else {
            return (now, now)
        }

        let start: Date
        if now >= thisMonthBilling {
            start = thisMonthBilling
        } else {
            start = calendar.date(byAdding: .month, value: -1, to: thisMonthBilling) ?? now
        }

        let end = calendar.date(byAdding: .month, value: 1, to: start) ?? now
        return (start, end)
    }

    private var sessionsInPeriod: [Session] {
        let (start, end) = billingPeriod
        return device.sessions.filter { session in
            guard let date = session.date else { return false }
            return date >= start && date < end
        }.sorted { ($0.date ?? .distantPast) > ($1.date ?? .distantPast) }
    }

    private func isShortage(_ session: Session) -> Bool {
        let deviceHours = device.durationUnit == .hours ? Double(device.durationPerDay) : Double(device.durationPerDay) / 60.0
        let sessionHours = session.durationUnit == .hours ? Double(session.correction) : Double(session.correction) / 60.0
        return sessionHours < deviceHours
    }

    var body: some View {

        List {
            Section {
                HStack {
                    Text("Power")
                    Spacer()
                    Text("\(device.power) Watt")
                        .foregroundColor(Color.secondary)
                }

                HStack {
                    Text("Duration per day")
                    Spacer()
                    Text("\(device.durationPerDay) \(device.durationUnit == .hours ? "Hours" : "Minutes")")
                        .foregroundColor(Color.secondary)
                }

                HStack {
                    Text("Frequency")
                    Spacer()
                    Text("\(device.frequencyPerMonth) Day")
                        .foregroundColor(Color.secondary)
                }

            } header: {
                HStack {
                    Text("Device detail")
                        .textCase(nil)
                        .font(.headline)
                        .fontWeight(.bold)

                    Spacer()

                    Button {
                        isPresentedEditSheet.toggle()
                    } label: {
                        Text("Edit")
                            .textCase(nil)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                }

            }

            Section {

                if sessionsInPeriod.isEmpty {
                    HStack {
                        Spacer()
                        Text("No corrections recorded")
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }

                ForEach(sessionsInPeriod) { session in
                    HStack {
                        ZStack {
                            Circle()
                                .fill(isShortage(session) ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                                .frame(width: 40, height: 40)

                            Image(systemName: isShortage(session) ? "arrow.down.circle" : "arrow.up.circle")
                                .foregroundColor(isShortage(session) ? .green : .red)
                        }
                        HStack {
                            VStack(alignment: .leading) {
                                Text(session.date?.formatted(date: .abbreviated, time: .omitted) ?? "-")
                                    .font(.subheadline)
                                    .fontWeight(.bold)

                                Text(isShortage(session) ? "Shortage" : "Excess")
                                    .font(.subheadline)
                                    .foregroundColor(Color.secondary)
                            }

                            Spacer()

                            Text("\(session.correction) \(session.durationUnit == .hours ? "Hours" : "Minutes")")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(isShortage(session) ? .green : .red)
                        }

                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            deviceViewModel.deleteSession(context, session: session)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }

            } header: {
                HStack {
                    Text("Usage Adjustment")
                        .textCase(nil)
                        .font(.headline)
                        .fontWeight(.bold)

                    Spacer()

                    Button {
                        isPresentedUsageAdjustmentSheet.toggle()
                    } label: {
                        Text("Add")
                            .textCase(nil)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                }

            } footer: {
                Text("If there are excesses or shortages in usage duration within the current billing period, they will be listed here.")
            }
        }
        .navigationTitle(device.name)
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
        .sheet(isPresented: $isPresentedEditSheet) {
            EditDeviceSheetView(device: device, deviceViewModel: deviceViewModel)
                .presentationBackground(.ultraThinMaterial)
        }
        .sheet(isPresented: $isPresentedUsageAdjustmentSheet) {
            UsageCorrectionSheetView(device: device)
                .presentationBackground(.ultraThinMaterial)
        }
        .onAppear {
            deviceViewModel.loadDevices(context: context)
        }
    }
}
