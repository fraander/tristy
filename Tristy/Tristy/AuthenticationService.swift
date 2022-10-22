//
//  AuthenticationService.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//

import Firebase

// TODO: do some sort of group auth to allow people to join groups and share (accounts + other auth)

class AuthenticationService: ObservableObject {
    @Published var user: User?
    private var authenticationStateHandler: AuthStateDidChangeListenerHandle?
    
    init() {
        addListeners()
    }
    
    static func signIn() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously()
        }
    }
    
    private func addListeners() {
        if let handle = authenticationStateHandler {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        
        authenticationStateHandler = Auth.auth()
            .addStateDidChangeListener { _, user in
                self.user = user
            }
    }
    
}
