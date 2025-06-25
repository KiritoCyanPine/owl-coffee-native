//
//  AppDelegate.swift
//  owl-coffee-native
//
//  Created by Debasish Nandi on 26/06/25.
//

import Cocoa
import Foundation

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        print("applicationDidFinishLaunching called ")
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "cloud.moon.bolt.circle.fill", accessibilityDescription: "Owl Coffee")
            button.image?.isTemplate = true // Adapts to dark/light mode
        }
        createUpdate()
    }
    
    func createUpdate() {
        statusItem.button?.image = NSImage(systemSymbolName: StringMapping.GetTrayIconSymbolName(), accessibilityDescription: "Owl Coffee")
        statusItem.button?.image?.isTemplate = true
        
        statusItem.menu = GetMenuList()
    }
    
    func GetMenuList() -> NSMenu {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: StringMapping.GetCaffeinateMenuItemTitle(), action: #selector(Caffeinate), keyEquivalent: "c"))
        menu.addItem(NSMenuItem(title: StringMapping.GetCaffeinateDisplayMenuItemTitle(), action: #selector(CaffeinateWithDisplay), keyEquivalent: "d"))
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "💤 deCaffienate", action: #selector(DeCaffeinate), keyEquivalent: "a"))
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))
        
        return menu
    }

    @objc func Caffeinate() {
        print("Caffeinating device...")
        KillAllCaffeinaters()
        let pid = RunCommand(commandString: "caffeinate")
        
        Pid.list.append(pid)
        
        CaffinationStatus.setEnabled()
        createUpdate()
    }
    
    @objc func CaffeinateWithDisplay() {
        print("Caffeinating device screen...")
        KillAllCaffeinaters()
        
        let pid = RunCommand(commandString: "caffeinate -d")
        
        Pid.list.append(pid)
        CaffinationStatus.setEnabledWithDisplay()
        createUpdate()
    }
    
    @objc func DeCaffeinate() {
        print("having deCaf...")
        KillAllCaffeinaters()
        CaffinationStatus.reset()
        createUpdate()
    }

    @objc func quitApp() {
        KillAllCaffeinaters()
        sleep(1)
        NSApp.terminate(nil)
    }
    
    func KillAllCaffeinaters() {
        for pid in Pid.list {
            let result = kill(pid, SIGTERM)
            
            if result == 0 {
                print("✅ Process \(pid) terminated successfully")
            } else {
                let errnoMessage = String(cString: strerror(errno))
                print("❌ Failed to kill process \(pid): \(errnoMessage)")
            }
        }
        
        Pid.list = []
    }
    
    func RunCommand(commandString command: String) -> Int32 {
        let process = Process()
        let pipe = Pipe()

        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = ["-c", command]
        process.standardOutput = pipe
        process.standardError = pipe

        do {
            try process.run()
        } catch {
            print("❌ Failed to run process: \(error)")
            return -1
        }
        
        return process.processIdentifier
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
