//
//  ResourceView.swift
//  RefSupport
//
//  Created by Shakeb . on 2024-06-24.
//

import SwiftUI

struct ResourceView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var links: [Link] = []
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(links, id: \.title) { link in
                    CardView(title: link.title, description: link.description)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 58)
                        .padding(.top, 35)
                        .onTapGesture {
                            // Handle tap gesture to open the link
                            UIApplication.shared.open(link.url)
                            print(link.url)
                        }
                }
            }
        } // Scroll View
        
        .onAppear{
            Task{
                links = await viewModel.fetchExtendedResources()
            }
        }
    } // Body
} // struct

#Preview {
    ResourceView()
}
