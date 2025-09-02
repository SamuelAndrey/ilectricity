//
//  DeviceView.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 31/08/25.
//

import SwiftUI

struct DeviceView: View {
    
    @State var items = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    
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
                        EstimationStatsView(icon: "creditcard.fill", title: "Monthly", count: 10000, color: .green)

                    }
                    .padding(.horizontal)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    
                    HStack {
                        EstimationStatsView(icon: "creditcard.fill", title: "Weekly", count: 10000, color: .yellow)
                        EstimationStatsView(icon: "creditcard.fill", title: "Daily", count: 10000, color: .cyan)
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
                                .background(Capsule().fill(Color(UIColor.systemBackground)))
                        }
                    }
                    .textCase(nil)
                }
                .navigationTitle("Estimation")
                .scrollIndicators(.hidden)
                .scrollContentBackground(.hidden)
                .listRowSpacing(7)
                .background(Color.clear)
            }
        }
    }
}

#Preview {
    DeviceView()
}
