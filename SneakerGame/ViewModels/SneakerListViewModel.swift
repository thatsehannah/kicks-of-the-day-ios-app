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
    
    private func addSneakerToList(_ sneaker: Sneaker) {
        switch state {
        case .empty, .loading:
            state = .data([sneaker])
        case .data(var sneakers):
            sneakers.append(sneaker)
            state = .data(sneakers)
        case .error(_):
            break
        }
    }
    
    func add(sneaker: Sneaker) async throws {
        try await sneakerCollectionRepo.add(sneaker)
        addSneakerToList(sneaker)
    }
    
    func update(sneaker: Sneaker) async throws {
        try await sneakerCollectionRepo.update(sneaker)
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
