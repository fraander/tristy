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
    @Published var grocery: TristyGrocery
    private var cancellables: Set<AnyCancellable> = []
    var id = ""
    
    init(grocery: TristyGrocery) {
        self.grocery = grocery
        
        $grocery
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
}


struct GroceryView: View {
    enum Focus: Equatable {
        case item, none
        
        static func == (lhs: Focus, rhs: Focus) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
    }
    
    @ObservedObject var groceryVM: GroceryViewModel // TODO: redo how the state is passed (use VM now)
    @State var title = ""
    @State var initialValue = ""
    @FocusState var focus: Focus?
    @State var activeTags: [TristyTag] = []
    @State var toDeleteTag: TristyTag?
    
    var textViews: some View {
        ZStack(alignment: .leading) {
            TextField("", text: $title, onEditingChanged: { _ in
                if title.isEmpty { // check not left empty
                    initialValue = grocery.title
                } else { // update
                    var newGrocery = grocery
                    newGrocery.setTitle(title)
                    GroceryRepository.shared.update(newGrocery)
                }
                
            }, onCommit: {
                if grocery.title.isEmpty {
                    title = initialValue
                }
            })
            .focused($focus, equals: .item)
#if os(iOS)
            .scrollDismissesKeyboard(.immediately)
#endif
            
            Text(grocery.title)
                .opacity(0.0)
                .padding(.trailing, 10)
                .overlay {
                    HStack {
                        Capsule()
                            .frame(maxWidth: grocery.completed ? .infinity : 0, maxHeight: 2, alignment: .leading)
                            .opacity(grocery.completed ? 1 : 0)
                        Spacer()
                    }
                }
                .animation(.easeOut(duration: 0.25), value: grocery.completed)
            
        }
        .allowsHitTesting(!grocery.completed)
        .foregroundColor(grocery.completed ? .secondary : .primary)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    var newGrocery = grocery
                    newGrocery.setCompleted()
                    GroceryRepository.shared.update(newGrocery)
                } label: {
                    Image(systemName: "\(grocery.completed ? "checkmark.circle.fill" : "checkmark.circle")")
                }
                .buttonStyle(.plain)
                .foregroundColor(grocery.completed ? .mint : .accentColor)
                .font(.system(.title2))
                
                textViews
            }
            
            if !activeTags.isEmpty && !grocery.completed {
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
                .animation(Animation.easeInOut, value: grocery.completed)
            }
        }
        .font(.system(.body, design: .rounded))
        .task {
            initialValue = grocery.title
            title = grocery.title
        }
        .alert(item: $toDeleteTag) { tag in
            Alert(
                title: Text("Are you sure you want to remove \(tag.title) from this item?"),
                primaryButton: .cancel(),
                secondaryButton: .destructive(Text("Remove")) {
                    // TODO: fix me
                }
            )
        }
    }
}

struct GroceryView_Previews: PreviewProvider {
    static var previews: some View {
        let grocery = examples[0]
        return GroceryView(grocery: grocery)
    }
}
