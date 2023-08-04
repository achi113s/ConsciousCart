//
//  ImpulseCellView.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/29/23.
//

import CoreData
import SwiftUI

struct ImpulseCellView: View {
    var impulseOption: ImpulseOption = .active
    var impulse: Impulse  // should be a binding?
    
    var body: some View {
        ImpulseCellContent(impulseOption: impulseOption, impulse: impulse)
    }
    
    init(impulse: Impulse, impulseOption: ImpulseOption) {
        self.impulse = impulse
        self.impulseOption = impulseOption
    }
}

//struct ImpulseCellView_Previews: PreviewProvider {
//    static let name: String = "Birkenstock Boston Clog"
//    static let price: String = "158".asCurrency(locale: Locale.current) ?? "$0.00"
//    static let daysRemaining: String = "⏳ 31 days remaining"
//    static var previews: some View {
//        ImpulseCellView(name: name, price: price, daysRemaining: daysRemaining)
//    }
//}

struct ImpulseCellContent: View {
    var impulseOption: ImpulseOption
    var impulse: Impulse
    
    var body: some View {
        impulseContent
    }
    
    @ViewBuilder var impulseContent: some View {
        switch impulseOption {
        case .active:
            viewOne
        case .pending:
            viewTwo
        case .completed:
            viewThree
        }
    }
    
    private var viewOne: some View {
        let price = String(impulse.price).asCurrency(locale: Locale.current) ?? "$0.00"
        let daysRemaining = Utils.remainingTimeMessageForDate(impulse.unwrappedRemindDate).0
        
        return HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("\(impulse.unwrappedName), \(price)")
                    .font(Font.custom("Nunito-Bold", size: 20))
                    .lineLimit(0...2)
                
                Text("\(daysRemaining)")
                    .font(Font.custom("Nunito-Regular", size: 12))
            }
            
            Spacer()
            
//            ChevronFromScratch()
        }
    }
    
    private var viewTwo: some View {
        let price = String(impulse.price).asCurrency(locale: Locale.current) ?? "$0.00"
        
        return HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("\(impulse.unwrappedName), \(price)")
                    .font(Font.custom("Nunito-Bold", size: 20))
                    .lineLimit(0...2)
                
                Text("⌛️ \(impulse.daysSinceExpiry) Overdue")
                    .font(Font.custom("Nunito-Regular", size: 12))
            }
            
            Spacer()
            
//            ChevronFromScratch()
        }
    }
    
    private var viewThree: some View {
        let price = String(impulse.price).asCurrency(locale: Locale.current) ?? "$0.00"
        var savedMessage: String = ""
        var sealColor: Color = .black
        
        if impulse.amountSaved == 0 {
            savedMessage = "You didn't save anything!"
        } else if impulse.amountSaved > 0 {
            savedMessage = "You saved \(price)!"
            sealColor = .green
        } else if impulse.amountSaved < 0 {
            savedMessage = "You spent \(price)!"
            sealColor = .red
        }
        
        return HStack {
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text("\(impulse.unwrappedName)")
                        .font(Font.custom("Nunito-Bold", size: 20))
                        .lineLimit(0...2)
                }
                
                Text(savedMessage)
                    .font(Font.custom("Nunito-Regular", size: 12))
            }
            
            Spacer()
            
            Image(systemName: "checkmark.seal")
                .font(.system(size: 20))
                .foregroundColor(sealColor)
            
//            ChevronFromScratch()
        }
    }
}
