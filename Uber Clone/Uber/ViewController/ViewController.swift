//
//  ViewController.swift
//  Uber
//
//  Created by Leonardo Paza on 23/07/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let autenticacao = Auth.auth()
        autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
            if let usuarioLogado = usuario {
                let database = Database.database().reference()
                let usuarios = database.child("usuarios").child(usuarioLogado.uid)
                
                usuarios.observeSingleEvent(of: .value, with: { (snapshot) in
                    let dados = snapshot.value as? NSDictionary
                    
                    if dados != nil {
                        let tipoUsuario = dados!["tipo"] as! String
                        
                        if tipoUsuario == "passageiro" {
                            self.performSegue(withIdentifier: "segueLoginPrincipal", sender: nil)
                        } else {
                            self.performSegue(withIdentifier: "segueLoginPrincipalMotorista", sender: nil)
                        }
                    }
                })
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
