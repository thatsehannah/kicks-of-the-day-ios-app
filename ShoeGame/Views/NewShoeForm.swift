//
//  NewShoeForm.swift
//  ShoeGame
//
//  Created by Elliot Hannah III on 4/24/23.
//

import SwiftUI

struct NewShoeForm: View {
    typealias CreateAction = (Shoe) -> Void
    
    let createAction: CreateAction
    @State private var shoe = Shoe()
    @Environment(\.dismiss) var dismiss
        
    private func saveShoe() {
        createAction(shoe)
    }
    
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
                        ForEach(Shoe.genders, id: \.self) { gender in
                            Text("\(gender)")
                        }
                        
                    }
                    Picker("", selection: $shoe.size) {
                        ForEach(Shoe.sizeRanges, id: \.self) { sz in
                            Text(String(format: "%.1f", sz))
                        }
                    }
                    .labelsHidden()
                }
            }
            Section {
                Picker("Condition", selection: $shoe.currentCondition) {
                    ForEach(Shoe.conditionGrades, id: \.self) { grade in
                        Text("\(grade)")
                    }
                }
            }
        }
        .navigationTitle("Add To Collection")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel", action: {
                    dismiss()
                })
                .font(.body)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save", action: {
                    saveShoe()
                    dismiss()
                })
                .padding(.leading)
                .font(.body)
                .disabled(shoe.brand == .none || shoe.model.isEmpty || shoe.colorWay.isEmpty || shoe.dominantMaterial == .none)
            }
        }
    }
}

struct NewShoeForm_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewShoeForm(createAction: { _ in })
        }
        
    }
}
