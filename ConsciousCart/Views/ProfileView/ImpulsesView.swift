//
//  ImpulsesView.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/29/23.
//

import CoreData
import SwiftUI

struct ImpulsesView: View {
    @FetchRequest(entity: Impulse.entity(), sortDescriptors: []) var impulses: FetchedResults<Impulse>
    
    var impulsesStateManager: ImpulsesStateManager! = nil
    
    var impulseOption: ImpulseOption = .active
    
    var filteredImpulses: [Impulse] {
        switch impulseOption {
        case .active:
            return impulses.filter { !$0.completed && ($0.unwrappedRemindDate > Date.now)}
        case .pending:
            return impulses.filter { !$0.completed && ($0.unwrappedRemindDate < Date.now)}
        case .completed:
            return impulses.filter { $0.completed }.sorted(by: { $0.unwrappedCompletedDate < $1.unwrappedCompletedDate })
        }
    }
    
    var title: String {
        switch impulseOption {
        case .active:
            return "🛍️  Active Impulses"
        case .pending:
            return "⏱️  Pending Impulses"
        case .completed:
            return "✅  Completed Impulses"
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(filteredImpulses, id: \.id) { impulse in
                    NavigationLink {
                        ImpulseDetailViewSwiftUI(impulse: impulse, impulsesStateManager: impulsesStateManager)
                    } label: {
                        ImpulseCellView(impulse: impulse, impulseOption: impulseOption)
                    }
                    .buttonStyle(ImpulseCellStyle())
                }
            }
            .frame(maxWidth: .infinity)
            .padding(16)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    init(filter: ImpulseOption, impulsesStateManager: ImpulsesStateManager) {
        self.impulseOption = filter
        self.impulsesStateManager = impulsesStateManager
    }
}
