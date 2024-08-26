//
//  AppIconProvider.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 26.08.24.
//

import Foundation


enum AppIconProvider {
    static func appIcon(in bundle: Bundle = .main) -> String {
        guard let icons = bundle.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
              let primaryIcon  = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles    = primaryIcon["CFBundleIconFiles"] as? [String],
              let iconFileName = iconFiles.last else {
            fatalError("Could not find icons in bundle")
        }
        return iconFileName
    }
}
