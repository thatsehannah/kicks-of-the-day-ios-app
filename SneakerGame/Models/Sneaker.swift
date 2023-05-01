//
//  Sneaker.swift
//  
//
//  Created by Elliot Hannah III on 4/24/23.
//

import Foundation

struct Sneaker: Identifiable, Codable {
    var id = UUID()
    var brand: Brands
    var model: String
    var colorWay: String
    var styleNumber: String? //will be useful for prepopulating sneakers down the road
    var gender: String
    var size: Double
    var pricePaid: Double?
    var dominantMaterial: MaterialTypes
    var wornTotal: Int
    var currentCondition: String
    var sneakerHistory: SneakerHistory
    var isFavorite: Bool
    var currentPhoto: String? //not sure if this will be an url
    var currentlyWearing: Bool
    
    static let genders = ["Mens", "Womens", "Kids"]
    static let conditionGrades = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D", "F"]
    static let sizeRanges = Array(stride(from: 3.5, through: 22, by: 0.5))
    
    init(id: UUID = UUID(), brand: Brands, model: String, colorWay: String, styleNumber: String? = nil, gender: String, size: Double, pricePaid: Double? = nil, dominantMaterial: MaterialTypes, wornTotal: Int, currentCondition: String, sneakerHistory: SneakerHistory, isFavorite: Bool, currentPhoto: String? = nil, currentlyWearing: Bool) {
        self.id = id
        self.brand = brand
        self.model = model
        self.colorWay = colorWay
        self.styleNumber = styleNumber
        self.gender = gender
        self.size = size
        self.pricePaid = pricePaid
        self.dominantMaterial = dominantMaterial
        self.wornTotal = wornTotal
        self.currentCondition = currentCondition
        self.sneakerHistory = sneakerHistory
        self.isFavorite = isFavorite
        self.currentPhoto = currentPhoto
        self.currentlyWearing = currentlyWearing
    }
    
    init() {
        self.brand = .none
        self.model = ""
        self.colorWay = ""
        self.gender = Sneaker.genders[0]
        self.size = Sneaker.sizeRanges[0]
        self.dominantMaterial = .none
        self.isFavorite = false
        self.wornTotal = 0
        self.currentCondition = Sneaker.conditionGrades[0]
        self.sneakerHistory = SneakerHistory(lastActivityWorn: [.none], dateAdded: Date())
        self.currentlyWearing = false
    }
    
    var sneakerName: String {
        return "\(brand.rawValue) \(model) '\(colorWay)'"
    }
    
    enum Brands: String, CaseIterable, Codable {
        case none = "Select Brand"
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
        case other = "Other"
    }
    
    enum MaterialTypes: String, CaseIterable, Codable {
        case none = "Select Material"
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

struct SneakerHistory: Codable {
    var lastActivityWorn: [Activity]
    var dateAdded: Date
    var lastWorn: Date?
    var wornHistory: [Date]?
    var photos: [SneakerPhoto]?
    
    enum Activity: String, CaseIterable, Codable {
        case indoor = "Indoors"
        case outdoor = "Outdoors"
        case work = "Working"
        case exercise = "Exercising"
        case none = "None"
    }
}

struct SneakerPhoto: Codable {
    var photo: String? //not sure if this will be an url
    var dateOfPhoto: Date
}

extension Sneaker {
    static let sneaker1 = Sneaker(brand: .jordan, model: "Retro 11", colorWay: "Concord", gender: "Mens", size: 10, dominantMaterial: .leather, wornTotal: 7, currentCondition: "A-", sneakerHistory: SneakerHistory(lastActivityWorn: [.indoor], dateAdded: Date(), lastWorn: nil), isFavorite: true, currentPhoto: "concord", currentlyWearing: true)
    static let sneaker2 = Sneaker(brand: .adidas, model: "Yeezy 350", colorWay: "Zebra", gender: "Womens", size: 8, dominantMaterial: .textile, wornTotal: 16, currentCondition: "B+", sneakerHistory: SneakerHistory(lastActivityWorn: [.indoor, .outdoor], dateAdded: Date(), lastWorn: Date()), isFavorite: true, currentPhoto: "zebra", currentlyWearing: false)
    static let sneakers: [Sneaker] = [sneaker1, sneaker2]
}
