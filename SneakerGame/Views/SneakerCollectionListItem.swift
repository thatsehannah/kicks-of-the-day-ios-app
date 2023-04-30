//
//  SneakerCollectionListItem.swift
//  SneakerGame
//
//  Created by Elliot Hannah III on 4/24/23.
//

import SwiftUI

struct SneakerCollectionListItem: View {
    let sneaker: Sneaker
    
    var body: some View {
        HStack {
            SneakerImageView(imageName: sneaker.currentPhoto ?? "blank")
            Spacer()
            NavigationLink(destination: SneakerDetailView(sneaker: sneaker)) {
                VStack(alignment: .leading) {
                    Text(sneaker.sneakerName)
                        .font(.body)
                        .fontWeight(.bold)
                    Spacer()
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundColor(.gray)
                        Text(sneaker.sneakerHistory.lastWorn?.formatted(date: .abbreviated, time: .omitted) ?? "Never")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .fontWeight(.semibold)
                    }
                }
                .frame(width: 150, alignment: .leading)
            }
            
        }
        .padding(.vertical)
    }
}

private struct SneakerImageView: View {
    let imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 120, height: 80)
    }
}

struct SneakerCollectionListItem_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SneakerCollectionListItem(sneaker: Sneaker.sneaker1)
        }
        .previewDisplayName("With Image")

        List {
            SneakerCollectionListItem(sneaker: Sneaker(brand: .adidas, model: "Yeezy 700", colorWay: "WaveRunner", gender: Sneaker.genders[0], size: Sneaker.sizeRanges[12], dominantMaterial: .nubuck, wornTotal: 0, currentCondition: Sneaker.conditionGrades[3], sneakerHistory: SneakerHistory(lastActivityWorn: [.none], dateAdded: Date()), isFavorite: false, currentlyWearing: false))
        }
        .previewDisplayName("No Image")
        
    }
}
