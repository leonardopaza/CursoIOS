//
//  CadastroViewController.swift
//  Snapchat
//
//  Created by Leonardo Paza on 17/07/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CadastroViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var nomeCompleto: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var senhaConfirmacao: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func criarConta(_ sender: Any) {
        //Recuperar dados digitados
        if let emailR = self.email.text {
            if let nomeCompletoR = self.nomeCompleto.text {
                if let senhaR = self.senha.text {
                    if let senhaConfirmacaoR = self.senhaConfirmacao.text {
                        //Validar senha
                        if senhaR == senhaConfirmacaoR {
                            
                            if nomeCompletoR != "" {
                                //Criar conta no Firebase
                                let autenticacao = Auth.auth()
                                autenticacao.createUser(withEmail: emailR, password: senhaR) { (usuario, erro) in
                                    if erro == nil {
                                        
                                        if usuario == nil {
                                            let alerta = Alerta(titulo: "Erro ao autenticar", mensagem: "Problema ao realizar autenticação, tente novamente!")
                                            self.present(alerta.getAlerta(), animated: true, completion: nil)
                                        } else {
                                            let database = Database.database().reference()
                                            let usuarios = database.child("usuarios")
                                            let usuarioDados = ["nome": nomeCompletoR, "email": emailR]
                                            usuarios.child(usuario!.uid).setValue(usuarioDados)
                                            
                                            self.performSegue(withIdentifier: "cadastroLoginSegue", sender: nil)
                                        }
                                        
                                    } else {
                                        let erroR = erro! as NSError
                                        if let codigoErro = erroR.userInfo["error_name"] {
                                            
                                            let erroTexto = codigoErro as! String
                                            var mensagemErro = ""
                                            switch erroTexto {
                                            case "ERROR_INVALID_EMAIL":
                                                mensagemErro = "E-mail inválido, digite um e-mail válido!"
                                                break
                                            case "ERROR_WEAK_PASSWORD":
                                                mensagemErro = "Senha precisa ter no mínimo 6 caracteres, com letras e números!"
                                                break
                                            case "ERROR_EMAIL_ALREADY_IN_USE":
                                                mensagemErro = "Esse e-mail já está sendo utilizado, crie sua conta com outro e-mail!"
                                                break
                                            default:
                                                mensagemErro = "Dados digitados estão incorretos!"
                                            }
                                            let alerta = Alerta(titulo: "Dados inválidos", mensagem: mensagemErro)
                                            self.present(alerta.getAlerta(), animated: true, completion: nil)
                                            
                                        }
                                    }
                                }
                            } else {
                                let alerta = Alerta(titulo: "Dados incorretos", mensagem: "Digite o seu nome para prosseguir!")
                                self.present(alerta.getAlerta(), animated: true, completion: nil)
                            }
                            
                        } else {
                            let alerta = Alerta(titulo: "Dados incorretos", mensagem: "As senhas não estão iguais, digite novamente!")
                            self.present(alerta.getAlerta(), animated: true, completion: nil)
                        }
                        
                    }
                }
            }
        }
    }
}
