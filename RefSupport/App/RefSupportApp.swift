//
//  RefSupportApp.swift
//  RefSupport
//
//  Created by Shakeb . on 2024-06-11.
//

import SwiftUI
import Firebase

@main
struct RefSupportApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
