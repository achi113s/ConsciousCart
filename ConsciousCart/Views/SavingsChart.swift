//
//  NewSavingsChart.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 6/10/23.
//

import Charts
import Foundation
import SwiftUI

struct SavingsChart: View {
    @State private var selectedChartTimeDomain: ChartTimeDomain = .allTime
    @State private var selectedElement: Item? = nil
    
    var impulses: [Impulse]
    var items: [Item] {
        var tmp = [Item]()

        for impulse in impulses {
            let item = Item(date: impulse.wrappedCompletedDate, value: impulse.amountSaved)
            tmp.append(item)
        }

        return tmp
    }
    
    private var maxDate: Date {
        var date: Date? = items.first?.date
        
        for item in items {
            if item.date > date! {
                date = item.date
            }
        }
        
        return date ?? Date.now
    }
    
    private var savingsRollingSum: [Item] {
        return rollingSumOverTimeDomain(timeDomain: .allTime, items: items)
    }
    
    private var totalSaved: Double {
        return sumOverTimeDomain(timeDomain: selectedChartTimeDomain, items: items)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                TextViewAnimatableCurrency(number: totalSaved)
                    .font(Font.custom("Nunito-Bold", size: 25))
                    .foregroundColor(totalSaved > 0.0 ? .green : .red)
                
                Text(" Saved")
                    .font(Font.custom("Nunito-Regular", size: 17))
                    .foregroundColor(totalSaved > 0.0 ? .green : .red)
            }
            
            Chart(savingsRollingSum.count != 0 ? savingsRollingSum : [Item(date: Date.now, value: 0)]) { item in
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Saved", item.value)
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
            .chartXScale(domain: oldestDateToShow(selectedChartTimeDomain)...maxDate)
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
            .clipped()
            .chartOverlay { chart in
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let currentX = value.location.x - geometry[chart.plotAreaFrame].origin.x
                                    let currentY = value.location.y - geometry[chart.plotAreaFrame].origin.y
                                    
                                    guard currentX >= 0, currentX < chart.plotAreaSize.width else { return }
                                    guard currentY >= 0, currentY < chart.plotAreaSize.height else { return }
                                    
                                    guard let element = findNearestElement(location: value.location,
                                                                           proxy: chart,
                                                                           geometry: geometry) else { return }
                                    
                                    selectedElement = element
                                }
                                .onEnded { _ in
                                    selectedElement = nil
                                }
                        )
                }
            }
            
            Picker("Time Domain", selection: $selectedChartTimeDomain.animation(.easeInOut)) {
                ForEach(ChartTimeDomain.allCases) { domain in
                    Text(domain.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding([.leading, .trailing])
        }
        .frame(height: 260)
    }
    
    func findNearestElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> Item? {
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        
        // Use value(atX:) to find plotted value for the given X axis position.
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            
            // Go through each element and find the one that is closest to location.
            for dataIndex in items.indices {
                let nthDataDistance = items[dataIndex].date.distance(to: date)
                if abs(nthDataDistance) < minDistance {
                    minDistance = abs(nthDataDistance)
                    index = dataIndex
                }
            }
            
            if let index {
                return items[index]
            }
        }
        
        return nil
    }
    
    func oldestDateToShow(_ timeSpan: ChartTimeDomain) -> Date {
        switch timeSpan {
        case .threeMonths:
            return Calendar.current.date(byAdding: .month, value: -3, to: Date.now)!
        case .sixMonths:
            return Calendar.current.date(byAdding: .month, value: -6, to: Date.now)!
        case .oneYear:
            return Calendar.current.date(byAdding: .year, value: -1, to: Date.now)!
        case .allTime:
            // this is really ugly and also assumes the items are sorted by date
            return items.first?.date ?? Date(timeIntervalSince1970: 0)
        }
    }
    
    func rollingSumOverTimeDomain(timeDomain: ChartTimeDomain, items: [Item]) -> [Item] {
        var rollingSum = [Item]()
        var sum = 0.0
        let oldestDate = oldestDateToShow(timeDomain)
        
        for item in items where item.date > oldestDate {
            sum += item.value
            let newItem = Item(date: item.date, value: sum)
            rollingSum.append(newItem)
        }
        
        return rollingSum
    }
    
    func sumOverTimeDomain(timeDomain: ChartTimeDomain, items: [Item]) -> Double {
        if timeDomain != .allTime {
            let oldestDate = oldestDateToShow(timeDomain)
            
            var sum = 0.0
            for item in items where item.date > oldestDate {
                sum += item.value
            }
            return sum
        } else {
            return items.reduce(0.0) { $0 + $1.value }
        }
    }
}

//struct SavingsChart_Previews: PreviewProvider {
//    static var previews: some View {
//        SavingsChart(impulses: Utils.chartTestItems)
//    }
//}

struct Item: Identifiable {
    var id = UUID()
    let date: Date
    let value: Double
}

enum ChartTimeDomain: String, CaseIterable, Identifiable {
    case threeMonths = "3M"
    case sixMonths = "6M"
    case oneYear = "1Y"
    case allTime = "All"
    var id: Self { self }
}
