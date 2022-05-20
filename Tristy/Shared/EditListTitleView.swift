//
//  EditListTitleVIew.swift
//  Tristy
//
//  Created by Frank Anderson on 5/19/22.
//

import SwiftUI

struct EditListTitleView: View {
    
    @Binding var title: String
    @Binding var editing: Bool
    
    var body: some View {
        VStack {
#if os(iOS)
            HStack {
                Spacer()
                
                Button("Done") {
                    editing.toggle()
                }
            }
            .padding([.horizontal, .top])
            
            HStack {
                Text("Rename List")
                    .font(Font.largeTitle.bold())
                
                Spacer()
            }
            .padding(.horizontal)
#endif
            Form {
                Section("List Title") {
                    TextField("List Title", text: $title)                    
                }
            }
            #if os(macOS)
                .labelsHidden()
                .frame(width: 100)
                .padding(5)
            #endif
        }
    }
}

struct EditListTitleView_Previews: PreviewProvider {
    static var previews: some View {
        EditListTitleView(title: .constant(""), editing: .constant(true))
    }
}
