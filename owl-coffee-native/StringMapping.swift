//
//  Menu.swift
//  owl-coffee-native
//
//  Created by Debasish Nandi on 26/06/25.
//
import Cocoa

class StringMapping: NSObject,NSApplicationDelegate {
    
    static public func GetCaffeinateMenuItemTitle() -> String{
        if !CaffinationStatus.enabled{
            return "Caffienate"
        }
        
        return "Caffienate 🍃"
    }
    
    static public func GetCaffeinateDisplayMenuItemTitle() -> String{
        if !CaffinationStatus.enabledWithDisplay{
            return "Caffienate with Display"
        }
        
        return "Caffienate with Display 🍃"
    }
    
    static public func GetTrayIconSymbolName() -> String{
        if CaffinationStatus.appQuitting{
            return "cup.and.saucer"
        }
        
        if !CaffinationStatus.enabled && !CaffinationStatus.enabledWithDisplay{
            return "cloud.moon.circle"
        }
        
        return "cup.and.saucer.fill"
    }
}

