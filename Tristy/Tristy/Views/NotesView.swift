//
//  NotesView.swift
//  peaty
//
//  Created by Frank Anderson on 1/28/25.
//

import SwiftUI
import HighlightedTextEditor

struct NotesView: View {
    @SceneStorage("showNotes") var showNotes: Bool = false
    @AppStorage("notesContents") var notesContents: String = ""
    @Binding var text: String
    
    var body: some View {
        VStack {
            HStack {
             
                Button {
                    notesContents = ""
                } label: {
                    Image(systemName: "eraser.line.dashed")
                        .frame(width: 20, height: 20)
                }
                .buttonBorderShape(.circle)
                .tint(.secondary)
                .buttonStyle(.bordered)
                
                Spacer()
                
                Button {
                    showNotes.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .frame(width: 20, height: 20)
                }
                .buttonBorderShape(.circle)
                .tint(.secondary)
                .buttonStyle(.bordered)

            }
            
            HighlightedTextEditor(text: $text, highlightRules: .markdown + .url)
                .overlay(alignment: .topLeading) {
                    Text("Put some notes here ...")
                        .foregroundStyle(.secondary)
                        .padding(4)
                        .padding(.top, 4)
                        .opacity(!notesContents.isEmpty ? 0 : 0.5)
                        .animation(.easeIn, value: notesContents)
                }
        }
    }
}
