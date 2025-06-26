//
//  Caffeinate.swift
//  owl-coffee-native
//
//  Created by Debasish Nandi on 26/06/25.
//


class CaffinationStatus {
    static public var enabled: Bool = false;
    static public var enabledWithDisplay: Bool = false;
    static public var appQuitting: Bool = false;
    
    static public func reset() {
        enabled = false
        enabledWithDisplay = false
    }
    
    static public func setEnabled() {
        enabled = true
        enabledWithDisplay = false
    }
    
    static public func setEnabledWithDisplay() {
        enabled = false
        enabledWithDisplay = true
    }
    
    static public func setAppQuitting() {
        appQuitting = true
    }

}
