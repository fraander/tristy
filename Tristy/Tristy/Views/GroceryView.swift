//
//  SwiftUIView.swift
//  Tristy
//
//  Created by Frank Anderson on 10/8/22.
//

import SwiftUI
import Combine


class GroceryViewModel: ObservableObject {
    
    private let repo = GroceryRepository.shared
    @Published var grocery: TristyGrocery {
        didSet {
            repo.update(grocery)
        }
    }
    private var cancellables: Set<AnyCancellable> = []
    var id = ""
    
    init(grocery: TristyGrocery) {
        self.grocery = grocery
        
        $grocery
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
    
    public func setTitle(_ title: String) {
        grocery.setTitle(title)
    }
    
    public func setCompleted(_ value: Bool? = nil) {
        grocery.setCompleted(value)
    }
    
    public func remove(tag: TristyTag) {
        grocery.remove(tag: tag)
    }
}


struct GroceryView: View {
    enum Focus: Equatable {
        case item, none
        
        static func == (lhs: Focus, rhs: Focus) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
    }
    
    // TODO: tags need to be references to tags array; some way to clean up if not found
    
    @ObservedObject var groceryVM: GroceryViewModel // TODO: redo how the state is passed (use VM now)
    @State var newTitle = ""
    @State var initialValue = ""
    @FocusState var focus: Focus?
    @State var activeTags: [TristyTag] = []
    @State var toDeleteTag: TristyTag?
    
    var tagsView: some View {
        Group {
            if !activeTags.isEmpty && !groceryVM.grocery.completed {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(activeTags, id: \.title) { tag in
                            Button {
                                toDeleteTag = tag
                            } label: {
                                Text(tag.title.lowercased())
                                    .font(.system(.caption, design: .rounded))
                            }
                            .buttonStyle(.bordered)
                            .tint(.accentColor)
                            .transition(.scale.combined(with: .slide))
                        }
                    }
                    .animation(.spring(), value: activeTags)
                }
                .scrollIndicators(.never)
                .transition(.slide.combined(with: .opacity))
                .animation(Animation.easeInOut, value: groceryVM.grocery.completed)
            }
        }
    }
    
    var checkboxView: some View {
        Button {
            groceryVM.setCompleted()
        } label: {
            Image(systemName: "\(groceryVM.grocery.completed ? "checkmark.circle.fill" : "checkmark.circle")")
        }
        .buttonStyle(.plain)
        .foregroundColor(groceryVM.grocery.completed ? .mint : .accentColor)
        .font(.system(.title2))
    }
    
    var strikethroughView: some View {
        HStack {
            Capsule()
                .frame(maxWidth: groceryVM.grocery.completed ? .infinity : 0, maxHeight: 2, alignment: .leading)
                .opacity(groceryVM.grocery.completed ? 1 : 0)
            Spacer()
        }
    }
    
    var textView: some View {
        ZStack(alignment: .leading) {
            TextField("", text: $newTitle, onEditingChanged: { _ in
                if (newTitle.isEmpty) { // check not left empty
                    newTitle = initialValue // reset to initial value so not blank
                } else { // update
                    groceryVM.setTitle(newTitle) // set the title
                    initialValue = groceryVM.grocery.title // set new initial value checkpoint
                }
                
            })
            .focused($focus, equals: .item)
#if os(iOS)
            .scrollDismissesKeyboard(.immediately)
#endif
            
            Text(groceryVM.grocery.title)
                .opacity(0.0)
                .padding(.trailing, 10)
                .overlay {
                    strikethroughView
                }
                .animation(.easeOut(duration: 0.25), value: groceryVM.grocery.completed)
            
        }
        .allowsHitTesting(!groceryVM.grocery.completed)
        .foregroundColor(groceryVM.grocery.completed ? .secondary : .primary)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                checkboxView
                
                textView
            }
            
            tagsView
        }
        .font(.system(.body, design: .rounded))
        .task {
            // track value before editing
            initialValue = groceryVM.grocery.title
            newTitle = groceryVM.grocery.title
        }
        .alert(item: $toDeleteTag) { tag in
            Alert(
                title: Text("Are you sure you want to remove \(tag.title) from this item?"),
                primaryButton: .cancel(),
                secondaryButton: .destructive(Text("Remove")) {
                    groceryVM.remove(tag: tag)
                }
            )
        }
    }
}

struct GroceryView_Previews: PreviewProvider {
    static var previews: some View {
        let grocery = examples[0]
        return GroceryView(groceryVM: .init(grocery: grocery))
    }
}
