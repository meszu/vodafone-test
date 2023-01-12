//
//  Offers.swift
//  VodafoneTest
//
//  Created by Mészáros Kristóf on 2023. 01. 10..
//

import Foundation

struct Offers: Codable {
    var record: Record
    
    static let mockData: [Offer] = [
        Offer(id: "1", rank: 1, isSpecial: true, name: "100MB", shortDescription: "rovid 100 MB adat"),
        Offer(id: "2", rank: 2, isSpecial: true, name: "300MB", shortDescription: "gyors 300MB adat very nice"),
        Offer(id: "3", rank: 3, isSpecial: false, name: "400MB", shortDescription: "gyors 400MB internet ami szélsebesen szárnyal az internet mély bugyraiban, kellemesen használható télen nyáron"),
        Offer(id: "4", rank: 4, isSpecial: false, name: "500MB", shortDescription: "verygyors 500MB"),
        Offer(id: "5", rank: 21, isSpecial: true, name: "1GB", shortDescription: "ubergyors internet"),
        Offer(id: "6", rank: 22, isSpecial: false, name: "2GB", shortDescription: "uberultragyorsnet")
    ]
}

struct Record: Codable {
    var offers: [Offer]
}
