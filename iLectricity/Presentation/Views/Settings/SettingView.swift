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
    @State private var tariff = UserDefaults.standard.integer(forKey: UserDefaultsKeys.tariffPerKwh)
    @State private var resetDate = UserDefaults.standard.integer(forKey: UserDefaultsKeys.resetDate)
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        Button {
                            isPresentedTariffSheet = true
                        } label: {
                            HStack {
                               Text("Rp \(tariff)")
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
                                Text("Monthly on the \((Int(resetDate)).ordinal)")
                                   .foregroundColor(.primary)
                                
                               Spacer()
                                
                               Image(systemName: "chevron.forward")
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
                TariffSheetView(tariffPerKWh: $tariff)
            }
            .sheet(isPresented: $isPresentedBillingDateSheet) {
                BillingDateSheetView(frequency: $resetDate)
            }
        }
    }
}

#Preview {
    SettingView()
}
