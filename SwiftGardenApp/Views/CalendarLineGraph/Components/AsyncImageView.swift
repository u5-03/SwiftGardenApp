//
//  AsyncImageView.swift
//  SwiftGardenApp
//
//  Created by Yugo Sugiyama on 2023/08/11.
//

import SwiftUI
import SDWebImageSwiftUI

struct AsyncImageView: View {
    @State var url: URL?
    @State var error: Error?
    let imageName: String

    var body: some View {
        Group {
            if error != nil {
                Image(systemName: "photo")
            } else {
                WebImage(url: url)
                    .resizable()
                // .indicator(.progress) not show?
                    .placeholder(content: {
                        ProgressView()
                            .font(.largeTitle)
                    })
                    .indicator(.progress)
                    .scaledToFit()
                    .transition(.fade(duration: 0.5))
            }
        }
        .task {
            do {
                url = try await FirebaseManager.getImageURL(pathName: imageName)
            } catch {
                print(error)
                self.error = error
            }
        }
    }
}

struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncImageView(imageName: "SwiftGardenImages/20230809100009.jpeg")
    }
}
