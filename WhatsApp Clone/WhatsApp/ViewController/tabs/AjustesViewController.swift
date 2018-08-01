//
//  AjustesViewController.swift
//  WhatsApp
//
//  Created by Leonardo Paza on 30/07/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SDWebImage

class AjustesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var email: UILabel!
    
    var auth: Auth!
    var armazenamento: Storage!
    var database: DatabaseReference!
    var imagePicker = UIImagePickerController()
    var usuario: Usuario!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.auth = Auth.auth()
        self.armazenamento = Storage.storage()
        self.database = Database.database().reference()
        imagePicker.delegate = self
        
        self.imagem.image = #imageLiteral(resourceName: "padrao")
        self.recuperarUsuario()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imagemRecuperada = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imagem.image = imagemRecuperada
        
        if let imagem = UIImageJPEGRepresentation(imagemRecuperada, 0.3) {
            let chave = FirebaseUtil().recuperarChaveUsuarioLogado()
            
            let imagens = self.armazenamento.reference().child("imagens")
            let nomeImagem = "\(chave).jpg"
            imagens.child("perfil").child(nomeImagem).putData(imagem, metadata: nil) { (metaData, erro) in
                if erro == nil {
                    print("Sucesso ao fazer o upload!")
                } else {
                    print("Erro ao fazer o upload!")
                }
            }
            
            self.atualizarDadosUsuario(foto: nomeImagem)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func atualizarDadosUsuario(foto: String) {
        let usuarios = self.database.child("usuarios")
        let chave = FirebaseUtil().recuperarChaveUsuarioLogado()
        
        let dadosUsuario = [
            "nome": self.usuario.nome,
            "email": self.usuario.email,
            "foto": foto
        ]
        usuarios.child(chave).setValue(dadosUsuario)
    }
    
    func recuperarUsuario() {
        let usuarios = self.database.child("usuarios")
        let chave = FirebaseUtil().recuperarChaveUsuarioLogado()
        let usuarioLogado = usuarios.child(chave)
        usuarioLogado.observeSingleEvent(of: .value) { (snapshot) in
            let dados = snapshot.value as? NSDictionary
            let nome = dados!["nome"] as? String
            let email = dados!["email"] as? String
            
            self.usuario = Usuario(nome: nome!, email: email!)
            self.nome.text = nome
            self.email.text = email
            
            if snapshot.hasChild("foto") {
                let foto = dados!["foto"] as? String
                self.usuario.foto = foto
                
                let imagens = self.armazenamento.reference().child("imagens")
                let localImagem = imagens.child("perfil").child(foto!)
                
                localImagem.getMetadata(completion: { (metaData, erro) in
                    if erro == nil {
                        let url = metaData?.downloadURL()?.absoluteURL
                        self.imagem.sd_setImage(with: url, completed: { (image, erro, cache, url) in
                            if erro == nil {
                                print("Sucesso ao carregar a imagem!")
                            } else {
                                print("Erro ao carregar a imagem!")
                            }
                        })
                    } else {
                        print("Erro ao carregar a imagem!")
                    }
                })
            }
        }
    }
    
    @IBAction func alterarImagem(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func deslogar(_ sender: Any) {
        do {
            try self.auth.signOut()
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("Erro ao deslogar")
        }
    }
}
