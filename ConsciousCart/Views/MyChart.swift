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
    let type: String
    let value: Int
}

struct MyChart: View {
    let items: [Item] = [
        Item(type: "1", value: 100 ),
        Item(type: "2", value: 80 ),
        Item(type: "3", value: 120 ),
        Item(type: "4", value: 20 ),
        Item(type: "5", value: 55 ),
        Item(type: "6", value: 170 ),
        Item(type: "7", value: 20 ),
        Item(type: "8", value: 10 ),
        Item(type: "9", value: 5 ),
        Item(type: "10", value: 1 ),
        Item(type: "11", value: 500 ),
        Item(type: "12", value: 700 ),
        Item(type: "13", value: 700 ),
        Item(type: "14", value: 700 ),
        Item(type: "15", value: 700 ),
        Item(type: "16", value: 700 )
    ]
    
    var body: some View {
        NavigationView {
            ZStack{
                Chart(items) { item in
                    LineMark(
                        x: .value("Month", item.type),
                        y: .value("Revenue", item.value)
                    )
                    .foregroundStyle(Color.purple.gradient)
                }
                .chartYAxis {
                    AxisMarks(position: .trailing, values: .automatic) { value in
                        AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 1))
                        AxisValueLabel() {
                            if let intValue = value.as(Int.self) {
                                Text(intValue, format: .currency(code: Locale.current.currency?.identifier ?? "USD").precision(.fractionLength(0)))
                            }
                        }
                    }
                }
                .padding()
                .frame(height: 200)
            }
        }
    }
}

struct MyChart_Previews: PreviewProvider {
    static var previews: some View {
        MyChart()
    }
}
