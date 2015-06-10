//
//  Fonts.swift
//  Badget
//
//  Created by Toon Bertier on 10/06/15.
//  Copyright (c) 2015 Toon Bertier. All rights reserved.
//

import UIKit

class Fonts: NSObject {
   
    class func enumerateFonts(){
        
        for fontFamily in UIFont.familyNames() {
            println("Font family name = \(fontFamily as! String)");
            for fontName in UIFont.fontNamesForFamilyName(fontFamily as! String) {
                println("- Font name = \(fontName)");
            }
            println("\n");
        }
        
    }
    
}
