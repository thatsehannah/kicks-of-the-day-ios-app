//
//  ShoeDetailView.swift
//  ShoeGame
//
//  Created by Elliot Hannah III on 4/28/23.
//

import SwiftUI

struct ShoeDetailView: View {
    let shoe: Shoe
    
    var body: some View {
        VStack {
            VStack {
                Image(shoe.currentPhoto ?? "blank")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 80)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(shoe.brand.rawValue) \(shoe.model)")
                        .font(.title2)
                    Text("'\(shoe.colorWay)'")
                        .font(.largeTitle.bold())
                    Text("Worn Total: \(shoe.wornTotal)")
                        .font(.title2)
                }
                Spacer()
            }
            .frame(width: .infinity, height: .infinity)
        }
        .padding()
        .navigationBarTitle("Shoe Detail", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: {}) {
                        Label("Heart", systemImage: "heart")
                    }
                    Button(action: {}) {
                        Label("Heart", systemImage: "trash")
                    }
                }
                
            }
        }
    }
}

struct ShoeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ShoeDetailView(shoe: Shoe.shoe2)
        }
        
    }
}
