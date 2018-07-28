//
//  Usuario.swift
//  Snapchat
//
//  Created by Leonardo Paza on 21/07/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import Foundation

class Usuario {
    var email: String
    var nome: String
    var uid: String
    
    init(email: String, nome: String, uid: String) {
        self.email = email
        self.nome = nome
        self.uid = uid
    }
}
