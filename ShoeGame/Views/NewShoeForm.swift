//
//  NewShoeForm.swift
//  ShoeGame
//
//  Created by Elliot Hannah III on 4/24/23.
//

import SwiftUI

struct NewShoeForm: View {
    @State private var shoe = Shoe(brand: .jordan, model: "", colorWay: "", gender: "Mens", size: 8.5, dominantMaterial: .canvas, wornTotal: 0, currentCondition: "A", shoeHistory: ShoeHistory(lastActivityWorn: [.indoor], dateAdded: Date()), isFavorite: false, currentPhoto: "", currentlyWearing: false)
    @Environment(\.dismiss) var dismiss
    
    let conditionGrades = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D", "F"]
    let sizeRange = Array(stride(from: 4.0, through: 22, by: 0.5))
    
    var body: some View {
        Form {
            Section {
                //Where uploading photos will happen
                HStack {
                    Spacer()
                    Image(systemName: "photo")
                    Spacer()
                }
            }
            Section {
                Picker("Brand", selection: $shoe.brand) {
                    ForEach(Shoe.Brands.allCases, id: \.self) { brand in
                        Text(brand.rawValue)
                    }
                }
            }
            Section("Model") {
                TextField("Retro 11", text: $shoe.model)
            }
            Section("Colorway") {
                TextField("Concord", text: $shoe.colorWay)
                TextField("Style number (Optional)", text: Binding(
                    get: {self.shoe.styleNumber ?? ""},
                    set: {self.shoe.styleNumber = $0.isEmpty ? nil : $0}
                ))
                Picker("Material", selection: $shoe.dominantMaterial) {
                    ForEach(Shoe.MaterialTypes.allCases, id: \.self) { material in
                        Text("\(material.rawValue)")
                    }
                }
            }
            Section {
                HStack(spacing: 10) {
                    Picker("Size", selection: $shoe.gender) {
                        Text("Mens").tag("Mens")
                        Text("Womens").tag("Womens")
                    }
                    Picker("", selection: $shoe.size) {
                        ForEach(sizeRange, id: \.self) { sz in
                            Text(String(format: "%.1f", sz))
                        }
                    }
                    .labelsHidden()
                }
            }
            Section {
                Picker("Condition", selection: $shoe.currentCondition) {
                    ForEach(conditionGrades, id: \.self) { grade in
                        Text("\(grade)")
                    }
                }
            }
        }
        .navigationTitle("Add To Collection")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save", action: {
                    //save shoe to collection
                    dismiss()
                })
                .padding(.leading)
                .font(.body)
                .disabled(true) //gonna create a valid checker to to pass here
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel", action: {
                    dismiss()
                })
                .font(.body)
            }
        }
    }
}

struct NewShoeForm_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewShoeForm()
        }
        
    }
}
