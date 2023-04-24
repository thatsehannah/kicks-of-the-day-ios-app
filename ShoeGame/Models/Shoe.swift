//
//  Shoe.swift
//  ShoeGame
//
//  Created by Elliot Hannah III on 4/24/23.
//

import Foundation

struct Shoe: Identifiable {
    var id = UUID()
    var brand: Brands
    var model: String
    var colorWay: String
    var styleNumber: String? //will be useful for prepopulating shoes down the road
    var gender: String
    var size: Double
    var pricePaid: Double?
    var dominantMaterial: MaterialTypes
    var wornTotal: Int
    var currentCondition: String
    var shoeHistory: ShoeHistory
    var isFavorite: Bool
    var currentPhoto: String? //not sure if this will be an url
    var currentlyWearing: Bool
    
    var shoeName: String {
        return "\(brand.rawValue) \(model) '\(colorWay)'"
    }
    
    enum Brands: String, CaseIterable {
        case nike = "Nike"
        case jordan = "Air Jordan"
        case adidas = "Adidas"
        case puma = "Puma"
        case newBalance = "New Balance"
        case asics = "Asics"
        case vans = "Vans"
        case converse = "Converse"
        case reebok = "Reebok"
        case saucony = "Saucony"
        case bape = "Bape"
        case crocs = "Crocs"
        case other
    }
    
    enum MaterialTypes: String, CaseIterable {
        case suede = "Suede"
        case nubuck = "Nubuck"
        case leather = "Leather"
        case canvas = "Canvas"
        case denim = "Denim"
        case textile = "Textile"
        case plastic = "Plastic"
        case foam = "Foam"
        case rubber = "Rubber"
    }
}

struct ShoeHistory {
    var lastActivityWorn: [Activity]
    var dateAdded: Date
    var lastWorn: Date?
    var wornHistory: [Date]?
    var photos: [ShoePhotos]?
    
    enum Activity: String, CaseIterable {
        case indoor = "Indoors"
        case outdoor = "Outdoors"
        case work = "Working"
        case exercise = "Exercising"
    }
}

struct ShoePhotos {
    var photo: String? //not sure if this will be an url
    var dateOfPhoto: Date
}

extension Shoe {
    static let shoe1 = Shoe(brand: .jordan, model: "Retro 11", colorWay: "Concord", gender: "Mens", size: 10, dominantMaterial: .leather, wornTotal: 10, currentCondition: "A-", shoeHistory: ShoeHistory(lastActivityWorn: [.indoor], dateAdded: Date(), lastWorn: nil), isFavorite: true, currentPhoto: "concord", currentlyWearing: true)
    
    static let shoe2 = Shoe(brand: .adidas, model: "Yeezy 350", colorWay: "Zebra", gender: "Womens", size: 8, dominantMaterial: .textile, wornTotal: 7, currentCondition: "B+", shoeHistory: ShoeHistory(lastActivityWorn: [.indoor, .outdoor], dateAdded: Date(), lastWorn: Date()), isFavorite: true, currentPhoto: "zebra", currentlyWearing: false)
    
    static let shoes: [Shoe] = [shoe1, shoe2]
}
