//
//  Usuario.swift
//  WhatsApp
//
//  Created by Leonardo Paza on 31/07/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import Foundation

class Usuario {
    var nome: String
    var email: String
    var foto: String?
    
    init(nome: String, email: String) {
        self.nome = nome
        self.email = email
    }
}
