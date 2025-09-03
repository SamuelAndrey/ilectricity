//
//  SettingView.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 31/08/25.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        
        NavigationStack {
            VStack {
                List {
                    Section {
                        NavigationLink {
                            
                        } label: {
                            Text("Rp 1.262")

                        }
                    } header: {
                        Text("Electricity Tariff per kWh")
                            .font(.headline)
                            .fontWeight(.bold)
                            .textCase(nil)
                            
                    } footer: {
                        Text("The standardized electricity tariff applied for each kilowatt-hour of consumption.")
                    }
                    
                    Section {
                        NavigationLink {
                            
                        } label: {
                            Text("Monthly on the 28th")

                        }
                    } header: {
                        Text("Monthly Billing Date")
                            .font(.headline)
                            .fontWeight(.bold)
                            .textCase(nil)
                            
                    } footer: {
                        Text("The designated date on which the electricity bill is issued each month.")
                    }
                    
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingView()
}
