//
//  EventManager.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 26.08.24.
//

import Foundation


public class EventManager {
    var listeners = Dictionary<String, NSMutableArray>();
    
    
    func listenTo(eventName:String, action: @escaping (()->())) {
        let newListener = EventListenerAction(callback: action);
        addListener(eventName: eventName, newEventListener: newListener);
    }
    
    func listenTo(eventName:String, action: @escaping ((Any?)->())) {
        let newListener : EventListenerAction = EventListenerAction(callback: action);
        addListener(eventName: eventName, newEventListener: newListener);
    }
    
    internal func addListener(eventName:String, newEventListener:EventListenerAction) {
        if let listenerArray = self.listeners[eventName] {
            listenerArray.add(newEventListener);
        } else {
            self.listeners[eventName] = [newEventListener] as NSMutableArray;
        }
    }
        
    func removeListeners(eventNameToRemoveOrNil:String?) {
        if let eventNameToRemove = eventNameToRemoveOrNil {
            if let actionArray = self.listeners[eventNameToRemove] {
                actionArray.removeAllObjects();
            }
        } else {
            self.listeners.removeAll(keepingCapacity: false);
        }
    }
        
    func trigger(eventName:String, information:Any? = nil) {
        if let actionObjects = self.listeners[eventName] {
            for actionObject in actionObjects {
                if let actionToPerform = actionObject as? EventListenerAction {
                    if let methodToCall = actionToPerform.actionExpectsInfo {
                        methodToCall(information);
                    } else if let methodToCall = actionToPerform.action {
                        methodToCall();
                    }
                }
            }
        }
    }
}
