//
//  OfferSectionModel.swift
//  VodafoneTest
//
//  Created by Mészáros Kristóf on 2023. 01. 18..
//

import RxCocoa
import RxSwift
import RxDataSources

enum OfferSectionModel {
    case normalSection(title: String, items: [OfferSectionItem])
    case specialSection(title: String, items: [OfferSectionItem])
}

enum OfferSectionItem {
    case offerItem(offer: Offer)
}

extension OfferSectionModel: SectionModelType {
    typealias Item = OfferSectionItem
    
    var items: [OfferSectionItem] {
        switch  self {
        case .normalSection(title: _, items: let items):
            return items.map { $0 }
        case .specialSection(title: _, items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: OfferSectionModel, items: [Item]) {
        switch original {
        case let .normalSection(title: title, items: _):
            self = .normalSection(title: title, items: items)
        case let .specialSection(title: title, items: _):
            self = .specialSection(title: title, items: items)
        }
    }
}
extension OfferSectionModel {
    var title: String {
        switch self {
        case .normalSection(title: let title, items: _):
            return title
        case .specialSection(title: let title, items: _):
            return title
        }
    }
}
