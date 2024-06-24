//
//  CardView.swift
//  RefSupport
//
//  Created by Shakeb . on 2024-06-19.
//

import SwiftUI

struct CardView: View {
    
    let title: String
    let description: String

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .padding(.bottom, 2)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
            }
            Spacer()
        }
            .frame(minWidth: UIScreen.main.bounds.width - 95)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        .frame(width: UIScreen.main.bounds.width - 55, height: 58)
    }
}

#Preview {
    CardView(title: "title here", description: "description here")
}
