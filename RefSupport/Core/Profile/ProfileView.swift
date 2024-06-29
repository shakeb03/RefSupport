//
//  ProfileView.swift
//  RefSupport
//
//  Created by Shakeb . on 2024-06-11.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isShowingEditProfileSheet = false
    
    var body: some View {
        if let user = viewModel.currentUser{
            List{
                Section{
                    HStack{
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        
                        VStack(alignment:.leading, spacing: 4){
                            Text(user.fullname)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text(user.email)
                                .font(.footnote)
                                .accentColor(.gray)
                        }
                    }
                }
                
                Section("General"){
                    HStack {
                        SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
                        
                        Spacer()
                        
                        Text("1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                Section("Account"){
                    Button{
                        print("Edit profile...")
                        isShowingEditProfileSheet = true
                        
                    } label: {
                        SettingsRowView(imageName: "pencil", title: "Edit Profile", tintColor: .gray)
                    }
                    .sheet(isPresented: $isShowingEditProfileSheet) {
                        EditProfileView(user: user, isShowingSheet: self.$isShowingEditProfileSheet)
                        }
                    
                    Button{
                        viewModel.signOut()
                        
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                    }
                    
                    Button{
                        print("Deactivate..")
                        
                    } label: {
                        SettingsRowView(imageName: "xmark.circle.fill", title: "Deactivate Account", tintColor: .red)
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
