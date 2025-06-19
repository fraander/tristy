//
//  GroceryListSection.swift
//  Tristy
//
//  Created by Frank Anderson on 6/15/25.
//


import SwiftUI
import SwiftData

extension EnvironmentValues {
    @Entry var groceryList: GroceryList? = nil
    @Entry var selectedGroceries: Set<PersistentIdentifier> = []
}

struct GroceryListSection: View {
    
    // MARK: Initializers -
    private init(list: GroceryList, isExpanded: Bool, selectedGroceries: Binding<Set<PersistentIdentifier>>, filter: Predicate<Grocery>, sort: [SortDescriptor<Grocery>] = []) {
        self._groceries = Query(filter: filter, sort: sort, animation: .default)
        self.list = list
        self._isExpanded = .init(initialValue: isExpanded)
        self._selectedGroceries = selectedGroceries
    }
    
    /// Creates a section in a parent list which queries a grocery list
    /// - Parameters:
    ///   - list: Which Grocery List to query
    ///   - isExpanded: Should the section be expanded
    ///   - selectedGroceries: Use `@State var selectedGroceries: Set<PersistientIdentifier> = []` in the parent list for this section.
    init(list: GroceryList, isExpanded: Bool, selectedGroceries: Binding<Set<PersistentIdentifier>>) {
        let intValue = list.rawValue
        self.init(
            list: list,
            isExpanded: isExpanded,
            selectedGroceries: selectedGroceries,
            filter: #Predicate { $0.list == intValue }
        )
    }
    
    // MARK: Properties -
    
    @Environment(\.modelContext) var modelContext
    @Environment(Router.self) var router
    @Environment(AddBarStore.self) var abStore
    
    @AppStorage(Settings.HideCompleted.key) var hideCompleted = Settings.HideCompleted.defaultValue
    @AppStorage(Settings.CompletedToBottom.key) var completedToBottom = Settings.CompletedToBottom.defaultValue
    @AppStorage(Settings.CollapsibleSections.key) var collapsibleSections = Settings.CollapsibleSections.defaultValue
    
    var list: GroceryList
    @Query var groceries: [Grocery]
    
    @State var isExpanded = true
    @Binding var selectedGroceries: Set<PersistentIdentifier>
    
    var countCompleted: Int {
        groceries
            .filter { $0.isCompleted }
            .count
    }
    var countTotal: Int { groceries.count }
    var completionProgress: Double { Double(countCompleted) / Double(countTotal) }
    
    func completionFilter(for grocery: Grocery) -> Bool {
        return !hideCompleted || (hideCompleted && !grocery.isCompleted)
    }
    
    struct QueriedList: View {
        
        @Query var groceries: [Grocery]

        init(
            list: GroceryList,
            completedToBottom: Bool,
            hideCompleted: Bool
        ) {
            
            let listInt = list.rawValue
            let filter: Predicate<Grocery> = hideCompleted && list == .active ? #Predicate { $0.list == listInt && $0.completed == 0 } : #Predicate { $0.list == listInt }
            let sort: [SortDescriptor<Grocery>] = completedToBottom && list == .active ? [.init(\.completed, order: .forward), .init(\.title)] : [.init(\.title)]
            
            self._groceries = Query(filter: filter, sort: sort, animation: .easeInOut)
        }
        
        var body: some View {
            ForEach(groceries) { grocery in
                GroceryListRow(grocery: grocery)
                    .id(grocery.id)
                    .listRowSeparator(grocery == groceries.last ? .hidden : .visible)
            }
        }
    }
    
    var content: some View {
        Group {
            QueriedList(list: list, completedToBottom: completedToBottom, hideCompleted: hideCompleted)
            
            if groceries.isEmpty {
                ContentUnavailableView("", systemImage: Symbols.emptyList)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    
#if os(iOS)
    @Environment(\.editMode) var editMode
#endif
    var isEditing: Bool {
#if os(iOS)
        editMode?.wrappedValue.isEditing ?? false || !selectedGroceries.isEmpty
#else
        !selectedGroceries.isEmpty
#endif
    }
    
    var header: some View {
        
        let predicate = collapsibleSections && !(hideCompleted && completionProgress == 1)
        let allSelected = groceries.map(\.id).allSatisfy { selectedGroceries.contains($0) }
        let selectPredicate = isEditing && !allSelected
        
        return HStack {
            
            if selectPredicate {
                Button("Select", systemImage: Symbols.select) {
                    groceries.map(\.id).forEach { selectedGroceries.insert($0) }
                }
                .labelStyle(.iconOnly)
                .transition(.scale)
            }
            
            Text(list.name)
            Spacer()
            
            if list == .active {
                gauge
            }
            
            if predicate {
                Image(systemName: Symbols.expanded)
                    .rotationEffect(isExpanded ? .degrees(0) : .degrees(-90))
                    .transition(.scale)
            }
        }
        .animation(.easeInOut, value: predicate)
        .animation(.easeInOut, value: selectPredicate)
        .onTapGesture {
            if predicate {
                withAnimation { isExpanded.toggle() }
            }
        }
    }
    
    var gaugeLabel: Text {
        Text("\(countCompleted)/^[\(countTotal) grocery](inflect: true)")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    
    var gauge: some View {
        Group {
            if countTotal > 0 {
                ZStack {
                    Gauge(
                        value: completionProgress,
                        label: { gaugeLabel },
                        currentValueLabel: { Text("") },
                        minimumValueLabel: { Text("") },
                        maximumValueLabel: { Text("") }
                    )
                    .gaugeStyle(.accessoryCircularCapacity)
                    .scaleEffect(completionProgress < 1 ? 0.5 : 0)
                    .tint(.accent)
                    
                    Image(systemName: Symbols.complete)
                        .symbolVariant(.fill.circle)
                        .imageScale(.large)
                        .foregroundStyle(.mint)
                        .scaleEffect(completionProgress < 1 ? 0 : 1)
                }
                .animation(.easeInOut, value: completionProgress)
                .animation(.easeInOut, value: completionProgress < 1)
            }
        }
        .frame(height: 36)
    }
    
    var body: some View {
        
        let isExpandedBinding: Binding<Bool> = .init(
            get: { !collapsibleSections || (collapsibleSections && isExpanded) },
            set: { if collapsibleSections { isExpanded = $0 } }
        )
        
        Section(
            isExpanded: isExpandedBinding,
            content: { content },
            header: { header }
        )
        .environment(\.groceryList, list)
        .environment(\.selectedGroceries, selectedGroceries)
    }
}

#Preview {
    List {
        GroceryListSection(list: .active, isExpanded: false, selectedGroceries: .constant([]))
    }
    .applyEnvironment(prePopulate: true)
    .onAppear {
        UserDefaults.standard.set(false, forKey: Settings.HideCompleted.key)
        UserDefaults.standard.set(false, forKey: Settings.CollapsibleSections.key)
    }
}
