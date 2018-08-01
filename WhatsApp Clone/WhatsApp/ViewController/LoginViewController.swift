//
//  LoginViewController.swift
//  WhatsApp
//
//  Created by Leonardo Paza on 30/07/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var campoEmail: UITextField!
    @IBOutlet weak var campoSenha: UITextField!
    
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.auth = Auth.auth()
        
        self.auth.addStateDidChangeListener { (autenticacao, usuario) in
            if usuario != nil {
                self.performSegue(withIdentifier: "segueLoginAutomatico", sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func logar(_ sender: Any) {
        if let email = self.campoEmail.text {
            if let senha = self.campoSenha.text {
                
                self.auth.signIn(withEmail: email, password: senha) { (usuario, erro) in
                    if erro == nil {
                        
                        if let usuarioLogado = usuario {
                            print("Usuario logado")
                        }
                        
                    } else {
                        print("Erro ao logar")
                    }
                }
                
            } else {
                print("Digite uma senha")
            }
        } else {
            print("Digite um email")
        }
    }
}
