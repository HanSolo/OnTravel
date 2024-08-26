//
//  Sender.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 26.08.24.
//

import Foundation


class Sender {
    public static let SENDER_EVT : String       = "SENDER_EVT"
    public        let events     : EventManager = EventManager()
    
    
    public func trigger(txt: String) -> Void {
        self.events.trigger(eventName: Sender.SENDER_EVT, information: txt)
    }
}
