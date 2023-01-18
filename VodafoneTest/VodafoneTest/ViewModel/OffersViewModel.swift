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
    var delegate: OffersViewModelDelegate?

    let provider = MoyaProvider<OffersService>()
    let detailProvider = MoyaProvider<DetailsService>()
    
    var sectionHeaders: [String] = []
    var newSections: [OfferSectionModel] = []
    var detailsToPresent: Detail = Detail(id: "", name: "", shortDescription: "", description: "")
    
    private var _sectionModels: BehaviorSubject<[OfferSectionModel]> = BehaviorSubject(value: [])
       
    var sectionModels: SharedSequence<DriverSharingStrategy, [OfferSectionModel]> {
        return _sectionModels.asDriver(onErrorJustReturn: [])
    }
    
    private var _detailModels: BehaviorSubject<Detail> = BehaviorSubject(value: Detail(id: "", name: "", shortDescription: "", description: ""))
       
    var detailModels: SharedSequence<DriverSharingStrategy, Detail> {
        return _detailModels.asDriver(onErrorJustReturn: Detail(id: "", name: "", shortDescription: "", description: ""))
    }

    func fetchData() {
        provider.request(.offers) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    /* Parse the JSON file, exclude offers where "id" or "rank" parameter is nil. */
                    let responseData = try response.map(Offers.self).record.offers.filter { $0.rank != nil && $0.id != nil }
                    
                    self.newSections = []
                    self.sectionHeaders = []
                    
                    /* Filter all offers based on wheter they are special offers or normal offers. */
                    let normalOffers = responseData.filter { !$0.isSpecial }
                    let specialOffers = responseData.filter { $0.isSpecial }
                    
                    /* Sort offers based on their rank, .sorted() works here, because Offer struct conforms to
                       Comparable, custom function sort them by rank by default.
                     */
                    let sortedNormalOffers = normalOffers.sorted()
                    let sortedSpecialOffers = specialOffers.sorted()
                    
                    /* Convert offers array into an array of OfferSectionItems, this way we can use RxDataSource with multiple sections.
                     */
                    let createSpecialOfferItems = sortedSpecialOffers.map { OfferSectionItem.offerItem(offer: $0) }
                    let createNormalOfferItems = sortedNormalOffers.map { OfferSectionItem.offerItem(offer: $0) }
                    
                    /* Check if one of the sections is empty, because if one section does not contain any offers, the section should not even appear.
                     */
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
                    self.delegate?.showError("Error", "Error while parsing the data. Please try again later.")
                    print("error while mapping response")
                }
            case .failure(let error):
                self.delegate?.showError("Error", "Error while downloading data. Please try again later.")
                print("Failed to download the offers list with error: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchDetailData() {
        detailProvider.request(.details) { [self] result in
            switch result {
            case .success(let response):
                do {
                    let detail = try response.map(DetailRecord.self).record
                    
                    detailsToPresent = Detail(
                        id: detail.id,
                        name: detail.name,
                        shortDescription: detail.shortDescription,
                        description: detail.description)
                    
                    self._detailModels.onNext(self.detailsToPresent)
                } catch {
                    self.delegate?.showError("Error", "Error while parsing the data. Please try again later.")
                }
            case .failure(let error):
                self.delegate?.showError("Error", "Error while downloading data. Please try again later.")
                print("Failed to download the offers list with error: \(error.localizedDescription)")
            }
        }
    }
}
