//
//  Filme.swift
//  Meus Filmes
//
//  Created by Leonardo Paza on 29/06/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import UIKit

class Filme {
    
    var titulo: String!
    var descricao: String!
    var imagem: UIImage!
    
    init(titulo: String, descricao: String, imagem: UIImage) {
        self.titulo = titulo
        self.descricao = descricao
        self.imagem = imagem
    }
    
}
