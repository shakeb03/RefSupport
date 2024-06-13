//
//  HomeView.swift
//  RefSupport
//
//  Created by Shakeb . on 2024-06-12.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            HStack{
//                Resources
                Button{
                    print("Resources fetched..")
                } label: {
                    Text("Resources")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 120, height: 40)
                        .font(.system(size: 16))
                }
                .background(Color(.systemBlue))
                .cornerRadius(10)
                
//                Updates
                Button{
                    print("Updates fetched..")
                } label: {
                    Text("Updates")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 120, height: 40)
                        .font(.system(size: 16))
                }
                .background(Color(.systemBlue))
                .cornerRadius(10)
            }
            .padding(.top, 25)
            Spacer()
        }
    }
}

#Preview {
    HomeView()
}
