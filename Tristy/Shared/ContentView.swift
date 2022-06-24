//
// ContentView.swift
// SimpleToDo
//
// Copyright © 2022 Paul Hudson.
// Licensed under MIT license.
//
// https://github.com/twostraws/simple-swiftui
// See LICENSE for license information
//

import SwiftUI

/// The main listing view for the app, showing all to do items for the user to select from.
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: TristyList.entity(),
        sortDescriptors: [
            //            NSSortDescriptor(keyPath: \CD_Card._term, ascending: true),
            //            NSSortDescriptor(keyPath: \CD_Card._definition, ascending: true),
            //            NSSortDescriptor(keyPath: \CD_Card.objectID, ascending: true)
        ]
    ) var lists: FetchedResults<TristyList>
    @State var selectedList = Set<TristyList>()
    
    var body: some View {
        List(lists, id: \._id, selection: $selectedList) { list in
            Text(list._title)
        }
    }
}
