//: Playground - noun: a place where people can play

import UIKit

var numero1: Int
var numero2: Int
var total: Int

numero1 = 10
numero2 = 30
total = numero1 + numero2
print("O valor total é " + String(total))

//Arrays
var nomes = ["Jamilton", "Leticia", "Mariana"]

print(nomes[0])

var nomesString: [String]
var numeros: [Int] = []

numeros.append(20)
numeros.append(400)

print(numeros[1])

nomesString = ["Jamilton"]
nomesString += ["Leticia"]
nomesString.append("Mariana")
nomesString.remove(at: 0)

print(nomesString)

//Desafio
var frases: [String] = []
frases.append("Olha a onda, Olha a onda!")
frases.append("E Ae Cara!")
frases.append("Dia Lindo!")
print(frases[2])

//SETS
var lista = Set<String>()
lista.insert("Android")
lista.insert("IOS")
lista.insert("IOS")
print(lista)

//DICIONÁRIOS
var animais = [String: String]()
animais["urso"] = "Animal branco que hiberna"
animais["cachorro"] = "Melhor amigo do homem"
print(animais["cachorro"]!)

//desafio rápido
var meses = [Int: String]()
meses[1] = "Janeiro"
meses[2] = "Fevereiro"
meses[3] = "Março"
meses[4] = "Abril"
meses[5] = "Maio"
meses[6] = "Junho"
meses[7] = "Julho"
meses[8] = "Agosto"
meses[9] = "Setembro"
meses[10] = "Outubro"
meses[11] = "Novembro"
meses[12] = "Dezembro"
print(meses[2]!)
