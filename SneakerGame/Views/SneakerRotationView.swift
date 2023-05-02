//
//  SneakerRotationView.swift
//  SneakerGame
//
//  Created by Elliot Hannah III on 5/2/23.
//

import SwiftUI

struct SneakerRotationView: View {
    var body: some View {
        WeatherView(viewModel: WeatherViewModel(weatherService: WeatherService()))
    }
}

struct SneakerRotationView_Previews: PreviewProvider {
    static var previews: some View {
        SneakerRotationView()
    }
}
