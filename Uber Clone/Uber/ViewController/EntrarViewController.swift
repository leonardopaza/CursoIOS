//
//  EntrarViewController.swift
//  Uber
//
//  Created by Leonardo Paza on 23/07/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import UIKit
import FirebaseAuth

class EntrarViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var senha: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func entrar(_ sender: Any) {
        let retorno = self.validarCampos()
        if retorno == "" {
            let autenticacao = Auth.auth()
            
            if let emailR = self.email.text {
                if let senhaR = self.senha.text {
                    autenticacao.signIn(withEmail: emailR, password: senhaR) { (usuario, erro) in
                        if erro == nil {
                            
                            if usuario == nil {
                                print("Erro ao logar usuário")
                            }
                            
                        } else {
                            print("Erro ao autenticar o usuário")
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
        } else if (self.senha.text?.isEmpty)! {
            return "Senha"
        }
        
        return ""
    }
}
