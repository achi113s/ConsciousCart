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
        Item(date: Date(timeIntervalSince1970: 1630574339), value: 80),
        Item(date: Date(timeIntervalSince1970: 1671274339), value: 120),
        Item(date: Date(timeIntervalSince1970: 1672274339), value: 20),
        Item(date: Date(timeIntervalSince1970: 1673274339), value: 55),
        Item(date: Date(timeIntervalSince1970: 1674274339), value: 170),
        Item(date: Date(timeIntervalSince1970: 1675274339), value: 20),
        Item(date: Date(timeIntervalSince1970: 1676274339), value: 10),
        Item(date: Date(timeIntervalSince1970: 1677274339), value: 5),
        Item(date: Date(timeIntervalSince1970: 1678274339), value: 1),
        Item(date: Date(timeIntervalSince1970: 1679274339), value: 500),
        Item(date: Date(timeIntervalSince1970: 1680274339), value: 800),
        Item(date: Date(timeIntervalSince1970: 1681274339), value: 900),
        Item(date: Date(timeIntervalSince1970: 1682274339), value: 1700),
        Item(date: Date(timeIntervalSince1970: 1683274339), value: 2700),
        Item(date: Date(timeIntervalSince1970: 1684544894), value: 3400.23)
    ]
    
    @State private var buttonIsEnabled: Bool = true
    @State private var selectedChartTimeSpan: SavingsChartTimeSpan = .allTime
    
    private var cumSum: Double {
        return cumSumOverTimeSpan(selectedChartTimeSpan)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(cumSum, format: .currency(code: Locale.current.currency?.identifier ?? "USD").precision(.fractionLength(0)))
                .font(Font.custom("Nunito-Bold", size: 25))
                .foregroundColor(cumSum > 0.0 ? .green : .red)
            + Text(cumSum > 0.0 ? " Saved": " Spent").font(Font.custom("Nunito-Regular", size: 17))
                .foregroundColor(cumSum > 0.0 ? .green : .red)
            Chart(items.count != 0 ? items : [Item(date: Date.now, value: 0)]) { item in
                LineMark(
                    x: .value("Month", item.date),
                    y: .value("Savings", item.value)
                )
                .foregroundStyle(Color("ExodusFruit"))
            }
            .chartYAxis {
                AxisMarks(position: .trailing, values: .automatic) { value in
                    AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 0.5, dash: [2]))
                    AxisValueLabel() {
                        if let intValue = value.as(Int.self) {
                            Text(intValue, format: .currency(code: Locale.current.currency?.identifier ?? "USD").precision(.fractionLength(0)))
                        }
                    }
                }
            }
            .chartXScale(domain: oldestDateToShow(selectedChartTimeSpan)...Date())
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
            .clipped()
            
            Picker("", selection: $selectedChartTimeSpan.animation(.easeInOut)) {
                ForEach(SavingsChartTimeSpan.allCases) { range in
                    Text(range.rawValue.capitalized)
                }
            }
            .pickerStyle(.segmented)
            .padding([.leading, .trailing])
        }
        .padding([.bottom, .leading, .trailing])
        .frame(height: 260)
    }
    
    func cumSumOverTimeSpan(_ timeSpan: SavingsChartTimeSpan) -> Double {
        if timeSpan != .allTime {
            let oldestDate = oldestDateToShow(timeSpan)
            
            var sum = 0.0
            for item in items where item.date > oldestDate {
                sum += item.value
            }
            return sum
        } else {
            return items.reduce(0.0) { $0 + $1.value }
        }
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
            // this is really ugly
            oldestDate = items.first?.date ?? Date(timeIntervalSince1970: 0)
        }
        
        return oldestDate
    }
}



struct MyChart_Previews: PreviewProvider {
    static var previews: some View {
        SavingsChart()
    }
}
