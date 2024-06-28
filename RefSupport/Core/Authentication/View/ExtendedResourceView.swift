//
//  ExtendedResourceView.swift
//  RefSupport
//
//  Created by Shakeb . on 2024-06-28.
//

import SwiftUI

struct ExtendedResourceView: View {
    
    let dummy_links = [
            Link(title: "Link 1", description: "This is a description of link 1", url: URL(string: "https://www.example.com/link1")!),
            Link(title: "Link 2", description: "This is a description of link 2", url: URL(string: "https://www.google.com")!),
            Link(title: "Link 3", description: "This is a description of link 3", url: URL(string: "https://www.example.com/link3")!),
            Link(title: "Link 1", description: "This is a description of link 1", url: URL(string: "https://www.example.com/link1")!),
            Link(title: "Link 2", description: "This is a description of link 2", url: URL(string: "https://www.example.com/link2")!),
            Link(title: "Link 3", description: "This is a description of link 3", url: URL(string: "https://www.example.com/link3")!),
            Link(title: "Link 1", description: "This is a description of link 1", url: URL(string: "https://www.example.com/link1")!),
            Link(title: "Link 2", description: "This is a description of link 2", url: URL(string: "https://www.example.com/link2")!),
            Link(title: "Link 3", description: "This is a description of link 3", url: URL(string: "https://www.example.com/link3")!),
            Link(title: "Link 1", description: "This is a description of link 1", url: URL(string: "https://www.example.com/link1")!),
            Link(title: "Link 2", description: "This is a description of link 2", url: URL(string: "https://www.example.com/link2")!),
            Link(title: "Link 3", description: "This is a description of link 3", url: URL(string: "https://www.example.com/link3")!)
            
        ]
    
    let links: [Link]
    let selectedLink: Link
    
    var body: some View {
        ScrollView {
            VStack {
                
                ForEach(links.filter { $0.parentField == selectedLink.title}, id: \.title) { link in
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
    }
}

#Preview {
    ExtendedResourceView(links: [Link(title: "Link 3", description: "This is a description of link 3", url: URL(string: "https://www.example.com/link3")!),
                                 Link(title: "Link 3", description: "This is a description of link 3", url: URL(string: "https://www.example.com/link3")!)], selectedLink: Link(title: "Link 3", description: "This is a description of link 3", url: URL(string: "https://www.example.com/link3")!))
}
