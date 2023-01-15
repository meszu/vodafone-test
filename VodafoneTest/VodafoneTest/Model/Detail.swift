//
//  Detail.swift
//  VodafoneTest
//
//  Created by Mészáros Kristóf on 2023. 01. 10..
//

import Foundation

struct Detail: Codable {
    var id: String
    var name: String
    var shortDescription: String
    var description: String
}

struct DetailRecord: Codable {
    var record: Detail
}
