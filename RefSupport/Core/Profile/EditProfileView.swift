//
//  EditProfileView.swift
//  RefSupport
//
//  Created by Shakeb . on 2024-06-29.
//

import SwiftUI

struct EditProfileView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isLoading = false
    
    @Binding var isShowingSheet: Bool
    let user: User
    @State private var fullName = ""
    
    init(user: User, isShowingSheet: Binding<Bool>) {
        self.user = user
        self._isShowingSheet = isShowingSheet
        self._fullName = State(initialValue: user.fullname)
        }
    
    var body: some View {
        if isLoading{
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(3)
        } else {
            VStack{
                Text(user.initials )
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 100, height: 100)
                    .background(Color(.systemGray3))
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .padding(40)
                
                InputView(text: $fullName, title: "Full Name", placeholder: "Enter Full Name")
                    .padding(.horizontal)
                    .padding(.top, 12)
                
                Button{
                    Task{
                        print("edit")
                        isLoading = true
                        try await viewModel.updateFullName(of: user, to: fullName)
                        isLoading = false
                        isShowingSheet = false
                    }
                } label: {
                    HStack{
                        Text("Update Profile")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 12)
                Spacer()
                
            }
        }
    }
}

extension EditProfileView: EditProfileFormProtocol{
    var formIsValid: Bool {
        return !fullName.isEmpty
        && user.fullname != fullName
    }
}

#Preview {
//    @State var isShowingSheet = true
    EditProfileView(user: User(id: NSUUID().uuidString, fullname: "Cristiano Ronaldo", email: "cr@test.com"), isShowingSheet: .constant(true))
//    EditProfileView()
}
