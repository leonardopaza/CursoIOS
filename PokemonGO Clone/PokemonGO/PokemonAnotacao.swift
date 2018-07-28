//
//  PokemonAnotacao.swift
//  PokemonGO
//
//  Created by Leonardo Paza on 12/07/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import UIKit
import MapKit

class PokemonAnotacao: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    
    init(coordenadas: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordenadas
        self.pokemon = pokemon
    }
}
