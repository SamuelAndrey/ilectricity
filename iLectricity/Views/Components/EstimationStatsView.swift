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
    let color: Color
    let backgroundColor: Color
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(color)
                
                Text(title)
                    .fontWeight(.bold)
                    .foregroundColor(color)

            }
            Spacer()
            Text("Rp \(count)")
                .font(.headline)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor)
        )
    }
}


#Preview {
    EstimationStatsView(icon: "creditcard.fill", title: "Monthly", count: 30000, color: .green, backgroundColor: Color(UIColor.secondarySystemGroupedBackground))
}
