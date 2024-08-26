//
//  EventListenerAction.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 26.08.24.
//

import Foundation


public class EventListenerAction {
    let action : (() -> ())?
    let actionExpectsInfo : ((Any?) -> ())?
    
    
    init(callback: @escaping (() -> ()) ) {
        self.action            = callback
        self.actionExpectsInfo = nil
    }
    
    init(callback: @escaping ((Any?) -> ()) ) {
        self.actionExpectsInfo = callback
        self.action            = nil
    }
}
