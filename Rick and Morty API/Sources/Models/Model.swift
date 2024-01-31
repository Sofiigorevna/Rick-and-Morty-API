//
//  Model.swift
//  Rick and Morty API
//
//  Created by 1234 on 18.01.2024.
//

import Foundation

public struct Results : Decodable {
    var results: [Characters]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

public struct Characters: Decodable {
    let name: String?
    let species: String?
    let gender: String?
    let status: String?
    let location: Locations?
    let episode: [String]?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case species
        case gender
        case status
        case location
        case episode
        case image
    }
}

public struct Locations : Decodable {
    let name: String?

    enum CodingKeys: String, CodingKey {
        case name
    }
}

