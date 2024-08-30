//
//  Receiver.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 26.08.24.
//

import Foundation


class Receiver {
    
    func attachToSender(sender: Sender) -> Void {
        
        sender.events.listenTo(eventName: Sender.SENDER_EVT, action: {
            //Swift.debugPrint("Received evt from sender")
        })
        
        sender.events.listenTo(eventName: Sender.SENDER_EVT, action: self.doSomething)
        
        sender.events.listenTo(eventName: Sender.SENDER_EVT, action: self.doSomethingElse)
    }
                
    
    func doSomething() -> Void {
        //Swift.debugPrint("do something because of evt from sender")
    }
    
    func doSomethingElse(information: Any?) {
        if let info = information as? String {
            Swift.debugPrint("Info from sender evt: \(info)")
        }
    }
}
