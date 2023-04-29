//
//  ShoeDetailView.swift
//  ShoeGame
//
//  Created by Elliot Hannah III on 4/28/23.
//

import SwiftUI

struct ShoeDetailView: View {
    let shoe: Shoe
    @ObservedObject var viewModel = ShoeViewModel()
    @State private var openForm = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomTrailing) {
                Image(shoe.currentPhoto ?? "blank")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                NavigationLink(destination: ShoeForm(addAction: viewModel.makeAddAction(), shoe: shoe, formTitle: "Edit Shoe"), isActive: $openForm) {
                    Button(action: {openForm = true}) {
                        Text("Edit")
                    }
                    .padding(.horizontal)
                    .foregroundColor(.black)
                    .background(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
//                    .offset(x: 155, y: 155)
                }
            }
            .padding()
            Divider()
            VStack(alignment: .leading, spacing: 10) {
                Group {
                    Text("\(shoe.brand.rawValue) \(shoe.model)")
                        .font(.largeTitle)
                    Text("'\(shoe.colorWay)'")
                        .font(.largeTitle.bold())
                    Divider()
                        .padding(.vertical)
                    HStack {
                        Text("Size:")
                        Text("\(shoe.gender) \(String(format: "%.1f", shoe.size))")
                            .fontWeight(.bold)
                    }
                    HStack {
                        let totals = shoe.wornTotal > 10 ? "10+" : String(shoe.wornTotal)
                        Text("Worn Total:")
                        Text("\(totals)")
                            .fontWeight(.bold)
                    }
                    HStack(alignment: .top) {
                        Text("Last Worn:")
                        Text(shoe.shoeHistory.lastWorn?.formatted(date: .abbreviated, time: .omitted) ?? "Never")
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        HStack {
                            Text("Condition:")
                            Text("\(shoe.currentCondition)")
                                .fontWeight(.bold)
                        }
                        Spacer()
                        Text("Material:")
                        Text("\(shoe.dominantMaterial.rawValue)")
                            .fontWeight(.bold)
                    }
                }
                .padding(.horizontal)
            }
        }
        
        .navigationBarTitle("Shoe Detail", displayMode: .inline)
        .safeAreaInset(edge: .bottom) {
            Group {
                NavigationLink(destination: EmptyView()) {
                    Button(action: {}) {
                        Text("WEAR")
                            .font(.title2)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 5))
                }
                
                
            }
            .padding()
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: {}) {
                        Label("Favorite", systemImage: "heart")
                    }
                    .foregroundColor(.black)
                    Button(action: {}) {
                        Label("Delete", systemImage: "trash")
                    }
                    .foregroundColor(.black)
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
