//
//  CadastroViewController.swift
//  Uber
//
//  Created by Leonardo Paza on 23/07/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CadastroViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var nomeCompleto: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var tipoUsuario: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func cadastrarUsuario(_ sender: Any) {
        let retorno = self.validarCampos()
        if retorno == "" {
            let autenticacao = Auth.auth()
            
            if let emailR = self.email.text {
                if let nomeR = self.nomeCompleto.text {
                    if let senhaR = self.senha.text {
                        
                        autenticacao.createUser(withEmail: emailR, password: senhaR) { (usuario, erro) in
                            if erro == nil {
                                
                                if usuario != nil {
                                    let database = Database.database().reference()
                                    let usuarios = database.child("usuarios")
                                    
                                    var tipo = ""
                                    if self.tipoUsuario.isOn {
                                        tipo = "passageiro"
                                    } else {
                                        tipo = "motorista"
                                    }
                                    
                                    let dadosUsuario = [
                                        "email" : usuario?.email,
                                        "nome" : nomeR,
                                        "tipo" : tipo
                                    ]
                                    usuarios.child((usuario?.uid)!).setValue(dadosUsuario)
                                } else {
                                    print("Erro ao autenticar")
                                }
                                
                            } else {
                                print("Erro ao criar conta do uses")
                            }
                        }
                        
                    }
                }
            }
            
        } else {
            print("O campo \(retorno) não foi preenchido!")
        }
        
    }
    
    func validarCampos() -> String {
        if (self.email.text?.isEmpty)! {
            return "E-mail"
        } else if (self.nomeCompleto.text?.isEmpty)! {
            return "Nome completo"
        } else if (self.senha.text?.isEmpty)! {
            return "Senha"
        }
        
        return ""
    }
}
