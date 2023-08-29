//
//  URL.swift
//  SwiftGardenApp
//
//  Created by Yugo Sugiyama on 2023/08/16.
//

import UIKit
import SDWebImage

extension URL {
    func asUIImage() async throws -> UIImage? {
        return try await withCheckedThrowingContinuation { continuation in
            SDWebImageDownloader.shared.downloadImage(with: self) { image, _, error, _ in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: image)
                }
            }
        }
    }
}
