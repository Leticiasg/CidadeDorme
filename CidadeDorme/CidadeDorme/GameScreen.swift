//
//  GameScreen.swift
//  CidadeDorme
//
//  Created by Carlos Eduardo Millani on 4/15/15.
//  Copyright (c) 2015 LazyFox. All rights reserved.
//

import UIKit
let frasesAssassino = ["Alguém suspeito te observa.", "Um calafrio percorre seu corpo."]
let imagemAssassino = "mafia"

let frasesVitima = ["As pessoas suspeitam de voce.", "Você está amedrontando a cidade."]
let imagemVitima = "cidadao1"

let frasesDetetive = ["O tribunal suspeita de voce.", "Voce esta sendo investigado."]
let imagemDetetive = "detetive"

class GameScreen: NSObject {
    var jogadores: Array<Jogador> = []
    var qtdJogadores = 0
    let assassino = Jogador(falas: frasesAssassino, imagem: imagemAssassino, meuNome: "Assassino")
    let vitima = Jogador(falas: frasesVitima, imagem: imagemVitima, meuNome: "Vitima")
    let detetive = Jogador(falas: frasesDetetive, imagem: imagemDetetive, meuNome: "Vitima")
    init( var numJogadores: Int){
        qtdJogadores = numJogadores
        if (numJogadores < 4) //Numero Invalido de jogaores
        {
            NSLog("Numero inválido de Jogadores")
        }
        else if(numJogadores < 5)
        {
            jogadores = [assassino.clone, detetive.clone, vitima.clone, vitima.clone]
        }
        else
        {
            jogadores = [assassino.clone, detetive.clone, assassino.clone]
            for var i = 3; i < numJogadores; i++
            {
                jogadores.append(vitima.clone)
            }
        }
    }
    func shuffle(){ //distribui as cartas
        return;
    }
}
