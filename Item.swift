//
//  Item.swift
//  GeminiChatTemplate
//
//  Created by Jesus Daniel Medina Cruz on 30/06/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}