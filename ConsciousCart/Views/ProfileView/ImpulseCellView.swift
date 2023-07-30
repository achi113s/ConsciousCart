//
//  ImpulseCellView.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/29/23.
//

import CoreData
import SwiftUI

struct ImpulseCellView: View {

    @State var name: String
    @State var price: String
    @State var daysRemaining: String
    
    var body: some View {
        VStack {
            Button {
                
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("\(name), \(price)")
                            .font(Font.custom("Nunito-Bold", size: 20))
                            .lineLimit(0...2)
                        
                        Text("\(daysRemaining)")
                            .font(Font.custom("Nunito-Regular", size: 12))
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.init(white: 0.6))
                        .font(.system(size: 12))
                }
            }
            .buttonStyle(ImpulseCellStyle())
        }
    }
    
    init(name: String, price: Double, remindDate: Date) {
        self.name = name
        self.price = String(price).asCurrency(locale: Locale.current) ?? "$0.00"
        self.daysRemaining = Utils.remainingTimeMessageForDate(remindDate).0
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

struct ImpulseCellStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
            .background(configuration.isPressed ? Color(white: 0.8) : .white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(style: .init(lineWidth: 1))
                    .fill(Color.init(white: 0.9))
            )
    }
}
