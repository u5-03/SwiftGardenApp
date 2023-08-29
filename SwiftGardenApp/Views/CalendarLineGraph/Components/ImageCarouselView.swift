//
//  ImageCarouselView.swift
//  SwiftGardenApp
//
//  Created by Yugo Sugiyama on 2023/08/09.
//

import SwiftUI
import Algorithms

struct ImageCarouselView: View {
    @Binding var selectedIndex: Int
    let imageNameList: [String]

    var body: some View {
        TabView(selection: $selectedIndex.animation(.spring())) {
            ForEach(imageNameList.indexed(), id: \.element) { (index, name) in
                AsyncImageView(imageName: name)
                    .tag(index) // to get selected index
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
}

struct ImageCarouselView_Previews: PreviewProvider {
    @State static var selectedIndex = 0

    static var previews: some View {
        ImageCarouselView(selectedIndex: $selectedIndex, imageNameList: [])
    }
}
