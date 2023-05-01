//
//  NewSneakerForm.swift
//  SneakerGame
//
//  Created by Elliot Hannah III on 4/24/23.
//

import SwiftUI

struct SneakerForm: View {
    @Binding var sneaker: Sneaker
    @Binding var formState: FormState
    
    init(sneaker: Binding<Sneaker>, formState: Binding<FormState> = .constant(FormState.idle)) {
        _sneaker = sneaker
        _formState = formState
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
                Picker("Brand", selection: $sneaker.brand) {
                    ForEach(Sneaker.Brands.allCases, id: \.self) { brand in
                        Text(brand.rawValue)
                    }
                }
            }
            Section("Model") {
                TextField("e.g. Retro 11", text: $sneaker.model)
            }
            Section("Colorway") {
                TextField("e.g. Concord", text: $sneaker.colorWay)
                TextField("Style number (Optional)", text: Binding(
                    get: {self.sneaker.styleNumber ?? ""},
                    set: {self.sneaker.styleNumber = $0.isEmpty ? nil : $0}
                ))
                Picker("Material", selection: $sneaker.dominantMaterial) {
                    ForEach(Sneaker.MaterialTypes.allCases, id: \.self) { material in
                        Text("\(material.rawValue)")
                    }
                }
            }
            Section {
                HStack(spacing: 10) {
                    Picker("Size", selection: $sneaker.gender) {
                        ForEach(Sneaker.genders, id: \.self) { gender in
                            Text("\(gender)")
                        }
                        
                    }
                    Picker("", selection: $sneaker.size) {
                        ForEach(Sneaker.sizeRanges, id: \.self) { sz in
                            Text(String(format: "%.1f", sz))
                        }
                    }
                    .labelsHidden()
                }
            }
            Section {
                Picker("Condition", selection: $sneaker.currentCondition) {
                    ForEach(Sneaker.conditionGrades, id: \.self) { grade in
                        Text("\(grade)")
                    }
                }
            }
        }
        .disabled(formState == .working)
        .overlay(workingOverlay)
        .alert("Cannot create sneaker", isPresented: $formState.isError) {
            Text("Sorry, something wen't wrong")
        }
    }
    
    @ViewBuilder private var workingOverlay: some View {
        if formState == .working {
            ZStack {
                Color(white: 0, opacity: 0.35)
                ProgressView().tint(.white)
            }
        }
    }
}

extension SneakerForm {
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

struct SneakerForm_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SneakerForm(sneaker: .constant(Sneaker()) )
        }
        .previewDisplayName("Adding Sneaker")
        NavigationView {
            SneakerForm(sneaker: .constant(Sneaker.sneaker1))
        }
        .previewDisplayName("Editing Sneaker")
    }
}
