//
//  TagSettingsView.swift
//  Tristy
//
//  Created by Frank Anderson on 10/25/22.
//

import SwiftUI

struct TagSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var groceryRepository: GroceryRepository
    @State var newTagTitle = ""
    
    var body: some View {
        NavigationStack {
            Form {
                newTagSection
                
                List {
                    ForEach(groceryRepository.tags) { tag in
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
    
    private func createTag() {
        if !newTagTitle.isEmpty {
            let newTag = TristyTag(title: newTagTitle)
            groceryRepository.addTags(newTag)
            
            newTagTitle = ""
        }
    }
    
    private func deleteItems(items: IndexSet) {
        items.forEach { groceryRepository.removeTags(groceryRepository.tags[$0]) }
    }
}

struct TagSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TagSettingsView(groceryRepository: GroceryRepository())
    }
}
