//
//  ShoeCollectionListView.swift
//  ShoeGame
//
//  Created by Elliot Hannah III on 4/24/23.
//

import SwiftUI

struct ShoeCollectionListView: View {
    @StateObject var viewModel = ShoeViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.shoes) { shoe in
                ShoeCollectionListItem(shoe: shoe)
            }
            .navigationTitle("Your Collection")
            .toolbar {
                NavigationLink(destination: NewShoeForm(addAction: viewModel.makeAddAction())) {
                    Image(systemName: "plus")
                }
            }
        }
        
    }
}

struct ShoeCollectionListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoeCollectionListView()
    }
}
