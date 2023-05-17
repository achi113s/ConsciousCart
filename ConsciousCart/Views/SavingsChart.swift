//
//  MyChart.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/26/23.
//

import SwiftUI
import Charts
import Foundation

struct Item: Identifiable {
    var id = UUID()
    let date: Date
    let value: Int
}

struct SavingsChart: View {
    @State private var items: [Item] = [
        Item(date: Date(timeIntervalSince1970: TimeInterval(2394827)), value: 100),
        Item(date: Date(timeIntervalSince1970: TimeInterval(2494827)), value: 80),
        Item(date: Date(timeIntervalSince1970: TimeInterval(2594827)), value: 120),
        Item(date: Date(timeIntervalSince1970: TimeInterval(2694827)), value: 20),
        Item(date: Date(timeIntervalSince1970: TimeInterval(2794827)), value: 55),
        Item(date: Date(timeIntervalSince1970: TimeInterval(2894827)), value: 170),
        Item(date: Date(timeIntervalSince1970: TimeInterval(2994827)), value: 20),
        Item(date: Date(timeIntervalSince1970: TimeInterval(3094827)), value: 10),
        Item(date: Date(timeIntervalSince1970: TimeInterval(3194827)), value: 5),
        Item(date: Date(timeIntervalSince1970: TimeInterval(3294827)), value: 1),
        Item(date: Date(timeIntervalSince1970: TimeInterval(3394827)), value: 500),
        Item(date: Date(timeIntervalSince1970: TimeInterval(3494827)), value: 800),
        Item(date: Date(timeIntervalSince1970: TimeInterval(3594827)), value: 900),
        Item(date: Date(timeIntervalSince1970: TimeInterval(3694827)), value: 1700),
        Item(date: Date(timeIntervalSince1970: TimeInterval(3794827)), value: 2700),
        Item(date: Date(timeIntervalSince1970: TimeInterval(3894827)), value: 3400)
    ]
    
    @State private var buttonIsEnabled: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            Chart(items) { item in
                LineMark(
                    x: .value("Month", item.date.formatted(date: .abbreviated, time: .omitted)),
                    y: .value("Savings", item.value)
                )
                .foregroundStyle(Color("ExodusFruit"))
            }
            .chartYAxis {
                AxisMarks(position: .trailing, values: .automatic) { value in
                    AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 1, dash: [5]))
                    AxisValueLabel() {
                        if let intValue = value.as(Int.self) {
                            Text(intValue, format: .currency(code: Locale.current.currency?.identifier ?? "USD").precision(.fractionLength(0)))
                        }
                    }
                }
            }
            .chartXAxis { }
            
            HStack {
                Button {
                    buttonIsEnabled.toggle()
                } label: {
                    Text("1m")
                        .foregroundColor(buttonIsEnabled ? .white : .black)
                        .font(Font.system(size: 15))
                }
                .background(buttonIsEnabled ? Color("ExodusFruit") : .white)
                .cornerRadius(3)
                
                Button {
                    buttonIsEnabled.toggle()
                } label: {
                    Text("1m")
                        .foregroundColor(buttonIsEnabled ? .white : .black)
                        .font(Font.system(size: 15))
                }
                .background(buttonIsEnabled ? Color("ExodusFruit") : .white)
                .cornerRadius(3)
                
                Button {
                    buttonIsEnabled.toggle()
                } label: {
                    Text("1m")
                        .foregroundColor(buttonIsEnabled ? .white : .black)
                        .font(Font.system(size: 15))
                }
                .background(buttonIsEnabled ? Color("ExodusFruit") : .white)
                .cornerRadius(3)
            }
        }
        .padding()
        .frame(height: 200)
    }
}

struct MyChart_Previews: PreviewProvider {
    static var previews: some View {
        SavingsChart()
    }
}
