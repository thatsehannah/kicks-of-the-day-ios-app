//
//  NewShoeForm.swift
//  ShoeGame
//
//  Created by Elliot Hannah III on 4/24/23.
//

import SwiftUI

struct ShoeForm: View {
    typealias AddAction = (Shoe) async throws -> Void
    
    let addAction: AddAction
    let formTitle: String
    @State private var shoe: Shoe
    @State private var state = FormState.idle
    @Environment(\.dismiss) var dismiss
    
    init(addAction: @escaping AddAction, shoe: Shoe = Shoe(), formTitle: String ) {
        self.addAction = addAction
        _shoe = State(initialValue: shoe)
        self.formTitle = formTitle
    }
        
    private func saveShoe() {
        Task {
            state = .working
            do {
                try await addAction(shoe)
                
            } catch {
                print("[NewShoeForm] Cannot add shoe to collection: \(error)")
                state = .error
            }
        }
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
                TextField("e.g. Retro 11", text: $shoe.model)
            }
            Section("Colorway") {
                TextField("e.g. Concord", text: $shoe.colorWay)
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
        .disabled(state == .working)
        .overlay(workingOverlay)
        .navigationBarTitle(formTitle, displayMode: .inline)
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
        .alert("Cannot create shoe", isPresented: $state.isError) {
            Text("Sorry, something wen't wrong")
        }
    }
    
    @ViewBuilder private var workingOverlay: some View {
        if state == .working {
            ZStack {
                Color(white: 0, opacity: 0.35)
                ProgressView().tint(.white)
            }
        }
    }
}

extension ShoeForm {
    enum FormState {
        case idle, working, error

        //This will be used for the isPresented variable for the alert modifier
        //When the alert is dismissed, the value of it will be flipped and the state will be set to idle
        var isError: Bool {
            get {
                self == .error
            }
            set {
                guard !newValue else {return}
                self = .idle
            }
        }
    }
}

struct ShoeForm_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ShoeForm(addAction: { _ in }, formTitle: "Add to Collection")
        }
        .previewDisplayName("Adding Shoe")
        NavigationView {
            ShoeForm(addAction: { _ in }, shoe: Shoe.shoe1, formTitle: "Edit Shoe")
        }
        .previewDisplayName("Editing Shoe")
    }
}
