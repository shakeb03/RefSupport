//
//  HomeView.swift
//  RefSupport
//
//  Created by Shakeb . on 2024-06-12.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var links: [Link] = []
    
    // Dummy Links
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
    
    
    var body: some View {
        
        NavigationView{
            
            VStack {
                
                HStack{
                    // Resources
                    NavigationLink(destination: ResourceView()){
                        Text("Resources")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 120, height: 40)
                            .font(.system(size: 16))
                            .background(Color(.systemBlue))
                            .cornerRadius(10)
                    }
                    
                    // Updates
                    NavigationLink(destination: UpdatesView()){

                        Text("Updates")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 120, height: 40)
                            .font(.system(size: 16))
                            .background(Color(.systemBlue))
                            .cornerRadius(10)
                    }
                    
                }
                .padding(.top, 25)
                
                // Today's Date
                Text("Today's date: \(DateFormatter.localizedString(from: Date(), dateStyle:.medium, timeStyle:.none))")
                    .font(.system(size: 32))
                    .foregroundColor(.blue)
                    .padding(.top, 20)
                Spacer()
                
                // Card view for resources (temporary)
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
                }
                
            }
            .onAppear{
                Task{
                    links = await viewModel.fetchResources()
                }
            }
        }
    } // body
} // struct


#Preview {
    HomeView()
}
