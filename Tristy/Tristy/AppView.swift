//
//  AppView.swift
//  Tristy
//
//  Created by frank on 7/12/26.
//

import SwiftUI

struct AppView: View {

    @State var router = Router()
    @State var addBarService = AddBarService()

    var body: some View {
        ContentView()
            .environment(router)
            .focusedSceneValue(router)
        
            .environment(addBarService)
            .focusedSceneValue(addBarService)
    }
}
