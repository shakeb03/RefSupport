//
//  ExtendedUpdatesView.swift
//  RefSupport
//
//  Created by Shakeb . on 2024-06-28.
//

import SwiftUI

struct ExtendedUpdatesView: View {
    let selectedLink: Link
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(selectedLink.title)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding(25)
            
            Text(selectedLink.datePosted!)
                .font(.footnote)
                .fontWeight(.semibold)
                .padding(.leading, 25)
            
            Button{
                Task{
                    UIApplication.shared.open(selectedLink.url)
                }
            } label: {
                HStack{
                    Text("View")
                        .font(.system(size: 10))
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 350, height: 25)
            }
            .background(Color(.systemBlue))
            .cornerRadius(10)
            .padding(.leading, 25)
        
            Spacer()
            
        }
        
        
    }
}

#Preview {
    ExtendedUpdatesView(selectedLink: Link(title: "Link 3", description: "This is a description of link 3", datePosted: "May 31, 2024", url: URL(string: "https://www.example.com/link3")!))
}
