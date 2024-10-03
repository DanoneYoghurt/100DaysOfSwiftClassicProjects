//
//  Model.swift
//  milestone7
//
//  Created by Антон Баскаков on 02.10.2024.
//

import Foundation


struct Note: Codable, Identifiable {
    var id = UUID()
    var title: String
    var text: String
}
