//
//  Jogador.swift
//  CidadeDorme
//
//  Created by Carlos Eduardo Millani on 4/15/15.
//  Copyright (c) 2015 LazyFox. All rights reserved.
//

import UIKit

class Jogador: NSObject {
    
    init( var falas: [String], var imagem: String, var meuNome:String){
        nome = meuNome
        messageSet = falas
        image = imagem
    }
    var nome = ""
    var image = ""
    var messageSet = [""]
    var message: String{
        var a:Int = (Int)(arc4random() >> 1) % messageSet.count
        return (messageSet[a])
    }
    var clone:Jogador
    {
        return Jogador(falas: self.messageSet, imagem: self.image, meuNome: self.nome)
    }
    
}
