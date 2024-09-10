//
//  RestController.swift
//  CountryCounter
//
//  Created by Gerrit Grunwald on 20.08.24.
//

import Foundation
import Network
import SwiftUI


class RestController {

    public static func isConnected() async -> Bool {
        let sessionConfig : URLSessionConfiguration = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest  = 2.0
        sessionConfig.timeoutIntervalForResource = 2.0
        
        let urlString : String      = "https://apple.com"
        let session   : URLSession  = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: .main)
        let finalUrl  : URL         = URL(string: urlString)!
        var request   : URLRequest  = URLRequest(url: finalUrl)
        request.httpMethod = "HEAD"
        do {
            let resp : (Data,URLResponse) = try await session.data(for: request)
            
            if let httpResponse = resp.1 as? HTTPURLResponse {
                return httpResponse.statusCode == 200
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    public static func getCurrencies() async -> [String:Double] {
        let sessionConfig : URLSessionConfiguration = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest  = 2.0
        sessionConfig.timeoutIntervalForResource = 2.0
        
        let homeCountry : IsoCountryInfo = IsoCountries.allCountries[Properties.instance.homeCountryIndex!]
        let urlString   : String         = "\(Constants.OPEN_EXCHANGE_RATE_API_URL)\(homeCountry.currency)"
        let session     : URLSession     = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: .main)
        let finalUrl    : URL            = URL(string: urlString)!
        var request     : URLRequest     = URLRequest(url: finalUrl)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        do {
            let resp: (Data,URLResponse) = try await session.data(for: request)
            
            if let httpResponse = resp.1 as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    let data        : Data        = resp.0
                    let jsonDecoder : JSONDecoder = JSONDecoder()
                    if let exchangeRateData : ExchangeRateData = try? jsonDecoder.decode(ExchangeRateData.self, from: data) {
                        if exchangeRateData.rates == nil {
                            debugPrint("exchangeRateData.rates == nil")
                            return [:]
                        } else {
                            Properties.instance.lastCurrencyUpdate = Date.init().timeIntervalSince1970
                            return exchangeRateData.rates!.getAll()
                        }
                    } else {
                        print("something went wrong when decoding the data")
                    }
                    return [:]
                } else {
                    debugPrint("http response status code != 200")
                    return [:]
                }
            } else {
                debugPrint("No valid http response")
                return [:]
            }
        } catch {
            debugPrint("Error calling OpenExchangeRateAPI. Error: \(error.localizedDescription)")
            return [:]
        }
    }
}
