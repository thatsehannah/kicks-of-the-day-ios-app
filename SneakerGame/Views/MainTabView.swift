//
//  MainTabView.swift
//  SneakerGame
//
//  Created by Elliot Hannah III on 5/2/23.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var sneakerListViewModel = SneakerListViewModel()
    
    var body: some View {
        TabView {
            SneakerCollectionListView()
                .tabItem {
                    Label("Collection", systemImage: "list.dash")
                }
            NavigationView {
                SneakerRotationView()
            }
            .tabItem {
                Label("Rotation", systemImage: "calendar")
            }
        }
        .environmentObject(sneakerListViewModel)
        .onAppear {
            sneakerListViewModel.fetchSneakers()
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
