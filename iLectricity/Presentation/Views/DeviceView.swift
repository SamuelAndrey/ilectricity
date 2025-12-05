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
    
    var body: some View {

        NavigationStack {
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
                    
                    NavigationLink {
                        
                    } label: {
                        EstimationStatsView(
                            icon: "creditcard.fill",
                            title: "Monthly", count: 500000,
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
                            count: 175000,
                            color: .orange,
                            backgroundColor: Color(UIColor.secondarySystemGroupedBackground),
                            font: .headline
                        )
                        
                        EstimationStatsView(
                            icon: "calendar",
                            title: "Weekly",
                            count: 20000,
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
                                DeviceDetailView()
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
            .navigationTitle("Estimation")
            .toolbar(content: {
                ToolbarItem {
                    Button {
                        isPresentedAddDeviceSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                }
            })
            .sheet(isPresented: $isPresentedAddDeviceSheet) {
                AddDeviceSheetView(deviceViewModel: deviceViewModel)
            }
            .sheet(item: $selectedDevice) { device in
                EditDeviceSheetView(device: device)
            }
            .onAppear {
                deviceViewModel.loadDevices(context: context)
            }
        }
        
    }
}

#Preview {
    DeviceView()
}
