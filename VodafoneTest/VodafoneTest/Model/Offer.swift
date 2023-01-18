//
//  Offer.swift
//  VodafoneTest
//
//  Created by Mészáros Kristóf on 2023. 01. 10..
//

import Foundation

struct Offer: Codable, Comparable {
    var id: String?
    var rank: Int?
    var isSpecial: Bool
    var name: String?
    var shortDescription: String?
    
    static func <(lhs: Offer, rhs: Offer) -> Bool {
        lhs.rank! < rhs.rank!
    }
}
