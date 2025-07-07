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
        print("✅ applicationDidFinishLaunching called ...")
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "cloud.moon.circle", accessibilityDescription: "Owl Coffee")
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
        let caffinateMenu = NSMenuItem(title: StringMapping.GetCaffeinateMenuItemTitle(), action: #selector(Caffeinate), keyEquivalent: "c")
        if CaffinationStatus.enabled {
            caffinateMenu.badge = NSMenuItemBadge(string: "Active")
        }
        menu.addItem(caffinateMenu)
        
        let caffienateDisplayMenu = NSMenuItem(title: StringMapping.GetCaffeinateDisplayMenuItemTitle(), action: #selector(CaffeinateWithDisplay), keyEquivalent: "d")
        if CaffinationStatus.enabledWithDisplay {
            caffienateDisplayMenu.badge = NSMenuItemBadge(string: "Active")
        }
        menu.addItem(caffienateDisplayMenu)
        
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
        CaffinationStatus.setAppQuitting()
        createUpdate()
        
        KillAllCaffeinaters()
        sleep(4)
        
        NSApp.terminate(nil)
    }
    
    func KillAllCaffeinaters() {
        for pid in Pid.list {
            _ = RunCommand(commandString: "kill -9 \(pid)")
        }
        
        Pid.list = []
    }
    
    func RunCommand(commandString command: String) -> Int32 {
        let process = Process()

        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = ["-c", command]

        do {
            try process.run()
        } catch {
            print("❌ Failed to run process: \(error)")
            return -1
        }

        if command.localizedStandardContains("kill") {
            process.waitUntilExit()
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
