//
//  CadastroTarefaViewController.swift
//  Lista Tarefas
//
//  Created by Leonardo Paza on 01/07/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import UIKit

class CadastroTarefaViewController: UIViewController {

    @IBOutlet weak var tarefaCampo: UITextField!
    
    @IBAction func adicionarTarefa(_ sender: Any) {
        if let textoDigitado = tarefaCampo.text {
            let tarefa = TarefaUserDefaults()
            tarefa.salvar(tarefa: textoDigitado)
            tarefaCampo.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
