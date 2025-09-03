//
//  DeviceView.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 31/08/25.
//

import SwiftUI

struct DeviceView: View {
    
    @State private var items = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    @State private var isPresentedAddDeviceSheet: Bool = false
    
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
                        ]
                    ),
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()
                
                List {
                    
                    NavigationLink {
                        
                    } label: {
                        EstimationStatsView(icon: "creditcard.fill", title: "Monthly", count: 500000, color: .green, backgroundColor: .clear)
                    }
                    .padding(.horizontal)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    
                    HStack {
                        EstimationStatsView(icon: "sun.max.fill", title: "Daily", count: 175000, color: .orange, backgroundColor: Color(UIColor.secondarySystemGroupedBackground))
                        EstimationStatsView(icon: "calendar", title: "Weekly", count: 20000, color: .cyan, backgroundColor: Color(UIColor.secondarySystemGroupedBackground))
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)

                    Section {
                        ForEach(items, id: \.self) { item in
                            NavigationLink {
                                DeviceDetailView()
                            } label: {
                                HStack {
                                    ZStack {
                                        Circle()
                                            .fill(Color(.green).opacity(0.2))
                                            .frame(width: 40, height: 40)
                                        
                                        Image(systemName: "creditcard")
                                            .foregroundColor(.green)
                                    }
                                    VStack(alignment: .leading) {
                                        Text("Light \(item)")
                                            .font(.headline)
                                        
                                        Text("12 Watt • 12 Hours \(item)")
                                            .font(.subheadline)
                                            .foregroundColor(Color.secondary)
                                    }
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    Button {
                                        
                                    } label: {
                                        Label("Flag", systemImage: "flag")
                                    }
                                    .tint(.orange)
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
                            
                            Text("0")
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
                AddDeviceSheetView()
            }
        }
    }
}

#Preview {
    DeviceView()
}
