//
//  NewSavingsChart.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 6/24/23.
//

import Charts
import SwiftUI

struct NewSavingsChart: View {
    @State private var selectedChartTimeDomain: ChartTimeDomain = .allTime
    @State private var selectedItemOnChart: Item? = nil
    
    var completedImpulses: [Impulse]
    
    private var maxDate: Date {
        var date: Date? = completedImpulses.first?.wrappedCompletedDate
        
        for impulse in completedImpulses {
            if impulse.wrappedCompletedDate > date! {
                date = impulse.wrappedCompletedDate
            }
        }
        
        return date ?? Date.now
    }
    
    private var minDate: Date {
        var date: Date? = completedImpulses.first?.wrappedCompletedDate
        
        for impulse in completedImpulses {
            if impulse.wrappedCompletedDate < date! {
                date = impulse.wrappedCompletedDate
            }
        }
        
        return date ?? Date.distantPast
    }
    
    private var savingsRollingSum: [Item] {
        return rollingSumOverTimeDomain(timeDomain: selectedChartTimeDomain)
    }
    
    private var totalSaved: Double {
        if let selectedNum = selectedItemOnChart?.value {
            return selectedNum
        }
        
        return completedImpulses.reduce(0.0) { partialResult, impulse in
            return partialResult + impulse.amountSaved
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                TextViewAnimatableCurrency(number: totalSaved)
                    .font(Font.custom("Nunito-Bold", size: 25))
                    .foregroundColor(totalSaved > 0.0 ? .green : .red)
                
                Text(" Saved")
                    .font(Font.custom("Nunito-Bold", size: 17))
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
    
    func findNearestElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> Item? {
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        
        // Use value(atX:) to find plotted value for the given X axis position.
        if let date = proxy.value(atX: relativeXPosition) as Date? {
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
                print(savingsRollingSum[index])
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
        
        for impulse in completedImpulses where impulse.wrappedCompletedDate >= oldestDate {
            sum += impulse.amountSaved
            let newItem = Item(date: impulse.wrappedCompletedDate, value: sum)
            rollingSum.append(newItem)
        }
        
        //        print(rollingSum)
        //        print(rollingSum.count)
        return rollingSum
    }
}
