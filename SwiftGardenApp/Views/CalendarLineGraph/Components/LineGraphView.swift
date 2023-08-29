//
//  LineGraphView.swift
//  SwiftGardenApp
//
//  Created by Yugo Sugiyama on 2023/08/03.
//

import SwiftUI
import SwiftGardenCore
import Charts

enum DataType: String {
    case humidity
    case temperature
}

struct DataModel: Identifiable {
    var id: String {
        type.rawValue + xValue.description + yValue.description
    }
    let type: DataType
    let xValue: Date
    let yValue: Int
}

struct LineGraphView: View {
    @Binding var selectedHourIndex: Int
    let postModels: [FirestoreDataModel]
    private var selectedDate: Date? {
        if postModels.isEmpty { return nil }
        return postModels[min(selectedHourIndex, postModels.count - 1)].date
    }
    private var dataList: [DataModel] {
        postModels
            .map({ DataModel(type: .humidity, xValue: $0.date, yValue: $0.humidity) })
        + postModels
            .map({ DataModel(type: .temperature, xValue: $0.date, yValue: Int($0.temperature)) })
    }
    
    var body: some View {
        Chart(dataList) { data in
            LineMark(
                x: .value("時間", data.xValue, unit: .hour),
                y: .value("値", data.yValue)
            )
            .foregroundStyle(by: .value("Data Type", data.type.rawValue))
            .interpolationMethod(.catmullRom)
            
            // Ref: https://mobile.blog/2022/07/04/an-adventure-with-swift-charts/
            if let selectedDate {
                RuleMark(x: .value("Selected date", selectedDate, unit: .hour))
                    .foregroundStyle(Color.red)
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .hour, count: 3)) { _ in
                AxisGridLine()
                AxisValueLabel(format: .dateTime.hour(.conversationalDefaultDigits(amPM: .abbreviated))
                )
            }
        }
        .chartYAxis {
            let temperatureValues = [0, 10, 20, 30, 40, 50]
            AxisMarks(
                position: .leading,
                values: temperatureValues
            ) {
                AxisValueLabel("\(temperatureValues[$0.index])℃", centered: true)
            }
            let humidityValues = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
            AxisMarks(
                position: .trailing,
                values: humidityValues
            ) {
                AxisValueLabel("\(humidityValues[$0.index])%", centered: false)
            }
        }
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(DragGesture()
                        .onChanged { value in
                            updateSelectedDate(at: value.location,
                                               proxy: proxy,
                                               geometry: geometry)
                        }
                    )
                    .onTapGesture { location in
                        updateSelectedDate(at: location,
                                           proxy: proxy,
                                           geometry: geometry)
                    }
            }
        }
    }
}

private extension LineGraphView {
    func updateSelectedDate(at location: CGPoint,
                            proxy: ChartProxy, geometry: GeometryProxy) {
        let xPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        guard let date: Date = proxy.value(atX: xPosition) else { return }
        withAnimation {
            selectedHourIndex = postModels
                .map(\.date)
                .firstIndex(where: { $0.hour == date.hour }) ?? 0
        }
    }
}

#Preview {
    @State var selectedHourIndex = 1000
    return LineGraphView(selectedHourIndex: $selectedHourIndex, postModels: FirestoreDataModel.mocks)
        .padding()
}
