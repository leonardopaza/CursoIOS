//
//  CadastroViewController.swift
//  WhatsApp
//
//  Created by Leonardo Paza on 30/07/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CadastroViewController: UIViewController {

    @IBOutlet weak var campoNome: UITextField!
    @IBOutlet weak var campoEmail: UITextField!
    @IBOutlet weak var campoSenha: UITextField!
    
    var auth: Auth!
    var database: Database!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.auth = Auth.auth()
        self.database = Database.database()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func cadastrar(_ sender: Any) {
        if let nome = self.campoNome.text {
            if let email = self.campoEmail.text {
                if let senha = self.campoSenha.text {
                    
                    self.auth.createUser(withEmail: email, password: senha) { (usuario, erro) in
                        if erro == nil {
                            
                            var usuarioDatabase: Dictionary<String, String> = [:]
                            usuarioDatabase["nome"] = nome
                            usuarioDatabase["email"] = email
                            
                            let chave = Base64().codificarStringBase64(texto: email)
                            
                            let usuarios = self.database.reference().child("usuarios")
                            usuarios.child(chave).setValue(usuarioDatabase)
                            
                        } else {
                            print("Erro ao cadastrar usuário!")
                        }
                    }
                    
                } else {
                    print("Digite uma senha")
                }
            } else {
                print("Digite seu email")
            }
        } else {
            print("Digite seu nome")
        }
    }
}
