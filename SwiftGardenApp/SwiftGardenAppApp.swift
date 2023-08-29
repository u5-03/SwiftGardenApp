//
//  SwiftGardenAppApp.swift
//  SwiftGardenApp
//
//  Created by Yugo Sugiyama on 2023/08/02.
//

import SwiftUI
import FirebaseCore

@main
struct SwiftGardenAppApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
