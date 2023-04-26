//
//  ShoesRepository.swift
//  ShoeGame
//
//  Created by Elliot Hannah III on 4/25/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ShoeCollectionRepository {
    static let shoeCollectionRef = Firestore.firestore().collection("shoe_collection")
    
    static func add(_ shoe: Shoe) async throws -> Void {
        let document = shoeCollectionRef.document(shoe.id.uuidString)
        try await document.setData(from: shoe)
    }
    
    static func fetchShoes() async throws -> [Shoe] {
        let snapshot = try await shoeCollectionRef.getDocuments()
        let shoes = snapshot.documents.compactMap { document in
            try! document.data(as: Shoe.self)
        }
        return shoes
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
