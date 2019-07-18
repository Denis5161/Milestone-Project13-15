//
//  Country.swift
//  Milestone-Project13-15
//
//  Created by Denis Goldberg on 18.07.19.
//  Copyright © 2019 Denis Goldberg. All rights reserved.
//

import Foundation

struct Country: Codable {
    var flag: String
    var name: String
    var area: Float?
    var capital: String
    var population: Int
    var currencies: [Currency]
    var languages: [Language]
}
