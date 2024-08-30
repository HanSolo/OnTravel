//
//  FileManager+documentsDirectory.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 30.08.24.
//

import Foundation


extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first!
    }    
}
