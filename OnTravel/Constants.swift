//
//  Constants.swift
//  CountryCounter
//
//  Created by Gerrit Grunwald on 20.08.24.
//

import Foundation
import SwiftUI


public class Constants {
    public static let APP_NAME                       : String = "OnTravel"
    public static let APP_GROUP_ID                   : String = "group.eu.hansolo.ontravel"
    public static let PROCESSING_TASK_REQUEST_ID     : String = "eu.hansolo.ontravel.process"
    public static let PROCESSING_TASK_ID             : String = "eu.hansolo.ontravel.processTaskId"
    public static let PROCESSING_SESSION_ID          : String = "eu.hansolo.ontravel.processSessionId"
    public static let PROCESSING_INTERVAL            : Double = 1200 // 20 min interval for background processing
    
    public static let VISITS_THIS_YEAR_KEY_UD        : String = "visitsThisYear"
    public static let VISITS_THIS_MONTH_KEY_UD       : String = "visitsThisMonth"
    
    public static let CURRENCIES_KEY_UD              : String = "currencies"
    public static let OPEN_EXCHANGE_RATE_API_URL     : String = "https://open.er-api.com/v6/latest/"
    public static let FESTIVO_PUBLIC_HOLIDAY_API_URL : String = "https://api.getfestivo.com/public-holidays/v3/list"
    public static let FESTIVO_API_KEY                : String = "tok_v3_JHSFeXCkH7IioSPGGlBSNQMzf7FrCv70YmQ61JCpY02rWixx"
    
    public static let SPEED_LIMIT                    : Double = 300.0
    public static let ALTITUDE_LIMIT                 : Double = 6000.0
    
    public static let VISITED_FILL_DARK              : Color  = Color(red: 255, green: 0, blue: 0)
    public static let VISITED_FILL_BRIGHT            : Color  = Color(red: 200, green: 00, blue: 0)
    public static let NOT_VISITED_FILL_DARK          : Color  = Color(red: 10, green: 10, blue: 10)
    public static let NOT_VISITED_FILL_BRIGHT        : Color  = Color(red: 100, green: 100, blue: 100)
        
    public static let COUNTRY_COLOR_1                : Color  = Color(hex: "003a7d")
    public static let COUNTRY_COLOR_2                : Color  = Color(hex: "008dff")
    public static let COUNTRY_COLOR_3                : Color  = Color(hex: "ff73b6")
    public static let COUNTRY_COLOR_4                : Color  = Color(hex: "c701ff")
    public static let COUNTRY_COLOR_5                : Color  = Color(hex: "4ecb8d")
    public static let COUNTRY_COLOR_6                : Color  = Color(hex: "ff9d3a")
    public static let COUNTRY_COLOR_7                : Color  = Color(hex: "f9e858")
    public static let COUNTRY_COLOR_8                : Color  = Color(hex: "d83034")
    public static let COUNTRY_COLOR_9                : Color  = Color(hex: "8fd7d7")
    public static let COUNTRY_COLOR_10               : Color  = Color(hex: "00b0be")
    public static let COUNTRY_COLOR_11               : Color  = Color(hex: "ff8ca1")
    public static let COUNTRY_COLOR_12               : Color  = Color(hex: "f45f74")
    public static let COUNTRY_COLOR_13               : Color  = Color(hex: "bdd373")
    public static let COUNTRY_COLOR_14               : Color  = Color(hex: "98c127")
    public static let COUNTRY_COLOR_15               : Color  = Color(hex: "ffcd8e")
    public static let COUNTRY_COLOR_16               : Color  = Color(hex: "ffb255")
    public static let COUNTRY_COLOR_17               : Color  = Color(hex: "c8c8c8")
    public static let COUNTRY_COLOR_18               : Color  = Color(hex: "f0c571")
    public static let COUNTRY_COLOR_19               : Color  = Color(hex: "59a89c")
    public static let COUNTRY_COLOR_20               : Color  = Color(hex: "0b81a2")
    public static let COUNTRY_COLOR_21               : Color  = Color(hex: "e25759")
    public static let COUNTRY_COLOR_22               : Color  = Color(hex: "9d2c00")
    public static let COUNTRY_COLOR_23               : Color  = Color(hex: "7e4794")
    public static let COUNTRY_COLOR_24               : Color  = Color(hex: "36b700")
    
    public static let COUNTRY_COLORS                 : [Color] = [
        COUNTRY_COLOR_1, COUNTRY_COLOR_2, COUNTRY_COLOR_3, COUNTRY_COLOR_4, COUNTRY_COLOR_5, COUNTRY_COLOR_6, COUNTRY_COLOR_7, COUNTRY_COLOR_8,
        COUNTRY_COLOR_9, COUNTRY_COLOR_10, COUNTRY_COLOR_11, COUNTRY_COLOR_12, COUNTRY_COLOR_13, COUNTRY_COLOR_14, COUNTRY_COLOR_15, COUNTRY_COLOR_16,
        COUNTRY_COLOR_17, COUNTRY_COLOR_18, COUNTRY_COLOR_19, COUNTRY_COLOR_20, COUNTRY_COLOR_21, COUNTRY_COLOR_22, COUNTRY_COLOR_23
    ]
    
    public static let SECONDS_24H                    : Double = 86_400
    public static let SECONDS_48H                    : Double = 172_800
    
    public static let METRIC_TIME_FORMAT             : String = "HH:mm"
    public static let IMPERIAL_TIME_FORMAT           : String = "h:mm a"
    public static let METRIC_DATE_FORMAT             : String = "dd.MM.yyyy"
    public static let IMPERIAL_DATE_FORMAT           : String = "MM/dd/yyyy"
    public static let METRIC_DATE_TIME_FORMAT        : String = "dd.MM.yyyy HH:mm"
    public static let IMPERIAL_DATE_TIME_FORMAT      : String = "MM/dd/yyyy h:mm a"
    public static let PUBLIC_HOLIDAY_DATE_FORMAT     : String = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    public static let EPD_SUN                        : String = "sun"
    public static let EPD_MOON                       : String = "moon"
    public static let EPD_BLUE_HOUR_MORNING          : String = "blueHourMorning"
    public static let EPD_GOLDEN_HOUR_MORNING        : String = "goldenHourMorning"
    public static let EPD_SUNRISE                    : String = "sunrise"
    public static let EPD_GOLDEN_HOUR_EVENING        : String = "goldenHourEvening"
    public static let EPD_SUNSET                     : String = "sunset"
    public static let EPD_BLUE_HOUR_EVENING          : String = "blueHourEvening"
    public static let EPD_MOONRISE                   : String = "moonrise"
    public static let EPD_MOONSET                    : String = "moonset"
    public static let EPD_GOLDEN_HOUR_END            : String = "goldenHourEnd"
    public static let EPD_GOLDEN_HOUR                : String = "goldenHour"
    public static let EPD_SUNRISE_END                : String = "sunriseEnd"
    public static let EPD_SUNSET_START               : String = "sunsetStart"
    public static let EPD_BLUE_HOUR_DAWN_END         : String = "blueHourDawnEnd"
    public static let EPD_BLUE_HOUR_DUSK             : String = "blueHourDusk"
    public static let EPD_DAWN                       : String = "dawn"
    public static let EPD_DUSK                       : String = "dusk"
    public static let EPD_BLUE_HOUR_DAWN             : String = "blueHourDawn"
    public static let EPD_BLUE_HOUR_DUSK_END         : String = "blueHourDuskEnd"
    public static let EPD_NAUTICAL_DAWN              : String = "nauticalDawn"
    public static let EPD_NAUTICAL_DUSK              : String = "nauticalDusk"
    public static let EPD_NIGHT_END                  : String = "nightEnd"
    public static let EPD_NIGHT                      : String = "night"
    public static let EPD_RISE                       : String = "rise"
    public static let EPD_SET                        : String = "set"
    public static let EPD_AZIMUTH                    : String = "azimuth"
    public static let EPD_ALTITUDE                   : String = "altitude"
    public static let EPD_ALWAYS_UP                  : String = "alwaysUp"
    public static let EPD_ALWAYS_DOWN                : String = "alwaysDown"
    public static let EPD_SOLAR_NOON                 : String = "solarNoon"
    public static let EPD_NADIR                      : String = "nadir"
    public static let EPD_DEC                        : String = "dec"
    public static let EPD_RA                         : String = "ra"
    public static let EPD_DIST                       : String = "dist"
    public static let EPD_DISTANCE                   : String = "distance"
    public static let EPD_FRACTION                   : String = "fraction"
    public static let EPD_PHASE                      : String = "phase"
    public static let EPD_ANGLE                      : String = "angle"
    public static let EPD_PARALLACTIC_ANGLE          : String = "parallacticAngle"
}
