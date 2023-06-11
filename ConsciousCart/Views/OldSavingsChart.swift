//
//  MyChart.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/26/23.
//

import SwiftUI
import Charts
import Foundation

struct OldSavingsChart: View {
    @State private var buttonIsEnabled: Bool = true

    @State private var selectedChartTimeSpan: ChartTimeDomain = .allTime

    @State private var selectedIndex: (Int, Double)? = nil
    @State private var selectedElement: Item? = nil

    private var totalSaved: Double {
        return sumOverTimeSpan(timeSpan: selectedChartTimeSpan, items: items)
    }

    private var totalSavedRollingSum: [Item] {
        return rollingSum(items)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                TextViewAnimatableCurrency(number: totalSaved)
                    .font(Font.custom("Nunito-Bold", size: 25))
                    .foregroundColor(totalSaved > 0.0 ? .green : .red)

                Text(" Saved \(selectedElement?.value ?? 0.0)")
                    .font(Font.custom("Nunito-Regular", size: 17))
                    .foregroundColor(totalSaved > 0.0 ? .green : .red)
            }

            Chart(totalSavedRollingSum.count != 0 ? totalSavedRollingSum : [Item(date: Date.now, value: 0)]) { item in
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

                                    guard let element = findElement(location: value.location,
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
            
            Picker("", selection: $selectedChartTimeSpan.animation(.easeInOut)) {
                ForEach(ChartTimeDomain.allCases) { range in
                    Text(range.rawValue.capitalized)
                }
            }
            .pickerStyle(.segmented)
            .padding([.leading, .trailing])
        }
        .padding([.bottom, .leading, .trailing])
        .frame(height: 260)
    }

    func sumOverTimeSpan(timeSpan: ChartTimeDomain, items: [Item]) -> Double {
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

    func rollingSum(_ items: [Item]) -> [Item] {
        var rollingSum = [Item]()
        var sum = 0.0

        for item in items {
            sum += item.value
            let newItem = Item(date: item.date, value: sum)
            rollingSum.append(newItem)
        }

        return rollingSum
    }

    func oldestDateToShow(_ timeSpan: ChartTimeDomain) -> Date {
        var oldestDate = Date.now

        switch timeSpan {
        case .threeMonths:
            oldestDate = Calendar.current.date(byAdding: .month, value: -3, to: Date.now)!
        case .sixMonths:
            oldestDate = Calendar.current.date(byAdding: .month, value: -6, to: Date.now)!
        case .oneYear:
            oldestDate = Calendar.current.date(byAdding: .year, value: -1, to: Date.now)!
        case .allTime:
            // this is really ugly and also assumes the items are sorted by date
            oldestDate = items.first?.date ?? Date(timeIntervalSince1970: 0)
        }

        return oldestDate
    }

    func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> Item? {
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x

        // Use value(atX:) to find plotted value for the given X axis position.
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
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

    private let items: [Item] = [
        Item(date: Date(timeIntervalSince1970: 1630574339), value: -800),
        Item(date: Date(timeIntervalSince1970: 1671274339), value: -120),
        Item(date: Date(timeIntervalSince1970: 1672274339), value: -20),
        Item(date: Date(timeIntervalSince1970: 1673274339), value: -55),
        Item(date: Date(timeIntervalSince1970: 1674274339), value: -170),
        Item(date: Date(timeIntervalSince1970: 1675274339), value: -20),
        Item(date: Date(timeIntervalSince1970: 1676274339), value: 10),
        Item(date: Date(timeIntervalSince1970: 1677274339), value: 5),
        Item(date: Date(timeIntervalSince1970: 1678274339), value: 1),
        Item(date: Date(timeIntervalSince1970: 1679274339), value: 500),
        Item(date: Date(timeIntervalSince1970: 1680274339), value: 800),
        Item(date: Date(timeIntervalSince1970: 1681274339), value: 900),
        Item(date: Date(timeIntervalSince1970: 1682274339), value: -430),
        Item(date: Date(timeIntervalSince1970: 1683274339), value: -700),
        Item(date: Date(timeIntervalSince1970: 1684544894), value: -300.23)
    ]
}

struct MyChart_Previews: PreviewProvider {
    static var previews: some View {
        OldSavingsChart()
    }
}

//struct Item: Identifiable {
//    var id = UUID()
//    let date: Date
//    let value: Double
//}
//
//enum ChartTimeDomain: String, CaseIterable, Identifiable {
//    case threeMonths = "3M"
//    case sixMonths = "6M"
//    case oneYear = "1Y"
//    case allTime = "All"
//    var id: Self { self }
//}
