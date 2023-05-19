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
    let value: Double
}

enum SavingsChartTimeSpan: String, CaseIterable, Identifiable {
    case threeMonths = "3M"
    case sixMonths = "6M"
    case oneYear = "1Y"
    case allTime = "All"
    var id: Self { self }
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
        Item(date: Date(timeIntervalSince1970: TimeInterval(3894827)), value: 3400.23)
    ]
    
    @State private var buttonIsEnabled: Bool = true
    @State private var selectedChartTimeSpan: SavingsChartTimeSpan = .allTime
    
    private var cumSum: Double {
        return cumSumOverTimeSpan(selectedChartTimeSpan)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Total: ").font(Font.custom("Nunito-Regular", size: 25)) + Text(cumSum, format: .currency(code: Locale.current.currency?.identifier ?? "USD").precision(.fractionLength(0)))
                .font(Font.custom("Nunito-Regular", size: 25))
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
            
            Picker("", selection: $selectedChartTimeSpan) {
                ForEach(SavingsChartTimeSpan.allCases) { range in
                    Text(range.rawValue.capitalized)
                }
            }
            .pickerStyle(.segmented)
            .padding([.leading, .trailing, .top])
        }
        .padding()
        .frame(height: 200)
    }
    
    func cumSumOverTimeSpan(_ timeSpan: SavingsChartTimeSpan) -> Double {
        let oldestDate = oldestDateToShow(timeSpan)
        
        var itemsToSum = [Item]()
        for item in items {
            if item.date > oldestDate {
                itemsToSum.append(item)
            }
        }
        
        let sum = itemsToSum.reduce(0.0) {
            $0 + $1.value
        }
        
        return sum
    }
    
    func oldestDateToShow(_ timeSpan: SavingsChartTimeSpan) -> Date {
        var oldestDate = Date.now
        
        switch timeSpan {
        case .threeMonths:
            oldestDate = Calendar.current.date(byAdding: .month, value: -3, to: Date.now)!
        case .sixMonths:
            oldestDate = Calendar.current.date(byAdding: .month, value: -6, to: Date.now)!
        case .oneYear:
            oldestDate = Calendar.current.date(byAdding: .year, value: -1, to: Date.now)!
        case .allTime:
            oldestDate = Date(timeIntervalSince1970: TimeInterval(0))
        }
        
        return oldestDate
    }
}

struct MyChart_Previews: PreviewProvider {
    static var previews: some View {
        SavingsChart()
    }
}
