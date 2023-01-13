//
//  TristyApp.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//
import SwiftUI
import FirebaseCore

@main
struct TristyApp: App {
    
    /// Setup Firebase when the app is created.
    init() {
        FirebaseApp.configure()
        AuthenticationService.signIn() // uses Anonymous sign in
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
