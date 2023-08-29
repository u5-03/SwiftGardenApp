//
//  TimelapseView.swift
//  SwiftGardenApp
//
//  Created by Yugo Sugiyama on 2023/08/16.
//

import SwiftUI
import SwiftGardenCore

struct TimelapseView: View {
    @State private var images: [UIImage] = []

    var body: some View {
        TimelapseRepresentable(images: $images)
            .task(priority: .background) {
                do {
                    try await fetchList()
                } catch {
                    print(error)
                }
            }
    }

    private func fetchList() async throws {
        Task {
            do {
                let results: [FirestoreDataModel]
                if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                    results = FirestoreDataModel.mocks
                } else {
                    results = try await FirebaseManager.fetchList(fromDate: Date().offsetDays(offset: -12) ?? Date(), endDate: Date()) // 8/16
                }
                if results.isEmpty {
                    print("Result is Empty!")
                }
                let imageList = try await withThrowingTaskGroup(of: UIImage?.self) { group in
                    results.map(\.imageName).forEach { imageName in
                        group.addTask {
                            print("ImageName: \(imageName)")
                            return try await FirebaseManager.getImageURL(pathName: imageName).asUIImage()
                        }
                    }
                    var images: [UIImage] = []
                    for try await image in group {
                        guard let image else { break }
                        images.append(image)
                    }
                    return images
                }
                let images = imageList.compactMap { $0 }
                self.images = images
            } catch {
                print(error)
            }
        }
    }
}

struct TimelapseView_Previews: PreviewProvider {
    static var previews: some View {
        TimelapseView()
    }
}
