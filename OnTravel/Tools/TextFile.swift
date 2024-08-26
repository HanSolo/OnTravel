//
//  TextFile.swift
//  OnTravel
//
//  Created by Gerrit Grunwald on 26.08.24.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers


struct TextFile: FileDocument {
    static var readableContentTypes = [UTType.plainText]
    var text : String               = ""
    var year : Int
    
    
    init(initialText: String = "", year: Int = Calendar.current.component(.year, from: Date.init())) {
        self.text = initialText
        self.year = year
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data : Data = configuration.file.regularFileContents {
            self.text = String(decoding: data, as: UTF8.self)
        }
        self.year = Calendar.current.component(.year, from: Date.init())
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data       : Data        = Data(text.utf8)
        let fileWrapper: FileWrapper = FileWrapper(regularFileWithContents: data)
        fileWrapper.filename = "visits\(self.year).csv"
        return fileWrapper
    }
}
