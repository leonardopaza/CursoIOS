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
        frases.append("Ah eu cansei de estudar, mas quem ta começando é bom estudar bastante!")
        frases.append("Tu é um pau no cu djow!")
        frases.append("Pra sair tomar uma gelada com os parsa, não dá!")
        
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

