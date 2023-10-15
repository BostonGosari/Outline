//
//  Logger.swift
//  Outline
//
//  Created by 김하은 on 10/15/23.
//

import Foundation
import os

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    #if os(watchOS)
    static let shared = Logger(subsystem: subsystem, category: "OutlineWatch")
    #else
    static let shared = Logger(subsystem: subsystem, category: "Outline")
    #endif
}
