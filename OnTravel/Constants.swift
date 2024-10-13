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
    public static let PROCESSING_INTERVAL        : Double = 1200 // 20 min interval for background processing
    
    public static let VISITS_THIS_YEAR_KEY_UD    : String = "visitsThisYear"
    public static let VISITS_THIS_MONTH_KEY_UD   : String = "visitsThisMonth"
    
    public static let CURRENCIES_KEY_UD          : String = "currencies"
    public static let OPEN_EXCHANGE_RATE_API_URL : String = "https://open.er-api.com/v6/latest/"    
    
    public static let SPEED_LIMIT                : Double = 300.0
    public static let ALTITUDE_LIMIT             : Double = 6000.0
    
    public static let VISITED_FILL_DARK          : Color  = Color(red: 255, green: 0, blue: 0)    
    public static let VISITED_FILL_BRIGHT        : Color  = Color(red: 200, green: 00, blue: 0)
    public static let NOT_VISITED_FILL_DARK      : Color  = Color(red: 10, green: 10, blue: 10)
    public static let NOT_VISITED_FILL_BRIGHT    : Color  = Color(red: 100, green: 100, blue: 100)    
    
    public static let SECONDS_24H                : Double = 86_400
    public static let SECONDS_48H                : Double = 172_800
    
    public static let METRIC_TIME_FORMAT         : String = "HH:mm"
    public static let IMPERIAL_TIME_FORMAT       : String = "h:mm a"
    public static let METRIC_DATE_FORMAT         : String = "dd.MM.yyyy"
    public static let IMPERIAL_DATE_FORMAT       : String = "MM/dd/yyyy"
    public static let METRIC_DATE_TIME_FORMAT    : String = "dd.MM.yyyy HH:mm"
    public static let IMPERIAL_DATE_TIME_FORMAT  : String = "MM/dd/yyyy h:mm a"
    
    public static let EPD_SUN                    : String = "sun"
    public static let EPD_MOON                   : String = "moon"
    public static let EPD_BLUE_HOUR_MORNING      : String = "blueHourMorning"
    public static let EPD_GOLDEN_HOUR_MORNING    : String = "goldenHourMorning"
    public static let EPD_SUNRISE                : String = "sunrise"
    public static let EPD_GOLDEN_HOUR_EVENING    : String = "goldenHourEvening"
    public static let EPD_SUNSET                 : String = "sunset"
    public static let EPD_BLUE_HOUR_EVENING      : String = "blueHourEvening"
    public static let EPD_MOONRISE               : String = "moonrise"
    public static let EPD_MOONSET                : String = "moonset"
    public static let EPD_GOLDEN_HOUR_END        : String = "goldenHourEnd"
    public static let EPD_GOLDEN_HOUR            : String = "goldenHour"
    public static let EPD_SUNRISE_END            : String = "sunriseEnd"
    public static let EPD_SUNSET_START           : String = "sunsetStart"
    public static let EPD_BLUE_HOUR_DAWN_END     : String = "blueHourDawnEnd"
    public static let EPD_BLUE_HOUR_DUSK         : String = "blueHourDusk"
    public static let EPD_DAWN                   : String = "dawn"
    public static let EPD_DUSK                   : String = "dusk"
    public static let EPD_BLUE_HOUR_DAWN         : String = "blueHourDawn"
    public static let EPD_BLUE_HOUR_DUSK_END     : String = "blueHourDuskEnd"
    public static let EPD_NAUTICAL_DAWN          : String = "nauticalDawn"
    public static let EPD_NAUTICAL_DUSK          : String = "nauticalDusk"
    public static let EPD_NIGHT_END              : String = "nightEnd"
    public static let EPD_NIGHT                  : String = "night"
    public static let EPD_RISE                   : String = "rise"
    public static let EPD_SET                    : String = "set"
    public static let EPD_AZIMUTH                : String = "azimuth"
    public static let EPD_ALTITUDE               : String = "altitude"
    public static let EPD_ALWAYS_UP              : String = "alwaysUp"
    public static let EPD_ALWAYS_DOWN            : String = "alwaysDown"
    public static let EPD_SOLAR_NOON             : String = "solarNoon"
    public static let EPD_NADIR                  : String = "nadir"
    public static let EPD_DEC                    : String = "dec"
    public static let EPD_RA                     : String = "ra"
    public static let EPD_DIST                   : String = "dist"
    public static let EPD_DISTANCE               : String = "distance"
    public static let EPD_FRACTION               : String = "fraction"
    public static let EPD_PHASE                  : String = "phase"
    public static let EPD_ANGLE                  : String = "angle"
    public static let EPD_PARALLACTIC_ANGLE      : String = "parallacticAngle"
}
