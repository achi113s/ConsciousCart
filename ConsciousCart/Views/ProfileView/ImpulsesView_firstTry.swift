////
////  ImpulsesView.swift
////  ConsciousCart
////
////  Created by Giorgio Latour on 7/29/23.
////
//
//import SwiftUI
//
//struct ImpulsesView: View {
//    var impulseOption: ImpulseOption? = nil
//    var impulsesStateManager: ImpulsesStateManager? = nil
//    
//    @State private var impulses: [Impulse] = []
//    
//    var body: some View {
//        ScrollView {
//            LazyVStack {
//                ForEach(impulses, id: \.id) { impulse in
//                    ImpulseCellView(name: impulse.unwrappedName, price: impulse.price, remindDate: impulse.unwrappedRemindDate)
//                }
//            }
//        }
//    }
//    
//    init(impulseOption: ImpulseOption? = nil, impulsesStateManager: ImpulsesStateManager? = nil) {
//        self.impulseOption = impulseOption
//        self.impulsesStateManager = impulsesStateManager
//        
//        switch self.impulseOption {
//        case .active:
//            self.impulses = impulsesStateManager?.impulses ?? []
//        case .pending:
//            self.impulses = impulsesStateManager?.pendingImpulses ?? []
//        case .completed:
//            self.impulses = impulsesStateManager?.completedImpulses ?? []
//        default:
//            self.impulses = []
//        }
//    }
//}
//
//struct ImpulsesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImpulsesView()
//    }
//}
