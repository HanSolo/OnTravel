//
//  SettingsView.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 03.09.24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject      private var model             : OnTravelModel
    @State                  private var selectedIndex     : Int           = Properties.instance.homeCountryIndex!
    @State                  private var ignoreHomeCountry : Bool          = Properties.instance.ignoreHomeCountry!
    
    private let isoCountries      : [IsoCountryInfo] = IsoCountries.allCountries
    private let numberOfCountries : Int              = IsoCountries.allCountries.count
    
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
                Text("Settings")
                Spacer()
            }
            .padding()
        }
        Form {
            Picker(selection: $selectedIndex, label: Text("Home")) {
                ForEach(0 ..< numberOfCountries, id: \.self) { i in
                    HStack {
                        Text("\(self.isoCountries[i].flag ?? "") \(self.isoCountries[i].name)")
                    }
                }
            }
            Toggle(isOn: self.$ignoreHomeCountry, label: {
                Text("Ignore home country")
            })
        }
        .onChange(of: self.selectedIndex) {
            Properties.instance.homeCountryIndex = self.selectedIndex
            self.model.homeCountry = IsoCountries.allCountries[self.selectedIndex]
        }
        .onChange(of: self.ignoreHomeCountry) {
            Properties.instance.ignoreHomeCountry = self.ignoreHomeCountry
            self.model.ignoreHomeCountry = self.ignoreHomeCountry
        }
    }
}

#Preview {
    SettingsView()
}