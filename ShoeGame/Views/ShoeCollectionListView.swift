//
//  ShoeCollectionListView.swift
//  ShoeGame
//
//  Created by Elliot Hannah III on 4/24/23.
//

import SwiftUI

struct ShoeCollectionListView: View {
    @StateObject var viewModel = ShoeViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                case .error(let error):
                    EmptyListView(
                        title: "Cannot Load Shoes",
                        message: error.localizedDescription) {
                            Button(action: {
                                Task {
                                    viewModel.fetchShoes()
                                }
                            }) {
                                Text("Try Again")
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
                            }
                        }
                case .empty:
                    EmptyListView(
                        title: "No Shoes",
                        message: "You don't have any shoes in your collection.\n Press the plus sign above to add.") {
                            NavigationLink(destination: NewShoeForm(addAction: viewModel.makeAddAction())) {
                                Text("Add to collection")
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
                            }
                        }
                case .data(let shoes):
                    List(shoes) { shoe in
                        ShoeCollectionListItem(shoe: shoe)
                    }
                }
            }
            .navigationTitle("Your Collection")
            .toolbar {
                NavigationLink(destination: NewShoeForm(addAction: viewModel.makeAddAction())) {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            viewModel.fetchShoes()
        }
    }
}

struct ShoeCollectionListView_Previews: PreviewProvider {
    @MainActor
    private struct ListPreview: View {
        let state: ShoeViewModel.ShoeCollectionState
        
        var body: some View {
            let shoeRepo = ShoeRepositoryStub(state: state)
            let viewModel = ShoeViewModel(shoeCollectionRepo: shoeRepo)
            ShoeCollectionListView(viewModel: viewModel)
        }
    }
    
    private struct PreviewError: LocalizedError {
        let errorDescription: String? = "Lorem ipsum dolor set amet."
    }
    
    static var previews: some View {
        Group {
            ListPreview(state: .loading)
                .previewDisplayName("Loading")
            ListPreview(state: .data(Shoe.shoes))
                .previewDisplayName("With Data")
            ListPreview(state: .error(PreviewError()))
                .previewDisplayName("Error")
            ListPreview(state: .empty)
                .previewDisplayName("Empty")
        }
    }
}
