//
//  SneakerCollectionListView.swift
//  SneakerGame
//
//  Created by Elliot Hannah III on 4/24/23.
//

import SwiftUI

struct SneakerCollectionListView: View {
    @StateObject var viewModel = SneakerListViewModel()
    
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
                        message: "You don't have any sneakers in your collection.\n Press the plus sign above to add.") {
                            NavigationLink(destination: SneakerForm(saveAction: viewModel.makeSaveAction(), sneaker: Sneaker(), formTitle: "Add to Collection")) {
                                Text("Add to collection")
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
                            }
                        }
                case .data(let sneakers):
                    List(sneakers) { sneaker in
                        SneakerCollectionListItem(sneaker: sneaker)
                    }
                }
            }
            .navigationTitle("Your Collection")
            .toolbar {
                NavigationLink(destination: SneakerForm(saveAction: viewModel.makeSaveAction(), sneaker: Sneaker(), formTitle: "Add to Collection")) {
                    Image(systemName: "plus")
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
