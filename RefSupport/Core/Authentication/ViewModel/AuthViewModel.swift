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

@MainActor
class AuthViewModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var links: [Link] = []
    
    init(){
        self.userSession = Auth.auth().currentUser
        print("User session details \(userSession)")
        
        Task{
            await fetchUser()
        }
    }
    
    
    func signIn(withEmail email: String, password: String) async throws{
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch{
            print("DEBUG: failed to login with error \(error)")
        }
        
    }
    
    func createUser(withEmail email: String, fullname: String ,password: String) async throws{
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid , fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
            
        } catch{
            print("Debugging: failed to create user with error)")
        }
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch{
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
        
    }
    
    func disableAccount(){
        
    }
    
    func fetchUser() async{
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
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
                    print("Invalid document data")
                    continue
                }

                if let url = URL(string: url) {
                    links.append(Link(title: title, description: description, url: url))
                } else {
                    print("Invalid URL: \(url)")
                }
            }

            return links
        } catch {
            print("Error fetching resources: \(error.localizedDescription)")
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
                      let url = data["URL"] as? String else {
                    print("Invalid document data")
                    continue
                }

                if let url = URL(string: url) {
                    links.append(Link(title: title, description: description, url: url))
                } else {
                    print("Invalid URL: \(url)")
                }
            }

            return links
        } catch {
            print("Error fetching resources: \(error.localizedDescription)")
            return []
        }
    }
}
