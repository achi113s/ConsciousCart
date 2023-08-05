//
//  NewSavingsChart.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 6/24/23.
//

import Charts
import SwiftUI

struct SavingsChart: View {
    var completedImpulses: [Impulse]
    
    @State private var selectedChartTimeDomain: ChartTimeDomain = .allTime
    @State private var selectedItemOnChart: Item? = nil
    private var chartColor: Color = Color(
        uiColor: UserDefaults.standard.color(forKey: UserDefaultsKeys.accentColor.rawValue) ?? UIColor(named: "ShyMoment")!)
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                TextViewAnimatableCurrency(number: totalSavedNumber)
                    .font(Font.custom("Nunito-Bold", size: 25))
                    .foregroundColor(differentiateWithoutColor ? .primary : redOrGreen(for: totalSavedNumber))
                
                if differentiateWithoutColor {
                    Image(systemName: totalSavedNumber >= 0 ? "arrow.up" : "arrow.down")
                        .font(.system(size: 17))
                }
                
                Text(totalSavedNumber >= 0.0 ? "Saved" : "Spent")
                    .font(Font.custom("Nunito-Bold", size: 17))
                    .foregroundColor(differentiateWithoutColor ? .primary : redOrGreen(for: totalSavedNumber))
            }
            
            Chart(savingsRollingSum.count != 0 ? savingsRollingSum : [Item(date: Date.now, value: 0)]) { item in
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Saved", item.value)
                )
                .foregroundStyle(chartColor)
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
                                    // Change from global coordinates to local.
                                    let currentX = value.location.x - geometry[chart.plotAreaFrame].origin.x
                                    let currentY = value.location.y - geometry[chart.plotAreaFrame].origin.y
                                    
                                    guard currentX >= 0, currentX < chart.plotAreaSize.width else { return }
                                    guard currentY >= 0, currentY < chart.plotAreaSize.height else { return }
                                    
                                    guard let element = findNearestElement(currentX: currentX,
                                                                           proxy: chart,
                                                                           geometry: geometry) else { return }
                                    withAnimation {
                                        selectedItemOnChart = element
                                    }
                                    
                                }
                                .onEnded { _ in
                                    withAnimation {
                                        selectedItemOnChart = nil
                                    }
                                }
                        )
                }
            }
            .chartBackground { chart in
                ZStack(alignment: .topLeading) {
                    GeometryReader { geometry in
                        if let selectedItemOnChart {
                            // Date span
                            let dateInterval = Calendar.current.dateInterval(of: .day, for: selectedItemOnChart.date)!
                            // Map date to chart X position
                            let startPositionX = chart.position(forX: dateInterval.start) ?? 0
                            // Offset the chart X position by chart frame
                            let midStartPositionX = startPositionX + geometry[chart.plotAreaFrame].origin.x
                            
                            let positionY = chart.position(forY: selectedItemOnChart.value) ?? 0
                            
                            let lineHeight = geometry[chart.plotAreaFrame].maxY
                            
                            Rectangle()
                                .fill(.quaternary)
                                .frame(width: 2, height: lineHeight)
                                .position(x: midStartPositionX + 3, y: lineHeight / 2)
                            
                            Circle()
                                .fill(chartColor)
                                .frame(width: 8, height: 8)
                                .position(x: midStartPositionX + 3, y: positionY + 5)
                        }
                    }
                }
            }
            
            Picker("Time Domain", selection: $selectedChartTimeDomain) {
                ForEach(ChartTimeDomain.allCases) { domain in
                    Text(domain.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding([.leading, .trailing])
        }
        .frame(height: 300)
        .padding(EdgeInsets(top: 24, leading: 0, bottom: 32, trailing: 0))
    }
    
    init(completedImpulses: [Impulse]) {
        self.completedImpulses = completedImpulses
    }
    
    private var maxDate: Date {
        if completedImpulses.isEmpty {
            return Date()
        }
        var date: Date? = completedImpulses.first?.unwrappedCompletedDate
        
        for impulse in completedImpulses {
            if impulse.unwrappedCompletedDate > date! {
                date = impulse.unwrappedCompletedDate
            }
        }
        
        return date ?? Date.now
    }
    
    private var minDate: Date {
        if completedImpulses.isEmpty {
            return Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date.distantPast
        }
        var date: Date? = completedImpulses.first?.unwrappedCompletedDate
        
        for impulse in completedImpulses {
            if impulse.unwrappedCompletedDate < date! {
                date = impulse.unwrappedCompletedDate
            }
        }
        
        return date ?? Date.distantPast
    }
    
    private var savingsRollingSum: [Item] {
        if completedImpulses.isEmpty {
            return [Item(date: Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date.distantPast, value: 0.0),
                    Item(date: Date.now, value: 0.0)]
        }
        
        return rollingSumOverTimeDomain(timeDomain: selectedChartTimeDomain)
    }
    
    private var totalSavedNumber: Double {
        // This allows us to change the amount saved to match the selected
        // element if the user is browsing the chart.
        if let selectedNum = selectedItemOnChart?.value {
            return selectedNum
        }
        
        // Else show the total amount saved.
        return completedImpulses.reduce(0.0) { partialResult, impulse in
            return partialResult + impulse.amountSaved
        }
    }
}

extension SavingsChart {
    func findNearestElement(currentX: CGFloat, proxy: ChartProxy, geometry: GeometryProxy) -> Item? {
        // Use value(atX:) to find plotted value for the given X axis position.
        if let date = proxy.value(atX: currentX) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            
            // Go through each element and find the one that is closest to location.
            for dataIndex in savingsRollingSum.indices {
                let nthDataDistance = savingsRollingSum[dataIndex].date.distance(to: date)
                if abs(nthDataDistance) < minDistance {
                    minDistance = abs(nthDataDistance)
                    index = dataIndex
                }
            }
            
            if let index {
//                print(savingsRollingSum[index])
                return savingsRollingSum[index]
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
            return minDate
        }
    }
    
    func rollingSumOverTimeDomain(timeDomain: ChartTimeDomain) -> [Item] {
        var rollingSum = [Item]()
        var sum = 0.0
        
        let oldestDate = oldestDateToShow(timeDomain)
        
        for impulse in completedImpulses where impulse.unwrappedCompletedDate >= oldestDate {
            sum += impulse.amountSaved
            let newItem = Item(date: impulse.unwrappedCompletedDate, value: sum)
            rollingSum.append(newItem)
        }
        
//        print(rollingSum)
//        print(rollingSum.count)
        return rollingSum
    }
    
    func redOrGreen(for savedAmount: Double) -> Color {
        savedAmount >= 0.0 ? .green : .red
    }
}
