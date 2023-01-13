//
//  AuthenticationService.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//

import Firebase

/// Manages user authentication with firebase
class AuthenticationService: ObservableObject {
    @Published var user: User?
    private var authenticationStateHandler: AuthStateDidChangeListenerHandle?
    
    /// Authenticate user on creation of service
    init() {
        addListeners()
    }
    
    /// Sign in the user if user is not yet signed in
    static func signIn() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously()
        }
    }
    
    /// authenticate user and listen for changes
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
