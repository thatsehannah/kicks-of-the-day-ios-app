//
//  Weather.swift
//  SneakerGame
//
//  Created by Elliot Hannah III on 5/2/23.
//

import Foundation

struct Weather {
    let city: String
    let temperature: String
    let description: String
    let iconName: String
    
    init(response: APIResponse) {
        self.city = response.name
        self.temperature = "\(Int(response.main.temp))"
        self.description = response.weather.first?.description ?? ""
        self.iconName = response.weather.first?.iconName ?? ""
    }
}
