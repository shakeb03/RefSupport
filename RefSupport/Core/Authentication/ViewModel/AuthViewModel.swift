//
//  AuthViewModel.swift
//  RefSupport
//
//  Created by Shakeb . on 2024-06-12.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol{
    var formIsValid: Bool { get }
}

protocol EditProfileFormProtocol{
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var links: [Link] = []
    
    init(){
        self.userSession = Auth.auth().currentUser
        Task{
            await fetchUser()
        }
    }
    
    
    func signIn(withEmail email: String, password: String) async throws{
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            await fetchUser()
            if let currentUser = currentUser, !(currentUser.isDisabled ?? false) {
                self.userSession = result.user
            }
            
        } catch let error as NSError {
            if error.code == 17004 || error.code == 17009 { // or any other error code you're expecting
                let customError = NSError(domain: "AuthenticationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid email or password. Please try again."])
                    showErrorPopup(error: customError)
                        } else {
                            showErrorPopup(error: error)
                        }
        }
        
    }
    
    func createUser(withEmail email: String, fullname: String ,password: String) async throws{
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid , fullname: fullname, email: email, isDisabled: false)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
            
        } catch{
            showErrorPopup(error: error)
        }
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch{
            showErrorPopup(error: error)
        }
        
    }
    
    func disableAccount(user: User) async{
        do {
            let userRef = Firestore.firestore().collection("users").document(user.id)
            try await userRef.updateData(["isDisabled": true])
            signOut()
        } catch {
            showErrorPopup(error: error)
        }

    }
    
    func deleteAccount(user: User) async {
        do {
            let userRef = Firestore.firestore().collection("users").document(user.id)
            try await userRef.delete()
            try await Firebase.Auth.auth().currentUser?.delete()
            signOut()
        } catch {
            showErrorPopup(error: error)
        }
    }
    
    func fetchUser() async{
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        if currentUser?.isDisabled == true {
            let customError = NSError(domain: "AuthenticationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Account Deactive. Please try after some time."])
            showErrorPopup(error: customError)
            signOut()
        }
    }
    
    func fetchResources() async -> [Link] {
        let db = Firestore.firestore()
        let resourcesRef = db.collection("resources")

        do {
            let snapshot = try await resourcesRef.getDocuments()
            var links: [Link] = []

            for document in snapshot.documents {
                let data = document.data()
                guard let title = data["title"] as? String,
                      let description = data["description"] as? String,
                      let url = data["URL"] as? String else {
                    let customError = NSError(domain: "AuthenticationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid document data."])
                    showErrorPopup(error: customError)
                    continue
                }

                if let url = URL(string: url) {
                    links.append(Link(title: title, description: description, url: url))
                } else {
                    let customError = NSError(domain: "AuthenticationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid Url."])
                    showErrorPopup(error: customError)
                }
            }

            return links
        } catch {
            showErrorPopup(error: error)
            return []
        }
    }
    
    func fetchExtendedResources() async -> [Link] {
        let db = Firestore.firestore()
        let resourcesRef = db.collection("resources_extended")

        do {
            let snapshot = try await resourcesRef.getDocuments()
            var links: [Link] = []

            for document in snapshot.documents {
                let data = document.data()
                guard let title = data["title"] as? String,
                      let description = data["description"] as? String,
                      let viewValue = data["viewValue"] as? Int,
                      let parentField = data["parentField"] as? String,
                      let url = data["URL"] as? String else {
                    let customError = NSError(domain: "AuthenticationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid document data."])
                    showErrorPopup(error: customError)
                    continue
                }

                if let url = URL(string: url) {
                    links.append(Link(title: title, description: description, url: url, viewValue: viewValue, parentField: parentField))
                } else {
                    let customError = NSError(domain: "AuthenticationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
                    showErrorPopup(error: customError)
                }
            }

            return links
        } catch {
            showErrorPopup(error: error)
            return []
        }
    }
    
    func fetchUpdates() async -> [Link] {
            let db = Firestore.firestore()
            let resourcesRef = db.collection("ircc_updates")
            
            do {
                let snapshot = try await resourcesRef.getDocuments()
                var links: [Link] = []
                for document in snapshot.documents {
                    let data = document.data()
                    guard let title = data["title"] as? String,
                          let description = data["content"] as? String,
                          let datePosted = data["datePosted"] as? String,
                          let url = data["URL"] as? String else {
                        let customError = NSError(domain: "AuthenticationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid document data."])
                        showErrorPopup(error: customError)
                        continue
                    }
                    if let url = URL(string: url) {
                        links.append(Link(title: title, description: description, datePosted: datePosted, url: url))
                    } else {
                        let customError = NSError(domain: "AuthenticationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL."])
                        showErrorPopup(error: customError)
                    }
                }
                return links
            } catch {
                showErrorPopup(error: error)
                return []
            }
        }
    
    func updateFullName(of user: User, to newFullName: String) async throws {
        do {
            let userRef = Firestore.firestore().collection("users").document(user.id)
            try await userRef.updateData(["fullname": newFullName])
            await fetchUser()
        } catch {
            showErrorPopup(error: error)
        }
    }
    
    func showErrorPopup(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        // Present the alert
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }

}
