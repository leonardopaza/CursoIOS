//: Playground - noun: a place where people can play

import UIKit

//Opcionais
var valor1: Int
var valor2: Int?
var total: Int = 0

valor1 = 10
valor2 = 1

if let valor2Testado = valor2 {
    total = valor1 + valor2Testado
}

print(total)

//Classes e Objetos
class Casa {
    //Atributos
    var cor: String
    
    init(cor: String) {
        self.cor = cor
    }
    
    //Métodos - ações
    func getCor() -> String {
        return self.cor
    }
}

var casa = Casa(cor: "Verde")
casa.getCor()

//Desafio Rápido
class Cachorro {
    var cor: String
    
    init(cor: String) {
        self.cor = cor
    }
    
    func correr() -> String {
        return "correr"
    }
    
    func latir() -> String {
        return "latir"
    }
}

var cachorro = Cachorro(cor: "Preto")
cachorro.correr()
cachorro.latir()

//Herança
class Animal {
    var cor = "marrom"
    
    func dormir() -> String {
        return "dormir"
    }
}

class Cachorro2: Animal {
    func latir() -> String {
        return "latir"
    }
}

class Passaro: Animal {
    func voar() -> String {
        return "voar"
    }
}

class Papagaio: Passaro {
    func repetir() -> String {
        return "repetir"
    }
}

var papagaio = Papagaio()
papagaio.repetir()

var cachorro2 = Cachorro2()
cachorro2.cor
cachorro2.latir()

var passaro = Passaro()
passaro.cor
passaro.dormir()
passaro.voar()
