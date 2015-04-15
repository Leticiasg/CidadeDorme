//
//  Assassino.swift
//  CidadeDorme
//
//  Created by Carlos Eduardo Millani on 4/15/15.
//  Copyright (c) 2015 LazyFox. All rights reserved.
//

import UIKit

class Assassino {
    init(){
    }
    var imagem = "mafia"
    var messageSet = ["Alguém suspeito te observa.","Você sente algo suspeito ao seu redor."]
    var message: String{
        var a:Int = (Int)(arc4random() >> 1) % messageSet.count
        return (messageSet[a])
    }
}
