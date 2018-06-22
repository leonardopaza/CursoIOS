//
//  ViewController.swift
//  Idade do cachorro
//
//  Created by Leonardo Paza on 21/06/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var campoIdadeCachorro: UITextField!
    @IBOutlet weak var legendaResultado: UILabel!
    @IBAction func descobrirIdade(_ sender: Any) {
        let idade = Int(campoIdadeCachorro.text!)! * 7
        legendaResultado.text = "A idade do cachorro é: " + String(idade)
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

