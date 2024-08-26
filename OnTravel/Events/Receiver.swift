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
            print("Received evt from sender")
        })
        
        sender.events.listenTo(eventName: Sender.SENDER_EVT, action: self.doSomething)
        
        sender.events.listenTo(eventName: Sender.SENDER_EVT, action: self.doSomethingElse)
    }
                
    
    func doSomething() -> Void {
        print("do something because of evt from sender")
    }
    
    func doSomethingElse(information: Any?) {
        if let info = information as? String {
            print("Info from sender evt: \(info)")
        }
    }
}
