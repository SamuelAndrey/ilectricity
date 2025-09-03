//
//  TariffSheetView.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 03/09/25.
//

import SwiftUI

struct TariffSheetView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var tariffPerKWh: Int?
    
    var body: some View {
        NavigationStack {
            Form {
                
                LabeledContent("Tariff per kWh") {
                    TextField("Rp 1.262", value: $tariffPerKWh, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
            }
            .hideKeyboardWhenTappedAround()
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
            .navigationTitle("Tariff")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        //
                        dismiss()
                    } label: {
                        Text("Save")
                            .fontWeight(.bold)
                    }
                }
            })
        }
    }
}

#Preview {
    TariffSheetView()
}
