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
            ShoeImageView(imageName: shoe.currentPhoto ?? "blank")
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
            .frame(width: 120, height: 80)
    }
}

struct ShoeCollectionListItem_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ShoeCollectionListItem(shoe: Shoe.shoe1)
        }
        .previewDisplayName("With Image")

        List {
            ShoeCollectionListItem(shoe: Shoe(brand: .adidas, model: "Yeezy 700", colorWay: "WaveRunner", gender: Shoe.genders[0], size: Shoe.sizeRanges[12], dominantMaterial: .nubuck, wornTotal: 0, currentCondition: Shoe.conditionGrades[3], shoeHistory: ShoeHistory(lastActivityWorn: [.none], dateAdded: Date()), isFavorite: false, currentlyWearing: false))
        }
        .previewDisplayName("No Image")
        
    }
}
