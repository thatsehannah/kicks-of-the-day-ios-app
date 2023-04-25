//
//  ShoeViewModel.swift
//  ShoeGame
//
//  Created by Elliot Hannah III on 4/24/23.
//

import Foundation

@MainActor
class ShoeViewModel: ObservableObject {
    @Published var shoes = Shoe.shoes
    
    func makeAddAction() -> NewShoeForm.AddAction {
        return { [weak self] shoe in
            try await ShoeCollectionRepository.add(shoe)
            self?.shoes.append(shoe)
        }
    }
}
