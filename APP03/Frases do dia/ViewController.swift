//
//  ViewController.swift
//  Frases do dia
//
//  Created by Leonardo Paza on 09/06/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var legendaResultado: UILabel!
    
    @IBAction func novaFrase(_ sender: Any) {
        
        var frases: [String] = []
        frases.append("A vida é um constante recomeço. Não se dê por derrotado e siga adiante. As pedras que hoje atrapalham sua caminhada amanhã enfeitarão a sua estrada!")
        frases.append("Não tenha medo da mudança. Coisas boas se vão para que melhores possam vir!")
        frases.append("No fim tudo dá certo, e se não deu certo é porque ainda não chegou ao fim!")
        
        legendaResultado.text = frases[Int(arc4random_uniform(3))]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

