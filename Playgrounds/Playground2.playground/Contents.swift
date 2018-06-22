//: Playground - noun: a place where people can play

import UIKit

/*
 Operadores Aritméticos
 somar (+)
 subtrair (-)
 multiplicar (*)
 dividir (/)
 */
var numero1: Int
var numero2: Int
var total: Int
numero1 = 10
numero2 = 5
total = numero1 - numero2

/*
 Relacionais
 == (Igual a)
 != (Diferente)
 > (Maior que)
 < (Menor que)
 >= (Maior ou Igual)
 <= (Menor ou Igual)
 
 Lógicos
 && (e)
 || (ou)
 */

var numer1: Int
var numer2: Int
numer1 = 10
numer2 = 10

numer1 <= numer2
var precoCarro: Int
precoCarro = 200
precoCarro > 50 || precoCarro < 150

//Desafio rápido
var idade: Int
idade = 34
idade >= 18 && idade <= 26

//Estruturas condicionais (if else)
var preco: Int
var resultado: String
preco = 350

resultado = "Nenhuma categoria"
if preco >= 100 && preco <= 200 {
    resultado = "Carros populares"
} else if preco >= 200 && preco <= 300 {
    resultado = "Carros médios"
} else if preco >= 300 && preco <= 400 {
    resultado = "Carros luxo"
}

print(resultado)

//Desafio rápido
var idade2: Int
var permissao: String

idade2 = 22
permissao = ""

if idade2 >= 18 {
    permissao = "Maior de idade, pode acessar o app"
} else {
    permissao = "Menor de idade, acesso negado"
}
print(permissao)

//Loops - for
for var i in 0..<5 {
    print(i)
}

var comentarios: [String] = []
comentarios.append("Gostei da foto...muito legal!!")
comentarios.append("Ficou muito bonita nessa foto...")
comentarios.append("Que legal sua viagem...")
for var comentario in comentarios {
    print(comentario)
}

//Loops - While
var contador: Int = 0

while contador < 6 {
    
    print(contador)
    contador += 1
}

repeat {
    print(contador)
    contador += 1
} while contador < 6

//Funções
func multiplicar( numero1: Int, numero2: Int ) -> Int {
    return numero1 + numero2
}

var numero: Int = multiplicar(numero1: 2,numero2: 3)
numero = numero + 2
print(numero)

//Desafio rápido
func calculaIdade( ano: Int ) -> Int {
    return 2018 - ano
}

var idadeRetorno: Int = calculaIdade(ano: 1994)
print("A idade:" + String(idadeRetorno))
