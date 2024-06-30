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
    @State private var isPresented = false
    @State private var selectedLink: Link?
    
    var body: some View {
        ScrollView {
            VStack {
                
                    ForEach(links.filter { $0.viewValue == 1}, id: \.title) { link in
                        CardView(title: link.title, description: link.description)
                            .frame(width: UIScreen.main.bounds.width - 32, height: 58)
                            .padding(.top, 35)
                            .onTapGesture {
                                // Handle tap gesture to open the link
                                isPresented = true
                                selectedLink = link
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
        .sheet(isPresented: $isPresented) {
                    if let selectedLink = selectedLink {
                        ExtendedResourceView(links: links, selectedLink: selectedLink)
                    }
                }
    } // Body
} // struct

#Preview {
    ResourceView()
}
