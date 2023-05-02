//
//  SneakerListViewModel.swift
//  
//
//  Created by Elliot Hannah III on 4/24/23.
//

import Foundation

@MainActor
class SneakerListViewModel: ObservableObject {
    @Published var sneakers = [Sneaker]()
    @Published private(set) var state: SneakerCollectionState = .loading
    private let sneakerCollectionRepo: SneakerRepositoryProtocol
    
    init(sneakerCollectionRepo: SneakerRepositoryProtocol = SneakerCollectionRepository()) {
        self.sneakerCollectionRepo = sneakerCollectionRepo
    }
    
    enum SneakerCollectionState {
        case loading
        case empty
        case data([Sneaker])
        case error(Error)
    }
    
    func add(sneaker: Sneaker) async throws {
        try await sneakerCollectionRepo.add(sneaker)
        fetchSneakers()
    }
    
    func update(sneaker: Sneaker) async throws {
        try await sneakerCollectionRepo.update(sneaker)
    }
    
    func toggleFavorite(sneaker: Sneaker) async throws {
        try await sneakerCollectionRepo.toggleFavorite(sneaker)
    }
    
    func delete(sneaker: Sneaker) async throws {
        try await sneakerCollectionRepo.delete(sneaker)
        fetchSneakers()
    }
    
    func fetchSneakers() {
        state = .loading
        Task {
            do {
                sneakers = try await sneakerCollectionRepo.fetchSneakers()
                if sneakers.isEmpty {
                    self.state = .empty
                } else {
                    self.state = .data(sneakers)
                }
            } catch {
                print("[SneakersViewModel] Cannot fetch sneakers: \(error)")
                self.state = .error(error)
            }
        }
    }
}
