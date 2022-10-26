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
    
    init() {
        FirebaseApp.configure()
        AuthenticationService.signIn()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
