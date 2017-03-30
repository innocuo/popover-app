//
//  AppDelegate.swift
//  popover-app
//
//  Created by Luis Orozco on 3/30/17.
//  Copyright © 2017 Luis Orozco. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    let popover = NSPopover()
    let menu = NSMenu()
    
    private var button:NSStatusBarButton?
    
    var eventMonitor: EventMonitor!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        //MENU BAR
        self.button = statusItem.button!
        if ((self.button) != nil) {
            let img = NSImage(named: "StatusBarButtonImage")
            img?.isTemplate = true
            
            self.button?.target = self
            self.button?.image = img
            
            self.button?.toolTip="Sample Popover App"
            
            //track left and right clicks, each shows a different thing
            self.button?.action = #selector(AppDelegate.handleAction(_:))
            self.button?.sendAction(on: NSEventMask(rawValue: UInt64(Int((NSEventMask.rightMouseDown.rawValue | NSEventMask.rightMouseUp.rawValue)))))
        }
        
        
        //EVENTS
        
        eventMonitor = EventMonitor(mask: [.rightMouseUp , .leftMouseUp]) { [unowned self] event in
            print("event monitor event happened")
            if self.popover.isShown{
                self.closePopover(event)
            }
        }
        
        //POPOVER VIEW
        
        let popView:PopViewController = PopViewController(nibName: "PopViewController", bundle: nil)!
        popView.setDelegate(self)
        
        popover.contentViewController = popView
        popover.animates = true
        
        //MENU
        
        menu.addItem(NSMenuItem(title: "Menu one", action: #selector(AppDelegate.nothingMenu(_:)), keyEquivalent: "1"))
        menu.addItem(NSMenuItem(title: "Menu two", action: #selector(AppDelegate.nothingMenu(_:)), keyEquivalent: "2"))
        menu.addItem(NSMenuItem(title: "Menu three", action: #selector(AppDelegate.nothingMenu(_:)), keyEquivalent: "3"))
        menu.addItem(NSMenuItem(title: "Menu four", action: #selector(AppDelegate.nothingMenu(_:)), keyEquivalent: "4"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(AppDelegate.quitApp(_:)), keyEquivalent: "q"))

    }
    
    //we should start event monitor only when the app is active,
    //otherwise it's always listening. Creepy af! :)
    func applicationWillBecomeActive(_ notification: Notification) {
        eventMonitor.start()
    }
    
    //this is needed when users ctrl+tab
    func applicationWillResignActive(_ notification: Notification) {
        self.statusItem.button?.highlight(false)
        if self.popover.isShown{
            self.closePopover( self )
        }
        eventMonitor.stop()
    }
    
    func nothingMenu(_ sender:AnyObject){
        
        print("A menu item was clicked")
        
        statusItem.button?.highlight(false)
        statusItem.menu = nil
    }
    
    func quitApp(_ sender:AnyObject?){
        NSApplication.shared().terminate(self)
    }

    
    func handleAction(_ sender:AnyObject){
        
        let event:NSEvent! = NSApp.currentEvent!
        
        //mouse up instead of down
        //otherwise when you click on a menu, then you have to click twice to make
        //the app react
        if(event.type == .rightMouseUp){
            closePopover(sender, false)
            statusItem.popUpMenu(menu)
        }
    }
    
    
    //MARK: Popover display
    
    func showPopover(_ sender:AnyObject?){
        
        if let button = statusItem.button{
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            statusItem.button?.highlight(true)
        }
    }
    
    
    func closePopover(_ sender:AnyObject?, _ deactivate_button:Bool = true){
        
        popover.performClose(sender)
        if deactivate_button {
            self.statusItem.button?.highlight(false)
        }
    }
    
    
    func togglePopover(_ sender:AnyObject?){
        
        if popover.isShown{
            closePopover(sender)
        }else{
            showPopover(sender)
        }
    }
}


extension NSStatusBarButton {
    
    open override func mouseDown( with event: NSEvent) {
        
        //if (event.modifierFlags.contains(NSControlKeyMask)) {
        //   self.rightMouseDown(event)
        //return
        //}
        self.highlight(true)
        (self.target as? AppDelegate)?.togglePopover(self)
    }
}
