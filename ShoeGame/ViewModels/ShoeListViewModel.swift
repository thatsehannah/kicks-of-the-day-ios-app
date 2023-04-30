//
//  ShoeListViewModel.swift
//  ShoeGame
//
//  Created by Elliot Hannah III on 4/24/23.
//

import Foundation



@MainActor
class ShoeListViewModel: ObservableObject {
    @Published var shoes = [Shoe]()
    @Published private(set) var state: ShoeCollectionState = .loading
    private let shoeCollectionRepo: ShoeRepositoryProtocol
    
    init(shoeCollectionRepo: ShoeRepositoryProtocol = ShoeCollectionRepository()) {
        self.shoeCollectionRepo = shoeCollectionRepo
    }
    
    enum ShoeCollectionState {
        case loading
        case empty
        case data([Shoe])
        case error(Error)
    }
    
    private func addShoeToList(_ shoe: Shoe) {
        switch state {
        case .empty, .loading:
            state = .data([shoe])
        case .data(var shoes):
            shoes.append(shoe)
            state = .data(shoes)
        case .error(_):
            break
        }
    }
    
    func makeSaveAction() -> ShoeForm.FormAction {
        return { [weak self] shoe in
            try await self?.shoeCollectionRepo.add(shoe)
            self?.addShoeToList(shoe)
        }
    }
    
    func fetchShoes() {
        state = .loading
        Task {
            do {
                shoes = try await shoeCollectionRepo.fetchShoes()
                if shoes.isEmpty {
                    self.state = .empty
                } else {
                    self.state = .data(shoes)
                }
            } catch {
                print("[ShoesViewModel] Cannot fetch shoes: \(error)")
                self.state = .error(error)
            }
        }
    }
}
