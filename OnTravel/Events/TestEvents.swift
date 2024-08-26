//
//  TestEvents.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 26.08.24.
//

import Foundation


public class TestEvents {
    let sender   : Sender   = Sender()
    let receiver : Receiver = Receiver()
    
    
    init() {
        receiver.attachToSender(sender: sender)
        
        sender.trigger(txt: "Here you go")
    }
}
