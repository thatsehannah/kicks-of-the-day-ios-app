//
//  SneakerGame.swift
//  SneakerGame
//
//  Created by Elliot Hannah III on 4/24/23.
//

import SwiftUI
import Firebase

@main
struct SneakerGame: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
