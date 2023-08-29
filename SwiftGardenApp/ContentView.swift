//
//  ContentView.swift
//  SwiftGardenApp
//
//  Created by Yugo Sugiyama on 2023/08/02.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            CalendarLineGraphView()
                .tabItem {
                    Image(systemName: "1.circle.fill")
                }
            TimelapseView()
                .padding()
                .tabItem {
                    Image(systemName: "2.circle.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
