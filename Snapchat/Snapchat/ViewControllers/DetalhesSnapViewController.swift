//
//  DetalhesSnapViewController.swift
//  Snapchat
//
//  Created by Leonardo Paza on 21/07/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class DetalhesSnapViewController: UIViewController {

    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var detalhes: UILabel!
    @IBOutlet weak var contador: UILabel!
    var snap = Snap()
    var tempo = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detalhes.text = "Carregando..."
        
        let url = URL(string: snap.urlImagem)
        imagem.sd_setImage(with: url) { (imagem, erro, cache, url) in
            if erro == nil {
                
                let descricaoTexto = self.snap.descricao
                if descricaoTexto != "" {
                    self.detalhes.text = descricaoTexto
                } else {
                    self.detalhes.text = "Sem descrição!"
                }
                
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                    self.tempo = self.tempo - 1
                    self.contador.text = String(self.tempo)
                    
                    if self.tempo == 0 {
                        timer.invalidate()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let autenticacao = Auth.auth()
        
        if let idUsuarioLogado = autenticacao.currentUser?.uid {
            let database = Database.database().reference()
            let usuarios = database.child("usuarios")
            let snaps = usuarios.child(idUsuarioLogado).child("snaps")
            
            snaps.child(snap.identificador).removeValue()
            
            let storage = Storage.storage().reference()
            let imagens = storage.child("imagens")
            
            imagens.child("\(snap.idImagem).jpg").delete { (erro) in
                if erro == nil {
                    print("Sucesso ao excluir a imagem")
                } else {
                    print("Erro ao excluir a imagem")
                }
            }
        }
    }
}
