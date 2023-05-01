//
//  SneakerDetailView.swift
//  SneakerGame
//
//  Created by Elliot Hannah III on 4/28/23.
//

import SwiftUI

struct SneakerDetailView: View {
    @State var sneaker: Sneaker
    @State var formState: SneakerForm.FormState = SneakerForm.FormState.idle
    @ObservedObject var viewModel = SneakerListViewModel()
    @State private var isFormPresenting = false
    
    private func update(sneaker: Sneaker) {
        formState = .working
        Task {
            do {
                try await viewModel.update(sneaker: sneaker)
                formState = .idle
            } catch {
                print("[SneakerDetailView] Cannot make changes to collection: \(error)")
                formState = .error
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomTrailing) {
                Image(sneaker.currentPhoto ?? "blank")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Button(action: {
                    isFormPresenting = true
                }) {
                    Text("Edit")
                }
                .padding(.horizontal)
                .foregroundColor(.black)
                .background(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
                //                    .offset(x: 155, y: 155)
                
            }
            .padding()
            Divider()
            VStack(alignment: .leading, spacing: 10) {
                Group {
                    Text("\(sneaker.brand.rawValue) \(sneaker.model)")
                        .font(.largeTitle)
                    Text("'\(sneaker.colorWay)'")
                        .font(.largeTitle.bold())
                    Divider()
                        .padding(.vertical)
                    HStack {
                        Text("Size:")
                        Text("\(sneaker.gender) \(String(format: "%.1f", sneaker.size))")
                            .fontWeight(.bold)
                    }
                    HStack {
                        let totals = sneaker.wornTotal > 10 ? "10+" : String(sneaker.wornTotal)
                        Text("Worn Total:")
                        Text("\(totals)")
                            .fontWeight(.bold)
                    }
                    HStack(alignment: .top) {
                        Text("Last Worn:")
                        Text(sneaker.sneakerHistory.lastWorn?.formatted(date: .abbreviated, time: .omitted) ?? "Never")
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        HStack {
                            Text("Condition:")
                            Text("\(sneaker.currentCondition)")
                                .fontWeight(.bold)
                        }
                        Spacer()
                        Text("Material:")
                        Text("\(sneaker.dominantMaterial.rawValue)")
                            .fontWeight(.bold)
                    }
                }
                .padding(.horizontal)
            }
        }
        
        .navigationBarTitle("Sneaker Detail", displayMode: .inline)
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
        .sheet(isPresented: $isFormPresenting) {
            NavigationView {
                SneakerForm(sneaker: $sneaker, formState: $formState)
                    .navigationTitle("Edit Sneaker")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel", action: {
                                isFormPresenting = false
                            })
                            .font(.body)
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save", action: {
                                update(sneaker: sneaker)
                                isFormPresenting = false
                            })
                            .padding(.leading)
                            .font(.body)
                            .disabled(sneaker.brand == .none || sneaker.model.isEmpty || sneaker.colorWay.isEmpty || sneaker.dominantMaterial == .none)
                        }
                    }
            }
        }
    }
}

struct SneakerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SneakerDetailView(sneaker: Sneaker.sneaker2)
        }
        
    }
}
