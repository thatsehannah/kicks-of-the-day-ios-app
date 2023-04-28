//
//  EmptyListView.swift
//  ShoeGame
//
//  Created by Elliot Hannah III on 4/26/23.
//

import SwiftUI

struct EmptyListView<Content: View>: View {
    let title: String
    let message: String
    let content: (() -> Content)?
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            Text(message)
            content?()
                .padding(.top)
        }
        .font(.subheadline)
        .multilineTextAlignment(.center)
        .foregroundColor(.secondary)
        .padding()
    }
}

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView(title: "⛔️ 🛜", message: "Something went wrong while loading shoes. Please check your internet connection.", content: { Text("Retry")})
            .previewDisplayName("Error")
        EmptyListView(title: "🚫 👟", message: "You don't have any shoes in your collection.", content: { Text("Add to Collection")})
            .previewDisplayName("Empty")
    }
}
