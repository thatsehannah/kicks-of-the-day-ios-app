//
//  SneakerCollectionListView.swift
//  SneakerGame
//
//  Created by Elliot Hannah III on 4/24/23.
//

import SwiftUI

struct SneakerCollectionListView: View {
    @StateObject var viewModel = SneakerListViewModel()
    @State private var newSneaker = Sneaker()
    @State private var isFormPresenting = false
    @State private var formState = SneakerForm.FormState.idle
    
    private func save(sneaker: Sneaker) {
        formState = .working
        Task {
            do {
                try await viewModel.add(sneaker: sneaker)
                formState = .idle
            } catch {
                print("[SneakerCollectionListView] Cannot make changes to collection: \(error)")
                formState = .error
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                case .error(let error):
                    EmptyListView(
                        title: "Cannot Load Sneakers",
                        message: error.localizedDescription) {
                            Button(action: {
                                Task {
                                    viewModel.fetchSneakers()
                                }
                            }) {
                                Text("Try Again")
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
                            }
                        }
                case .empty:
                    EmptyListView(
                        title: "No Sneakers",
                        message: "You don't have any sneakers in your collection") {
                            Button(action: {
                                newSneaker = Sneaker()
                                isFormPresenting = true
                            }) {
                                Text("Add to Collection")
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
                            }
                        }
                case .data(let sneakers):
                    List(sneakers) { sneaker in
                        let sneakerBinding = Binding<Sneaker>(
                            get: { viewModel.sneakers.first(where: { $0.id == sneaker.id }) ?? sneaker },
                            set: { updatedSneaker in
                                if let index = viewModel.sneakers.firstIndex(where: { $0.id == updatedSneaker.id }) {
                                    viewModel.sneakers[index] = updatedSneaker
                                }
                            }
                        )
                        SneakerCollectionListItem(sneaker: sneakerBinding)
                    }
                }
            }
            .navigationTitle("Your Collection")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        newSneaker = Sneaker()
                        isFormPresenting = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            .sheet(isPresented: $isFormPresenting) {
                NavigationView {
                    SneakerForm(sneaker: $newSneaker, formState: $formState)
                        .navigationTitle("Add To Collection")
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Cancel", action: {
                                    isFormPresenting = false
                                })
                                .font(.body)
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Save", action: {
                                    save(sneaker: newSneaker)
                                    isFormPresenting = false
                                })
                                .padding(.leading)
                                .font(.body)
                                .disabled(newSneaker.brand == .none || newSneaker.model.isEmpty || newSneaker.colorWay.isEmpty || newSneaker.dominantMaterial == .none)
                            }
                        }
                }
            }
        }
        .onAppear {
            viewModel.fetchSneakers()
        }
    }
}

struct SneakerCollectionListView_Previews: PreviewProvider {
    @MainActor
    private struct ListPreview: View {
        let state: SneakerListViewModel.SneakerCollectionState
        
        var body: some View {
            let sneakerRepo = SneakerRepositoryStub(state: state)
            let viewModel = SneakerListViewModel(sneakerCollectionRepo: sneakerRepo)
            SneakerCollectionListView(viewModel: viewModel)
        }
    }
    
    private struct PreviewError: LocalizedError {
        let errorDescription: String? = "Lorem ipsum dolor set amet."
    }
    
    static var previews: some View {
        Group {
            ListPreview(state: .loading)
                .previewDisplayName("Loading")
            ListPreview(state: .data(Sneaker.sneakers))
                .previewDisplayName("With Data")
            ListPreview(state: .error(PreviewError()))
                .previewDisplayName("Error")
            ListPreview(state: .empty)
                .previewDisplayName("Empty")
        }
    }
}
