//
//  CountryModel.swift
//  GuessTheFlag
//
//  Created by Tako Menteshashvili on 25.11.22.
//

import Foundation


struct Country: Codable {
    var name: CountryName
    var flags: CountryFlag
}

struct CountryName: Codable {
    var common: String
}

struct CountryFlag: Codable {
    var png: String
    var svg: String
    
}
