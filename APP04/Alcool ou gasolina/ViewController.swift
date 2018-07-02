//
//  ViewController.swift
//  Alcool ou gasolina
//
//  Created by Leonardo Paza on 12/06/18.
//  Copyright © 2018 Curso IOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var resultadoLegenda: UILabel!
    @IBOutlet weak var precoAlcoolCampo: UITextField!
    @IBOutlet weak var precoGasolinaCampo: UITextField!
    
    @IBAction func calcularCombustivel(_ sender: Any) {
        
        if let precoAlcool = precoAlcoolCampo.text {
            if let precoGasolina = precoGasolinaCampo.text {
                
                //Validar valores digitados
                let validaCampos = self.validarCampos(precoAlcool: precoAlcool, precoGasolina: precoGasolina)
                if validaCampos {
                    self.calcularMelhorPreco(precoAlcool: precoAlcool, precoGasolina: precoGasolina)
                } else {
                    resultadoLegenda.text = "Digite os preços para calcular!"
                }
            }
        }
        
    }
    
    func validarCampos(precoAlcool: String, precoGasolina: String) -> Bool {
        var camposValidados = true
        if precoAlcool.isEmpty {
            camposValidados = false
        } else if precoGasolina.isEmpty {
            camposValidados = false
        }
        return camposValidados
    }
    
    func calcularMelhorPreco(precoAlcool: String, precoGasolina: String) {
        if let valorAlcool = Double(precoAlcool) {
            if let valorGasolina = Double(precoGasolina) {
                /*Faz cálculo ( precoAlcool / precoGasolina )
                 * Se resultado >= 0.7 melhor utilizar gasolina
                 * senão melhor utilizar Álcool
                 */
                let resultadoPreco = valorAlcool / valorGasolina
                if resultadoPreco >= 0.7 {
                    self.resultadoLegenda.text = "Melhor utilizar Gasolina!"
                } else {
                    self.resultadoLegenda.text = "Melhor utilizar Álcool!"
                }
            }
        }
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

