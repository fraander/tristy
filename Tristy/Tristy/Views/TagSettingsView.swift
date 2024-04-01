//
//  TagSettingsView.swift
//  Tristy
//
//  Created by Frank Anderson on 10/25/22.
//

import SwiftUI
import SwiftData

struct TagSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var newTagTitle = ""
    @Query() var tags: [TristyTag]
    
    var body: some View {
        NavigationStack {
            Form {
                newTagSection
                
                List {
                    ForEach(tags) { tag in
                        HStack {
                            Image(systemName: "tag")
                            Text(tag.title)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .navigationTitle("Tags")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var newTagSection: some View {
        Section("Create new tag") {
            TextField("Title", text: $newTagTitle)
                .onSubmit { createTag() }
                .overlay {
                    HStack {
                        Spacer()
                        
                        Image(systemName: "plus")
                            .onTapGesture(perform: createTag)
                            .foregroundColor(.accentColor)
                    }
                }
        }
    }
    
    /// Update the view, and add tag with given details to the repository
    private func createTag() {
        if !newTagTitle.isEmpty {
            let newTag = TristyTag(title: newTagTitle)
            modelContext.insert(newTag)
            
            newTagTitle = ""
        }
    }
    
    /// Delete tags at the given indexes from the repository
    /// - Parameter items: the indecies of the tags to delete
    private func deleteItems(items: IndexSet) {
        items.forEach { modelContext.delete(tags[$0]) }
    }
}

struct TagSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TagSettingsView()
    }
}
