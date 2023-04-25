//
//  ShoeCollectionListView.swift
//  ShoeGame
//
//  Created by Elliot Hannah III on 4/24/23.
//

import SwiftUI

struct ShoeCollectionListView: View {
    private var shoes = Shoe.shoes
    
    var body: some View {
        NavigationView {
            List(shoes) { shoe in
                ShoeCollectionListItem(shoe: shoe)
            }
            .navigationTitle("Your Collection")
        }
        
    }
}

struct ShoeCollectionListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoeCollectionListView()
    }
}
