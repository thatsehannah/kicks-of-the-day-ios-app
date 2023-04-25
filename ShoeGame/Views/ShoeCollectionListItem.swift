//
//  ShoeCollectionListItem.swift
//  ShoeGame
//
//  Created by Elliot Hannah III on 4/24/23.
//

import SwiftUI

struct ShoeCollectionListItem: View {
    let shoe: Shoe
    
    var body: some View {
        HStack {
            if let photo = shoe.currentPhoto {
                ShoeImageView(imageName: photo)
            } else {
                ShoeImageView(imageName: "blank")
            }
            Spacer()
            VStack(alignment: .leading) {
                Text(shoe.shoeName)
                    .font(.body)
                    .fontWeight(.bold)
                Spacer()
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(.gray)
                    Text(shoe.shoeHistory.lastWorn?.formatted(date: .abbreviated, time: .omitted) ?? "Never")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .fontWeight(.semibold)
                }
            }
            .frame(width: 150, alignment: .leading)
        }
        .padding(.vertical)
    }
}

private struct ShoeImageView: View {
    let imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 120)
    }
}

struct ShoeCollectionListItem_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ShoeCollectionListItem(shoe: Shoe.shoe1)
        }
        
    }
}
