//
//  Jogador.swift
//  CidadeDorme
//
//  Created by Carlos Eduardo Millani on 4/15/15.
//  Copyright (c) 2015 LazyFox. All rights reserved.
//

import UIKit

class Jogador: NSObject {
    init( var a: [String], var b: String){
        messageSet = a
        image = b
    }
    var image = ""
    var messageSet = [""]
    var message: String{
        var a:Int = (Int)(arc4random() >> 1) % messageSet.count
        return (messageSet[a])
    }
}
