//
//  NewSavingsChart.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 6/24/23.
//

import Charts
import SwiftUI

struct SavingsChart: View {
    var impulsesStateManager: ImpulsesStateManager
    
    @State private var selectedChartTimeDomain: ChartTimeDomain = .allTime
    let defaultMinDate: Date = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
    
    @State private var selectedItemOnChart: Item? = nil
    
    private var chartColor: Color = Color(UserDefaults.standard.string(forKey: UserDefaultsKeys.accentColor.rawValue) ?? "ShyMoment")
    
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
            
            Chart(generatedRollingSumData) { item in
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
    }
    
    init(impulsesStateManager: ImpulsesStateManager) {
        self.impulsesStateManager = impulsesStateManager
    }
    
    private var maxDate: Date {
        if impulsesStateManager.completedImpulses.isEmpty {
            return Date.now
        }
        
        var date: Date? = impulsesStateManager.completedImpulses.first?.unwrappedCompletedDate
        
        for impulse in impulsesStateManager.completedImpulses {
            if impulse.unwrappedCompletedDate > date! {
                date = impulse.unwrappedCompletedDate
            }
        }
        
        return date ?? Date.now
    }
    
    private var minDate: Date {
        if impulsesStateManager.completedImpulses.isEmpty {
            return defaultMinDate
        }
        
        if impulsesStateManager.completedImpulses.count == 1 {
            guard let userStats = impulsesStateManager.userStats else { return defaultMinDate }
            
            return userStats.unwrappedDateCreated
        }
        
        var date: Date? = impulsesStateManager.completedImpulses.first?.unwrappedCompletedDate
        
        for impulse in impulsesStateManager.completedImpulses {
            if impulse.unwrappedCompletedDate < date! {
                date = impulse.unwrappedCompletedDate
            }
        }
        
        return date ?? Date.distantPast
    }
    
    // We always want to have at least two points in the chart data
    // so that Chart can generate a line. Therefore, if there is no available data,
    // we generate two dummy data points; one at zero on the creation date of the UserStats
    // object, and the second at zero at the current date. Otherwise, we always generate a zero
    // data point based on the creation date of the UserStats entity.
    private var generatedRollingSumData: [Item] {
        // Case where there is no data.
        lazy var defaultData = [
            Item(date: defaultMinDate, value: 0.0),
            Item(date: Date.now, value: 0.0)
        ]
        
        if impulsesStateManager.completedImpulses.isEmpty {
            return defaultData
        }
        
        // Case where there is only one data point.
        lazy var rollingSum = rollingSumOverTimeDomain(timeDomain: selectedChartTimeDomain)
        
        if impulsesStateManager.completedImpulses.count == 1 {
            guard let userStats = impulsesStateManager.userStats else { return defaultData }
            
            let defaultItem = Item(date: userStats.unwrappedDateCreated, value: 0.0)
            
            rollingSum.insert(defaultItem, at: 0)
            
            return rollingSum
        }
        
        return rollingSum
    }
    
    private var totalSavedNumber: Double {
        // This allows us to change the amount saved to match the selected
        // element if the user is browsing the chart.
        if let selectedNum = selectedItemOnChart?.value {
            return selectedNum
        }
        
        // Else show the total amount saved.
        return impulsesStateManager.completedImpulses.reduce(0.0) { partialResult, impulse in
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
            for dataIndex in generatedRollingSumData.indices {
                let nthDataDistance = generatedRollingSumData[dataIndex].date.distance(to: date)
                if abs(nthDataDistance) < minDistance {
                    minDistance = abs(nthDataDistance)
                    index = dataIndex
                }
            }
            
            if let index {
//                print(savingsRollingSum[index])
                return generatedRollingSumData[index]
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
        
        for impulse in impulsesStateManager.completedImpulses where impulse.unwrappedCompletedDate >= oldestDate {
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
