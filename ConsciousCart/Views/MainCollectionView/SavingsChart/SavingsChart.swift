//
//  NewSavingsChart.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/20/23.
//

import Charts
import SwiftUI

struct SavingsChart: View {
    var impulsesStateManager: ImpulsesStateManager
    
    @State private var selectedItemOnChart: Item? = nil
    private let chartColor: Color = Color(UserDefaults.standard.string(forKey: UserDefaultsKeys.accentColor.rawValue) ?? "ShyMoment")
    
    @State private var selectedChartTimeDomain: ChartTimeDomain = .allTime
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            amountSavedView
            
            savingsChart
            
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
    
    @ViewBuilder private var amountSavedView: some View {
        HStack {
            TextViewAnimatableCurrency(number: currentAmountSaved)
                .ccFont(.title2)
                .foregroundColor(differentiateWithoutColor ? .primary : redOrGreen(for: currentAmountSaved))
            
            if differentiateWithoutColor {
                Image(systemName: currentAmountSaved >= 0 ? "arrow.up" : "arrow.down")
                    .ccFont(.bold)
            }
            
            Text(currentAmountSaved >= 0.0 ? "Saved" : "Spent")
                .ccFont(.bold)
                .foregroundColor(differentiateWithoutColor ? .primary : redOrGreen(for: currentAmountSaved))
        }
    }
    
    @ViewBuilder private var savingsChart: some View {
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
                            .ccFont(.caption)
                    }
                }
            }
        }
        .chartXScale(domain: oldestDateToShow(selectedChartTimeDomain)...maxDate)
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
            ZStack {
                GeometryReader { geometry in
                    if let selectedItemOnChart {
                        // Map date to chart X position
                        let startPositionX = chart.position(forX: selectedItemOnChart.date) ?? 0
                        // Offset the chart X position by chart frame
                        let midStartPositionX = startPositionX + geometry[chart.plotAreaFrame].origin.x
                        
                        let positionY = chart.position(forY: selectedItemOnChart.value) ?? 0
                        
                        let lineHeight = geometry[chart.plotAreaFrame].maxY

                        Rectangle()
                            .fill(.quaternary)
                            .frame(width: 2, height: lineHeight)
                            .position(x: midStartPositionX, y: lineHeight / 2)
                        
                        Circle()
                            .fill(chartColor)
                            .frame(width: 8, height: 8)
                            .position(x: midStartPositionX, y: positionY)
                    }
                }
            }
        }
    }
}

extension SavingsChart {
    private var currentAmountSaved: Double {
        // If the user is browsing the chart and has selected
        // a value, return that value.
        if let selectedNum = selectedItemOnChart?.value {
            return selectedNum
        }
        
        // Else show the total amount the user has saved.
        return impulsesStateManager.userStats?.totalAmountSaved ?? 0.0
    }
    
    private var defaultMinDate: Date {
        lazy var someDate = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        
        if impulsesStateManager.completedImpulses.isEmpty {
            return someDate
        }
         
        guard let userStats = impulsesStateManager.userStats else {
            return someDate
        }
        
        return userStats.unwrappedDateCreated
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
    
    // We always want to have at least two points in the chart data
    // so that Chart can generate a line. Therefore, if there is no available data,
    // we generate two dummy data points; one at zero on a date in the distant past,
    // and the second at zero at today's date. Otherwise, we always generate a default zero
    // data point based on the creation date of the UserStats entity.
    private var generatedRollingSumData: [Item] {
        lazy var defaultData = [
            Item(date: defaultMinDate, value: 0.0),
            Item(date: Date.now, value: 0.0)
        ]
        
        // Case where there is no data.
        if impulsesStateManager.completedImpulses.isEmpty {
            return defaultData
        }
        
        guard let userStats = impulsesStateManager.userStats else { return defaultData }
        
        var rollingSum = rollingSumOverTimeDomain(timeDomain: selectedChartTimeDomain)
        
        let defaultItem = Item(date: userStats.unwrappedDateCreated, value: 0.0)
        
        rollingSum.insert(defaultItem, at: 0)

        return rollingSum
    }
    
    private func redOrGreen(for amount: Double) -> Color {
        amount >= 0.0 ? .green : .red
    }
}

// Private Functions
extension SavingsChart {
    private func findNearestElement(currentX: CGFloat, proxy: ChartProxy, geometry: GeometryProxy) -> Item? {
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
                return generatedRollingSumData[index]
            }
        }
        
        return nil
    }
    
    private func oldestDateToShow(_ timeSpan: ChartTimeDomain) -> Date {
        switch timeSpan {
        case .oneWeek:
            return Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: Date.now)!
        case .oneMonth:
            return Calendar.current.date(byAdding: .month, value: -1, to: Date.now)!
        case .threeMonths:
            return Calendar.current.date(byAdding: .month, value: -3, to: Date.now)!
        case .sixMonths:
            return Calendar.current.date(byAdding: .month, value: -6, to: Date.now)!
        case .oneYear:
            return Calendar.current.date(byAdding: .year, value: -1, to: Date.now)!
        case .allTime:
            return defaultMinDate
        }
    }
    
    private func rollingSumOverTimeDomain(timeDomain: ChartTimeDomain) -> [Item] {
        var rollingSum = [Item]()
        var sum = 0.0
        
        let oldestDate = oldestDateToShow(timeDomain)
        
        for impulse in impulsesStateManager.completedImpulses where impulse.unwrappedCompletedDate >= oldestDate {
            sum += impulse.amountSaved
            let newItem = Item(date: impulse.unwrappedCompletedDate, value: sum)
            rollingSum.append(newItem)
        }
        
        return rollingSum
    }
}
