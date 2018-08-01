//
//  FirebaseUtil.swift
//  WhatsApp
//
//  Created by Leonardo Paza on 31/07/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseUtil {
    
    var auth: Auth!
    
    init() {
        self.auth = Auth.auth()
    }
    
    func recuperarChaveUsuarioLogado() -> String {
        if self.verificaUsuarioLogado() {
            if let usuarioLogado = self.auth.currentUser {
                if let email = usuarioLogado.email {
                    let chave = Base64().codificarStringBase64(texto: email)
                    return chave
                }
            }
        }
        
        return ""
    }
    
    func recuperarEmailUsuarioLogado() -> String {
        if self.verificaUsuarioLogado() {
            if let usuarioLogado = self.auth.currentUser {
                if let email = usuarioLogado.email {
                    return email
                }
            }
        }
        
        return ""
    }
    
    func verificaUsuarioLogado() -> Bool {
        return self.auth.currentUser != nil ? true : false
    }
}
