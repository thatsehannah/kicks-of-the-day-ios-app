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
    
    func makeCreateAction() -> NewShoeForm.CreateAction {
        return { [weak self] shoe in
            self?.shoes.append(shoe)
        }
    }
}
