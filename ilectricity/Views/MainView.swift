//
//  MainView.swift
//  ilectricity
//
//  Created by Samuel Andrey Aji Prasetya on 18/03/25.

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var devices: [Device]
    @EnvironmentObject private var viewModel: DeviceViewModel
    
    @State private var isShowingAddDeviceSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Color.green.opacity(0.4),
                            Color.green.opacity(0.1),
                            Color.green.opacity(0.0),
                            Color.green.opacity(0.0)
                        ]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack {
                    List {
                        /// Report estimation section.
                        Section {
                            NavigationLink {
                               
                            } label: {
                                VStack (alignment: .leading) {
                                    HStack {
                                        Image(systemName: "creditcard.fill")
                                            .foregroundStyle(.red)
                                        Text("Estimasi bulanan").bold()
                                    }.padding(.bottom, 1)
                                    
                                    Text("Rp 123.456")
                                        .font(.headline)
                                        .foregroundStyle(.green)
                                    
                                }
                            }
                            
                            VStack (alignment: .leading) {
                                Spacer()
                                
                                HStack {
                                    Text("Mingguan")
                                    Spacer()
                                    Text("Rp 123.456")
                                        .font(.headline)
                                        .foregroundStyle(.green)
                                    
                                }
                                
                                Spacer()
                                
                                HStack {
                                    Text("Bulanan")
                                    Spacer()
                                    Text("Rp 123.456")
                                        .font(.headline)
                                        .foregroundStyle(.green)
                                }
                                
                                Spacer()
                            }
                        }
                        
                        /// List device section.
                        Section(header:
                                    HStack {
                            Text("Perangkat")
                                .font(.title3.bold())
                                .foregroundStyle(.red)
                                .textCase(.none)
            
                            
                            Image(systemName: "display").font(.title3)
                                .foregroundStyle(Color.red)
                            
                            Spacer()
                        }
                            .padding(.leading, -20)
                            .padding(.bottom, 8)
                        ) {
                            ForEach(devices) { device in
                                NavigationLink(destination: DeviceDetailView(device: device)) {
                                    VStack(alignment: .leading) {
                                        Text(device.name).font(.headline)
                                        Text("\(device.powerConsumption) Watt").font(.subheadline).foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .onDelete(perform: deleteDevices)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .navigationTitle("Estimasi")
                    .toolbar {
                        ToolbarItem {
                            Button(action: {
                                isShowingAddDeviceSheet.toggle()
                            }) {
                                Image(systemName: "plus")
                                    .foregroundStyle(.green).bold()
                            }
                        }
                    }
                } /// End Main VStack
                .sheet(isPresented: $isShowingAddDeviceSheet) {
                    AddDeviceView(isPresented: $isShowingAddDeviceSheet)
                }
            }
        }
    }
    
    private func deleteDevices(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                viewModel.deleteDevice(devices[index])
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Device.self, configurations: config)
        let context = container.mainContext
        let viewModel = DeviceViewModel(modelContext: context)
        
        viewModel.addDevice(name: "AC Kamar", powerConsumption: 789, usageDuration: 5, frequencyPerMonth: 30, usageUnit: .hours)
        
        return MainView()
            .modelContainer(container)
            .environmentObject(viewModel)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
