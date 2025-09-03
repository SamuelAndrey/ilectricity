//
//  SettingView.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 31/08/25.
//

import SwiftUI

struct SettingView: View {
    
    @State private var isPresentedTariffSheet = false
    @State private var isPresentedBillingDateSheet = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        Button {
                            isPresentedTariffSheet = true
                        } label: {
                            HStack {
                               Text("Rp 1.262")
                                   .foregroundColor(.primary)
                                
                               Spacer()
                                
                               Image(systemName: "chevron.right")
                                    .foregroundColor(Color.secondary)
                           }

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
                        Button {
                            isPresentedBillingDateSheet = true
                        } label: {

                            HStack {
                                Text("Monthly on the 28th")
                                   .foregroundColor(.primary)
                                
                               Spacer()
                                
                               Image(systemName: "chevron.right")
                                    .foregroundColor(Color.secondary)
                           }

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
            .sheet(isPresented: $isPresentedTariffSheet) {
                TariffSheetView()
            }
            .sheet(isPresented: $isPresentedBillingDateSheet) {
                BillingDateSheetView()
            }
        }
    }
}

#Preview {
    SettingView()
}
