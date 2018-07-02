//
//  ViewController.swift
//  Minhas Anotacoes
//
//  Created by Leonardo Paza on 01/07/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textoCampo: UITextView!
    let chave = "minhaAnotacao"
    
    @IBAction func salvarAnotacao(_ sender: Any) {
        if let texto = textoCampo.text {
            UserDefaults.standard.set(texto, forKey: chave)
        }
        view.endEditing(true)
    }
    
    func recuperarAnotacao() -> String {
        if let textoRecuperado = UserDefaults.standard.object(forKey: chave) {
            return textoRecuperado as! String
        }
        return ""
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textoCampo.text = recuperarAnotacao()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

