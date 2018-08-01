//
//  Base64.swift
//  WhatsApp
//
//  Created by Leonardo Paza on 30/07/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import Foundation

class Base64 {
    
    func codificarStringBase64(texto: String) -> String {
        let dados = texto.data(using: String.Encoding.utf8)
        let base64 = dados?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        return base64!
    }
}
