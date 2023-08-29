//
//  CalendarLineGraphView.swift
//  SwiftGardenApp
//
//  Created by Yugo Sugiyama on 2023/08/03.
//

import SwiftUI
import SwiftGardenCore

struct CalendarLineGraphView: View {
    @State private var date = Date().offsetDays(offset: -3)!
    @State private var results: [FirestoreDataModel] = []
    @State private var imageNameList: [String] = []
    @State var selectedHourIndex = 0
    @State var imageURL: URL?
    let arrowshapeHeight:CGFloat = 28
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "arrowshape.backward.fill")
                    .resizable()
                    .frame(width: arrowshapeHeight, height: arrowshapeHeight)
                    .onTapGesture {
                        date = date.yesterday ?? Date()
                    }
                Spacer()
                DatePicker("", selection: $date, displayedComponents: [.date])
                // format to `yyyy/MM/dd`
                    .environment(\.locale, Locale(identifier: "ja_JP"))
                    .labelsHidden()
                Spacer()
                Group {
                    if !date.isToday {
                        Image(systemName: "arrowshape.right.fill")
                            .resizable()
                            .onTapGesture {
                                date = date.tomorrow ?? Date()
                            }
                    } else {
                        Color.clear
                    }
                }
                .frame(width: arrowshapeHeight, height: arrowshapeHeight)
            }
            .padding(.horizontal)
            GeometryReader { geometry in
                VStack {
                    LineGraphView(selectedHourIndex: $selectedHourIndex, postModels: results)
                        .padding()
                        .frame(height: geometry.size.height * 2 / 3)
                    ImageCarouselView(selectedIndex: $selectedHourIndex, imageNameList: results.map(\.imageName))
                        .frame(height: geometry.size.height / 3)
                }
            }
        }
        .onAppear {
            fetchList()
        }
        .onChange(of: date) { _ in
            fetchList()
        }
    }
    
    private func fetchList() {
        Task {
            do {
                let results: [FirestoreDataModel]
                if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                    results = FirestoreDataModel.mocks
                } else {
                    results = try await FirebaseManager.fetchList(date: date)
                }
                withAnimation(.easeInOut(duration: 0.8)) {
                    self.results = results
                }
            } catch {
                results = []
                selectedHourIndex = 0
                print(error)
            }
        }
    }
}

struct CalendarLineGraphView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarLineGraphView()
    }
}
