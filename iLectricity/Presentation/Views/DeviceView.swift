//
//  DeviceView.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 31/08/25.
//

import SwiftUI

struct DeviceView: View {

    @Environment(\.modelContext) private var context
    @StateObject private var deviceViewModel = DeviceViewModel()

    @State private var isPresentedAddDeviceSheet: Bool = false
    @State private var isPresentedEditDeviceSheet: Bool = false
    @State private var selectedDevice: Device?

    @State private var emptyPulse: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                    .ignoresSafeArea()

                if deviceViewModel.devices.isEmpty {
                    emptyStateView
                } else {
                    populatedListView
                }
            }
            .navigationTitle(deviceViewModel.devices.isEmpty ? "" : "Estimation")
            .toolbar(content: {
                if !deviceViewModel.devices.isEmpty {
                    ToolbarItem {
                        Button {
                            isPresentedAddDeviceSheet = true
                        } label: {
                            Image(systemName: "plus")
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                                .padding(12)
                                .contentShape(Rectangle())
                        }
                    }
                }
            })
            .sheet(isPresented: $isPresentedAddDeviceSheet) {
                AddDeviceSheetView(deviceViewModel: deviceViewModel)
            }
            .sheet(item: $selectedDevice) { device in
                EditDeviceSheetView(device: device, deviceViewModel: deviceViewModel)
                    .presentationBackground(.ultraThinMaterial)
            }
            .onAppear {
                deviceViewModel.loadDevices(context: context)
            }
        }
    }

    // MARK: - Background

    private var backgroundGradient: some View {
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
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: 0) {
            Spacer()

            heroIllustration

            VStack(spacing: 8) {
                Text("Start Tracking Your\nElectricity Costs")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(.top, 32)

                Text("Add your household devices. iLectricity estimates daily, weekly, and monthly costs automatically.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 6)
            }

            Button {
                isPresentedAddDeviceSheet = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                    Text("Add Your First Device")
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 28)
                .padding(.vertical, 14)
                .background(Color.green)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .shadow(color: .green.opacity(0.3), radius: 8, y: 4)
            }
            .padding(.top, 28)

            Spacer()
            Spacer()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true)) {
                emptyPulse = true
            }
        }
    }

    private var heroIllustration: some View {
        ZStack {
            Image(systemName: "leaf.circle.fill")
                .resizable()
                .frame(width: 110, height: 110)
                .foregroundColor(.green.opacity(0.07))
                .rotationEffect(.degrees(20))
                .offset(x: -70, y: -10)

            Image(systemName: "leaf.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.green.opacity(0.05))
                .rotationEffect(.degrees(-25))
                .offset(x: 65, y: 15)

            Circle()
                .stroke(Color.green.opacity(0.1), lineWidth: 2)
                .frame(width: emptyPulse ? 140 : 120)
                .opacity(emptyPulse ? 0 : 0.6)

            Circle()
                .fill(Color.green.opacity(0.12))
                .frame(width: 90, height: 90)

            Image(systemName: "bolt.fill")
                .font(.system(size: 34, weight: .medium))
                .foregroundColor(.green)

            FloatingDot(symbol: "lightbulb.fill", x: -52, y: -48, size: 16, color: .yellow.opacity(0.6), delay: 0)
            FloatingDot(symbol: "sparkles", x: 58, y: -40, size: 14, color: .green.opacity(0.45), delay: 0.5)
            FloatingDot(symbol: "wave.3.right", x: -56, y: 44, size: 13, color: .green.opacity(0.35), delay: 0.9)
            FloatingDot(symbol: "bolt.horizontal.fill", x: 60, y: 46, size: 15, color: .green.opacity(0.45), delay: 1.3)
            FloatingDot(symbol: "circle.grid.cross.fill", x: 0, y: -58, size: 11, color: .green.opacity(0.3), delay: 1.7)
            FloatingDot(symbol: "sparkle", x: -24, y: 56, size: 10, color: .green.opacity(0.35), delay: 2.1)
        }
        .frame(width: 220, height: 200)
    }

    // MARK: - Populated List

    private var populatedListView: some View {
        List {

            NavigationLink {
                MonthlyEstimationDetailView(deviceViewModel: deviceViewModel)
            } label: {
                EstimationStatsView(
                    icon: "creditcard.fill",
                    title: "Monthly", count: deviceViewModel.monthlyEstimate,
                    color: .green, backgroundColor: .clear,
                    font: .title
                )
            }
            .padding(.horizontal)
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)

            HStack {
                EstimationStatsView(
                    icon: "sun.max.fill",
                    title: "Daily",
                    count: deviceViewModel.dailyEstimate,
                    color: .orange,
                    backgroundColor: Color(UIColor.secondarySystemGroupedBackground),
                    font: .headline
                )

                EstimationStatsView(
                    icon: "calendar",
                    title: "Weekly",
                    count: deviceViewModel.weeklyEstimate,
                    color: .cyan,
                    backgroundColor: Color(UIColor.secondarySystemGroupedBackground),
                    font: .headline
                )
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)

            Section {

                ForEach(deviceViewModel.devices) { device in
                    NavigationLink {
                        DeviceDetailView(device: device)
                    } label: {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(Color(.green).opacity(0.2))
                                    .frame(width: 40, height: 40)

                                Image(systemName: "\(device.icon)")
                                    .foregroundColor(.green)
                            }
                            VStack(alignment: .leading) {
                                Text("\(device.name)")
                                    .font(.headline)

                                Text("\(device.power) Watt • \(device.durationPerDay) \((device.durationUnit == .hours) ? "Hours" : "Minutes")")
                                    .font(.subheadline)
                                    .foregroundColor(Color.secondary)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                deviceViewModel.destroyDevice(context, device: device)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button {
                                selectedDevice = device
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.green)
                        }
                    }

                }
            } header: {
                HStack {
                    Text("Device")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.primary)

                    Spacer()

                    Text("\(deviceViewModel.devices.count)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.primary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color(UIColor.secondarySystemGroupedBackground)))
                }
            }
            .textCase(nil)
        }
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .listRowSpacing(7)
        .background(Color.clear)
    }
}

// MARK: - Floating Dot

private struct FloatingDot: View {
    let symbol: String
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let color: Color
    let delay: Double

    @State private var appeared = false

    var body: some View {
        Image(systemName: symbol)
            .font(.system(size: size))
            .foregroundColor(color)
            .offset(x: x, y: y + (appeared ? 0 : 16))
            .opacity(appeared ? 1 : 0)
            .scaleEffect(appeared ? 1 : 0.3)
            .onAppear {
                withAnimation(.spring(response: 0.65, dampingFraction: 0.6).delay(delay)) {
                    appeared = true
                }
            }
    }
}

#Preview {
    DeviceView()
}
