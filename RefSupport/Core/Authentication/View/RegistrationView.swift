//
//  RegistrationView.swift
//  RefSupport
//
//  Created by Shakeb . on 2024-06-11.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var fullname = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var isLoading = false
    
    var body: some View {
        if isLoading{
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(3)
        } else {
            NavigationStack{
                //Image
                Image("sign in image")
                    .resizable()
                    .scaledToFill()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 120)
                    .padding(.vertical, 32)
                
                //Registration form
                VStack{
                    InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    
                    InputView(text: $fullname, title: "Enter Full Name", placeholder: "Full Name")
                    
                    InputView(text: $password, title: "Password", placeholder: "Enter your Password", isSecureField: true)
                    
                    InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Re-Enter your Password", isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                //Sign up button
                Button{
                    Task{
                        isLoading = true
                        try await viewModel.createUser(withEmail: email, fullname: fullname, password:password)
                        isLoading = false
                    }
                } label: {
                    HStack{
                        Text("Sign Up")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
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
                
                //sign in link
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3){
                        Text("Already have an account?")
                        Text("Sign In")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    .font(.system(size: 14))
                }
                
                }
        }
        }
    }

extension RegistrationView: AuthenticationFormProtocol{
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !fullname.isEmpty
    }
}

#Preview {
    RegistrationView()
}
