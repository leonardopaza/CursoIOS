//
//  ContatosViewController.swift
//  WhatsApp
//
//  Created by Leonardo Paza on 31/07/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class ContatosViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableViewContatos: UITableView!
    var usuarios: [Usuario] = []
    
    var armazenamento: StorageReference!
    var database: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.armazenamento = Storage.storage().reference()
        self.database = Database.database().reference()
        
        tableViewContatos.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.usuarios = []
        self.recuperarUsuarios()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celulaContatos", for: indexPath) as! ContatoTableViewCell
        
        let usuarioRecuperado = self.usuarios[indexPath.row]
        celula.nomeLabel.text = usuarioRecuperado.nome
        celula.emailLabel.text = usuarioRecuperado.email
        celula.fotoImageView.image = #imageLiteral(resourceName: "padrao")
        
        let imagensPerfil = self.armazenamento.child("imagens")
        if let nomeImagem = usuarioRecuperado.foto {
            let localImagem = imagensPerfil.child("perfil").child(nomeImagem)
            localImagem.getMetadata { (metaData, erro) in
                if erro == nil {
                    let url = metaData?.downloadURL()?.absoluteURL
                    celula.fotoImageView.sd_setImage(with: url, completed: { (image, erro, cache, url) in
                        if erro != nil {
                            print("Erro ao carregar imagem!")
                        }
                    })
                } else {
                    print("Erro ao recuperar imagem!")
                }
            }
        }
        
        return celula
    }
    
    func recuperarUsuarios() {
        let usuariosDB = self.database.child("usuarios")
        usuariosDB.queryOrdered(byChild: "nome").observe(.childAdded) { (snapshot) in
            let dados = snapshot.value as? NSDictionary
            let nome = dados!["nome"] as! String
            let email = dados!["email"] as! String
            
            let usuarioContato = Usuario(nome: nome, email: email)
            if snapshot.hasChild("foto") {
                let foto = dados!["foto"] as! String
                usuarioContato.foto = foto
            }
            
            let emailUsuarioLogado = FirebaseUtil().recuperarEmailUsuarioLogado()
            
            if emailUsuarioLogado != email {
                self.usuarios.append(usuarioContato)
                self.tableViewContatos.reloadData()
            }
        }
    }
}
