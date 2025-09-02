//
//  EstimationStatsView.swift
//  iLectricity
//
//  Created by Samuel Andrey Aji Prasetya on 01/09/25.
//

import SwiftUI

struct EstimationStatsView: View {
    
    let icon: String
    let title: String
    let count: Int
    
    var body: some View {
        GroupBox {
            VStack {
                HStack(spacing: 10) {
                    Image(systemName: icon)
                    Text(title)
                }
                Spacer()
                Text("\(count)")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    EstimationStatsView(icon: "calendar", title: "Monthly", count: 10000)
}
