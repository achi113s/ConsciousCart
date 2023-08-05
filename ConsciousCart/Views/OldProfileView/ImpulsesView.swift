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
            return "Active Impulses"
        case .pending:
            return "Pending Impulses"
        case .completed:
            return "Completed Impulses"
        }
    }
    
        var body: some View {
            ScrollView {
//                LazyVStack(spacing: 10) {
                List {
                    ForEach(filteredImpulses, id: \.id) { impulse in
                        NavigationLink {
                            ImpulseDetailViewSwiftUI(impulse: impulse, impulsesStateManager: impulsesStateManager)
                        } label: {
                            ImpulseCellView(impulse: impulse, impulseOption: impulseOption)
                        }.buttonStyle(ImpulseCellStyle())
                    }
                }
                .padding(16)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    
//    var body: some View {
//        List {
//            ForEach(filteredImpulses, id: \.id) { impulse in
//                NavigationLink {
//                    ImpulseDetailViewSwiftUI(impulse: impulse, impulsesStateManager: impulsesStateManager)
//                } label: {
//                    ImpulseCellView(impulse: impulse, impulseOption: impulseOption)
//                }
//                .listStyle(.plain)
//                .listRowSeparator(.hidden)
//                .listRowBackground(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(style: .init(lineWidth: 1))
//                        .fill(Color.init(white: 0.9))
//                        .padding(EdgeInsets(top: 5, leading: 1, bottom: 5, trailing: 1))
//                )
//                .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
//            }
//            .onDelete { index in
//                print("delete")
//            }
//        }
//        .padding(EdgeInsets(top: -32, leading: 0, bottom: 0, trailing: 0))
//        .navigationTitle(title)
//        .navigationBarTitleDisplayMode(.inline)
//    }
    
    init(filter: ImpulseOption, impulsesStateManager: ImpulsesStateManager) {
        self.impulseOption = filter
        self.impulsesStateManager = impulsesStateManager
    }
}

//struct ImpulsesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImpulsesView(filter: .completed, impulsesStateManager: nil)
//    }
//}
//
//struct TestCell: View {
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 3) {
//                HStack {
//                    Text("Birkenstock Boston Clog")
//                        .font(Font.custom("Nunito-Bold", size: 20))
//                        .lineLimit(0...2)
//                }
//
//                Text("You spent $158.00!")
//                    .font(Font.custom("Nunito-Regular", size: 12))
//            }
//
//            Spacer()
//
//            Image(systemName: "checkmark.seal")
//                .font(.system(size: 20))
//                .foregroundColor(.red)
//
////            ChevronFromScratch()
//        }
//    }
//}
