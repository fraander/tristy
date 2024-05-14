//
//  ContentView.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//

import SwiftUI
import TipKit

struct ContentView: View {
    var body: some View {
        PrimaryView()
            .task {
                #if DEBUG
                try? Tips.resetDatastore()
                #endif
                try? Tips.configure([
                    .displayFrequency(.hourly),
                    .datastoreLocation(.applicationDefault)
                ])
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
