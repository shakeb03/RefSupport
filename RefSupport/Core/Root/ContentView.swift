//
//  ContentView.swift
//  RefSupport
//
//  Created by Shakeb . on 2024-06-11.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        Group{
            if viewModel.userSession != nil{
                TabView{
                    HomeView()
                        .tabItem() {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    ProfileView()
                        .tabItem() {
                            Image(systemName: "gear")
                            Text("Profile")
                        }
                }
            }
            else{
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
