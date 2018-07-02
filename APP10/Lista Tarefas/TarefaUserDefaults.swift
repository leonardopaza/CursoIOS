//
//  TarefaUserDefaults.swift
//  Lista Tarefas
//
//  Created by Leonardo Paza on 01/07/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import UIKit

class TarefaUserDefaults {
    let chave = "listaTarefas"
    var tarefas: [String] = []
    
    func salvar(tarefa: String) {
        tarefas = listar()
        
        tarefas.append(tarefa)
        UserDefaults.standard.set(tarefas, forKey: chave)
    }
    
    func listar() -> Array<String> {
        let dados = UserDefaults.standard.object(forKey: chave)
        
        if dados != nil {
            return dados as! Array<String>
        } else {
            return []
        }
    }
    
    func remover(indice: Int) {
        tarefas = listar()
        
        tarefas.remove(at: indice)
        UserDefaults.standard.set(tarefas, forKey: chave)
    }
}
