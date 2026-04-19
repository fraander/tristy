//
//  SortActions.swift
//  Tristy
//
//  Created by Frank Anderson on 6/29/25.
//

import SwiftUI

struct SortActions: View {
    
    @AppStorage(Settings.ListSort.key) var selected = Settings.ListSort.defaultValue
    let choices = Settings.ListSort.SortOption.allCases
    
    var body: some View {
        CaptionedListRow {
            
            LabeledContent {
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    ForEach(choices) { choice in
                        Button {
                            if selected.contains(choice) {
                                selected.removeAll { $0 == choice }
                            } else {
                                selected.append(choice)
                            }
                        } label: {
                            if selected.contains(choice) {
                                Label(choice.title, systemImage: "checkmark")
                            } else {
                                Text(choice.title)
                            }
                        }
                    }
                }
                .frame(height: 28)
            } label: {
                Label("Sorting", systemImage: "arrow.up.arrow.down")
                    .symbolVariant(.circle)
                    .symbolVariant(selected.count > 0 ? .fill : .none)
                    .contentTransition(.symbolEffect)
            }
        } caption: {
            Text("Sorting by \(Text(selected.map(\.title) + ["Title"], format: .list(type: .and)))")
            
        }
    }
}

#Preview {
    List {
        SortActions()
    }
}
