//
//  NewSneakerForm.swift
//  SneakerGame
//
//  Created by Elliot Hannah III on 4/24/23.
//

import SwiftUI

struct SneakerForm: View {
    typealias FormAction = (Sneaker) async throws -> Void
    
    let saveAction: FormAction
    let formTitle: String
    @State private var sneaker: Sneaker
    @State private var state = FormState.idle
    @Environment(\.dismiss) var dismiss
    
    init(saveAction: @escaping FormAction, sneaker: Sneaker, formTitle: String ) {
        self.saveAction = saveAction
        _sneaker = State(initialValue: sneaker)
        self.formTitle = formTitle
    }
    
    enum EditSneakerMode {
        case add
        case edit
    }
        
    private func saveSneaker() {
        Task {
            state = .working
            do {
                try await saveAction(sneaker)
                
            } catch {
                print("[SneakerForm] Cannot add sneaker to collection: \(error)")
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
                    saveSneaker()
                    dismiss()
                })
                .padding(.leading)
                .font(.body)
                .disabled(sneaker.brand == .none || sneaker.model.isEmpty || sneaker.colorWay.isEmpty || sneaker.dominantMaterial == .none)
            }
        }
        .alert("Cannot create sneaker", isPresented: $state.isError) {
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
            SneakerForm(saveAction: { _ in }, sneaker: Sneaker(), formTitle: "Add to Collection")
        }
        .previewDisplayName("Adding Sneaker")
        NavigationView {
            SneakerForm(saveAction: { _ in }, sneaker: Sneaker.sneaker1, formTitle: "Edit Sneaker")
        }
        .previewDisplayName("Editing Sneaker")
    }
}
