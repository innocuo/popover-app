//
//  PopViewController.swift
//  popover-app
//
//  Created by Luis Orozco on 3/30/17.
//  Copyright © 2017 Luis Orozco. All rights reserved.
//

import Cocoa

class PopViewController: NSViewController{
    
    private var delegate:AppDelegate?
    
    override func viewDidAppear() {
        
        super.viewDidAppear()
        
        //Needed so clicks outside the app trigger
        //events to close the popover
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func setDelegate(_ delegate:AppDelegate){
        
        self.delegate = delegate
    }
    
    override func cancelOperation(_ sender: Any?) {
        
        self.delegate!.closePopover(self)
    }
    
    @IBAction func quit(_ sender: NSButton){
        
        NSApplication.shared().terminate(sender)
    }
}
