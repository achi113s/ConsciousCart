//
//  ImpulsesView.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/29/23.
//

import CoreData
import SwiftUI

struct ImpulsesView: View {
    @FetchRequest(sortDescriptors: []) var impulses: FetchedResults<Impulse>
    
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
                ForEach(impulses, id: \.id) { impulse in
                    ImpulseCellView(name: impulse.unwrappedName, price: impulse.price, remindDate: impulse.unwrappedRemindDate)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    init(filter: ImpulseOption) {
        self.impulseOption = filter
    }
}

struct ImpulsesView_Previews: PreviewProvider {
    static var previews: some View {
        ImpulsesView(filter: .active)
    }
}
