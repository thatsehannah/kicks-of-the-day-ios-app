//
//  ShoeGameApp.swift
//  ShoeGame
//
//  Created by Elliot Hannah III on 4/24/23.
//

import SwiftUI
import Firebase

@main
struct ShoeGameApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
