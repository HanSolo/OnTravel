//
//  ImportJsonView.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 01.10.24.
//

import Foundation
import SwiftUI
import WidgetKit


struct ImportJsonView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject      private var model     : OnTravelModel
    @State                  private var importing : Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.primary)
                }
                .buttonStyle(.bordered)
                Spacer()
                Text("JSON Import")
                Spacer()
            }
            .padding()
            
            Spacer()
            
            Button("Select file to import") {
                importing = true
            }
            .fileImporter(isPresented : $importing,allowedContentTypes : [.json], allowsMultipleSelection : false) { result in
                do {
                    guard let selectedFile: URL = try result.get().first else { return }
                    var json: String = ""
                    if selectedFile.startAccessingSecurityScopedResource() {
                        json = try String(contentsOf: selectedFile, encoding: .utf8)
                        selectedFile.stopAccessingSecurityScopedResource()
                    }
                    if json.isEmpty { return }
                    
                    var allVisits : [Country] = Helper.visitsThisYearFromUserDefaults()
                    let countries : [Country] = Helper.countriesFromJson(jsonTxt: json)
                    for country in countries {
                        if let countryFound = allVisits.filter({ $0.isoInfo.alpha2 == country.isoInfo.alpha2 }).first {
                            for visit in country.visits {
                                _ = countryFound.addVisit(date: visit)
                            }
                        } else {
                            allVisits.append(country)
                        }
                    }
                    let countrySet : Set<Country> = Set(allVisits)
                    DispatchQueue.global().async {
                        Helper.visitsThisYearToUserDefaults(allVisits: countrySet)
                        let jsonTxt : String = Helper.visitsToJson(allVisits: countrySet)
                        Helper.saveJson(json: jsonTxt)
                        debugPrint("Updated visits in user defaults and saved json file in ImportJsonView")
                    }
                    DispatchQueue.main.async {
                        self.model.allVisits = countrySet
                        WidgetCenter.shared.reloadAllTimelines()
                        debugPrint("Updated visits in model from ImportJsonView")
                    }
                    dismiss()
                } catch {
                    debugPrint("Error reading json file. Error: \(error.localizedDescription)")
                }
            }
            Spacer()
        }
    }
}
