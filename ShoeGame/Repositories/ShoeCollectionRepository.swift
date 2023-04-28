//
//  ShoesRepository.swift
//  ShoeGame
//
//  Created by Elliot Hannah III on 4/25/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol ShoeRepositoryProtocol {
    func add(_ shoe: Shoe) async throws
    func fetchShoes() async throws -> [Shoe]
}

struct ShoeCollectionRepository: ShoeRepositoryProtocol {
    let shoeCollectionRef = Firestore.firestore().collection("shoe_collection")
    
    func add(_ shoe: Shoe) async throws -> Void {
        let document = shoeCollectionRef.document(shoe.id.uuidString)
        try await document.setData(from: shoe)
    }
    
    func fetchShoes() async throws -> [Shoe] {
        let snapshot = try await shoeCollectionRef.getDocuments()
        let shoes = snapshot.documents.compactMap { document in
            try! document.data(as: Shoe.self)
        }
        return shoes
    }
}

struct ShoeRepositoryStub: ShoeRepositoryProtocol {
    let state: ShoeViewModel.ShoeCollectionState
    
    private func simulate() async throws -> [Shoe] {
        switch self.state {
        case .loading:
            try await Task.sleep(nanoseconds: 10 * 1_000_000_000)
            fatalError("Timeout exceeded for 'loading' case preview")
        case .error(let error):
            throw error
        case .data(let shoes):
            return shoes
        case .empty:
            return [Shoe]()
        }
    }
    
    func add(_ shoe: Shoe) async throws {}
    
    func fetchShoes() async throws -> [Shoe] {
        return try await simulate()
    }
    
    
}

private extension DocumentReference {
    
    //Creates an async wrapper for the setData(from:) method in Cloud Firestore SDK to account for any possible errors that the setData function throws
    func setData<T: Encodable>(from value: T) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            try! setData(from: value) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
    }
}
