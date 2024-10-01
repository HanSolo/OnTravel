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
            
            Button("Import") {
                importing = true
            }
            .fileImporter(
                isPresented         : $importing,
                allowedContentTypes : [.json]
            ) { result in
                switch result {
                case .success(let file):
                    let filename : String = file.lastPathComponent
                    if filename.isEmpty { return }
                    
                    let url  : URL    = FileManager.documentsDirectory.appendingPathComponent(filename)
                    var json : String = ""
                    do {
                        json = try String(contentsOf: url)
                        
                        let countries : [Country] = Helper.countriesFromJson(jsonTxt: json)
                        for country in countries {                            
                            self.model.allVisits.insert(country)
                        }
                        WidgetCenter.shared.reloadAllTimelines()
                        dismiss()
                    } catch {
                        Swift.debugPrint("Error reading json file. Error: \(error.localizedDescription)")
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            Spacer()
        }
    }
}
