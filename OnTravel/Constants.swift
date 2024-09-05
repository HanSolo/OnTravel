//
//  Constants.swift
//  CountryCounter
//
//  Created by Gerrit Grunwald on 20.08.24.
//

import Foundation
import SwiftUI


public class Constants {
    public static let APP_NAME                   : String = "OnTravel"
    public static let APP_GROUP_ID               : String = "group.eu.hansolo.ontravel"
    public static let PROCESSING_TASK_REQUEST_ID : String = "eu.hansolo.ontravel.process"
    public static let PROCESSING_TASK_ID         : String = "eu.hansolo.ontravel.processTaskId"
    public static let PROCESSING_SESSION_ID      : String = "eu.hansolo.ontravel.processSessionId"
    public static let PROCESSING_INTERVAL        : Double = 1800 // 30min
    
    public static let VISITS_THIS_MONTH_KEY_UD   : String = "visitsThisMonth"
    
    public static let SPEED_LIMIT                : Double = 300.0
    public static let ALTITUDE_LIMIT             : Double = 6000.0
    
    public static let VISITED_FILL_DARK          : Color  = Color(red: 255, green: 0, blue: 0)    
    public static let VISITED_FILL_BRIGHT        : Color  = Color(red: 200, green: 00, blue: 0)
    public static let NOT_VISITED_FILL_DARK      : Color  = Color(red: 10, green: 10, blue: 10)
    public static let NOT_VISITED_FILL_BRIGHT    : Color  = Color(red: 100, green: 100, blue: 100)    
}
