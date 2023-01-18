//
//  OffersViewModel.swift
//  VodafoneTest
//
//  Created by Mészáros Kristóf on 2023. 01. 18..
//

import Moya
import RxCocoa
import RxSwift

public class OffersViewModel {
    let provider = MoyaProvider<OffersService>()
    
    var sectionHeaders: [String] = []
    var newSections: [OfferSectionModel] = []
    
    private var _sectionModels: BehaviorSubject<[OfferSectionModel]> = BehaviorSubject(value: [])
       
    var sectionModels: SharedSequence<DriverSharingStrategy, [OfferSectionModel]> {
        return _sectionModels.asDriver(onErrorJustReturn: [])
    }

    func fetchData() {
        provider.request(.offers) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let responseData = try response.map(Offers.self).record.offers.filter { $0.rank != nil && $0.id != nil }
                    
                    self.newSections = []
                    self.sectionHeaders = []
                    let normalOffers = responseData.filter { !$0.isSpecial }
                    let specialOffers = responseData.filter { $0.isSpecial }
                    
                    let sortedNormalOffers = normalOffers.sorted()
                    let sortedSpecialOffers = specialOffers.sorted()
                    
                    let createSpecialOfferItems = sortedSpecialOffers.map { OfferSectionItem.offerItem(offer: $0) }
                    let createNormalOfferItems = sortedNormalOffers.map { OfferSectionItem.offerItem(offer: $0) }

                    if !specialOffers.isEmpty {
                        self.sectionHeaders.append("Special Offers")
                        self.newSections.append(.specialSection(title: "Special Offers", items: createSpecialOfferItems))
                    }
                    if !normalOffers.isEmpty {
                        self.sectionHeaders.append("Offers")

                        self.newSections.append(.normalSection(title: "Offers", items: createNormalOfferItems))
                    }
                    self._sectionModels.onNext(self.newSections)
                } catch {
                    print("error while mapping response")
                }
            case .failure(let error):
                print("Failed to download the offers list with error: \(error.localizedDescription)")
            }
        }
    }
}
