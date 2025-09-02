//
//  DeviceDetailView.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 02/09/25.
//

import SwiftUI

struct DeviceDetailView: View {
    
    @State var test: Bool = false
    
    var body: some View {
        if (test) {
            Text("Aku muncull")
        }
            List {
                Section {
                    HStack {
                        Text("Power")
                        Spacer()
                        Text("15 Watt")
                            .foregroundColor(Color.secondary)
                    }
                    
                    HStack {
                        Text("Duration per day")
                        Spacer()
                        Text("24 Hours")
                            .foregroundColor(Color.secondary)
                    }
                    
                    HStack {
                        Text("Frequency")
                        Spacer()
                        Text("30 Day")
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
                            test.toggle()
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
                    
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color(.green).opacity(0.2))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "arrow.down.circle")
                                .foregroundColor(.green)
                        }
                        HStack {
                            VStack(alignment: .leading) {
                                Text("27 Mar 2025")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                
                                Text("Shortage")
                                    .font(.subheadline)
                                    .foregroundColor(Color.secondary)
                            }
                            
                            Spacer()
                            
                            Text("2 Hours")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        
                    }
                    
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color(.red).opacity(0.2))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "arrow.up.circle")
                                .foregroundColor(.red)
                        }
                        HStack {
                            VStack(alignment: .leading) {
                                Text("27 Mar 2025")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                
                                Text("Excess")
                                    .font(.subheadline)
                                    .foregroundColor(Color.secondary)
                            }
                            
                            Spacer()
                            
                            Text("2 Hours")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
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
                            test.toggle()
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
            .navigationTitle("Lamp")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DeviceDetailView()
}
