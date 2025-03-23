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
                            Color.cyan.opacity(0.5),
                            Color.cyan.opacity(0.2),
                            Color.teal.opacity(0.0),
                            Color.teal.opacity(0.0)
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
                                            .foregroundStyle(.cyan)
                                        Text("Estimasi bulanan").bold().foregroundStyle(Color.cyan)
                                    }.padding(.bottom, 1)
                                    
                                    Text("Rp 123.456")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    
                                }
                            }
                            
                            VStack (alignment: .leading) {
                                Spacer()
                                
                                HStack {
                                    Text("Harian")
                                    Spacer()
                                    Text("Rp 123.456")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    
                                }
                                
                                Spacer()
                                
                                HStack {
                                    Text("Mingguan")
                                    Spacer()
                                    Text("Rp 123.456")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                }
                                
                                Spacer()
                            }
                        }
                        
                        /// List device section.
                        Section(header:
                                    HStack {
                            Text("Perangkat")
                                .font(.title3.bold())
                                .foregroundStyle(.white)
                                .textCase(.none)
                            
                            
                            //                            Image(systemName: "display").font(.title3)
                            //                                .foregroundStyle(Color.white)
                            
                            Spacer()
                        }
                            .padding(.leading, -16)
                            .padding(.bottom, 8)
                        ) {
                            ForEach(devices) { device in
                                NavigationLink(destination: DeviceDetailView(device: device)) {
                                    VStack(alignment: .leading) {
                                        Text(device.name).font(.headline)
                                        
                                    }
                                    .padding(.vertical, 8)
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
                                    .foregroundStyle(.cyan).bold()
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
