//
//  VodafoneTestTests.swift
//  VodafoneTestTests
//
//  Created by Mészáros Kristóf on 2023. 01. 18..
//

import Foundation
import XCTest
import Moya

@testable import VodafoneTest

class OffersViewModelTests: XCTestCase {
    
    var provider: MoyaProvider<OffersService>!
    
    override func setUp() {
        super.setUp()
        
        provider = MoyaProvider<OffersService>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)    }
    
    func customEndpointClosure(_ target: OffersService) -> Endpoint {
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: { .networkResponse(200, target.testSampleData) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
    }
    
    func testFetchData() {
        provider.request(.offers) { result in
            switch result {
            case .success(let response):
                do {
                    /* Parse the JSON file, exclude offers where "id" or "rank" parameter is nil. */
                    let responseData = try response.map(Offers.self).record.offers.filter { $0.rank != nil && $0.id != nil }
                    
                    XCTAssertEqual(responseData.count, 4)
                    
                    /* Filter all offers based on wheter they are special offers or normal offers. */
                    let normalOffers = responseData.filter { !$0.isSpecial }
                    /* Check if normalOffers array's first element's name is the same as it supposed to be based on the mock data */
                    XCTAssertEqual(normalOffers[0].name, "One time 500 MB")
                    let specialOffers = responseData.filter { $0.isSpecial }
                    /* Check if specialOffers array's first element's name is the same as it supposed to be based on the mock data */
                    XCTAssertEqual(specialOffers[0].name, "One time 1 GB")
                    
                    /* Sort offers based on their rank, .sorted() works here, because Offer struct conforms to
                       Comparable, custom function sort them by rank by default.
                     */
                    let sortedNormalOffers = normalOffers.sorted()
                    /* Check if the sortedNormalOffers array's first element's name is the same as it supposed to be based on the mock data */
                    XCTAssertEqual(normalOffers[0].name, "One time 500 MB")
                    let sortedSpecialOffers = specialOffers.sorted()
                    /* Check if the sortedSpecialOffers array's first element's name is the same as it supposed to be based on the mock data */
                    XCTAssertEqual(sortedSpecialOffers[0].name, "One time 300 MB")
                    
                    /* Convert offers array into an array of OfferSectionItems, this way we can use RxDataSource with multiple sections.
                     */
                    let createSpecialOfferItems = sortedSpecialOffers.map { OfferSectionItem.offerItem(offer: $0) }
                    /* Check if after mapping they have the same amount of elements. */
                    XCTAssertEqual(createSpecialOfferItems.count, specialOffers.count)
                    
                    let createNormalOfferItems = sortedNormalOffers.map { OfferSectionItem.offerItem(offer: $0) }
                    /* Check if after mapping they have the same amount of elements. */
                    XCTAssertEqual(createNormalOfferItems.count, normalOffers.count)

                    /* Check if one of the sections is empty, because if one section does not contain any offers, the section should not even appear.
                     */
                    if !specialOffers.isEmpty {
                        /* Check if specialOffers really contains at least one element */
                        XCTAssertEqual(specialOffers.isEmpty, false)
                    }
                    if !normalOffers.isEmpty {
                        /* Check if normalOffers really contains at least one element */
                        XCTAssertEqual(normalOffers.isEmpty, false)
                    }
                } catch {
                    print("error while mapping response")
                }
            case .failure(let error):
                print("Failed to download the offers list with error: \(error.localizedDescription)")
            }
        }
    }
}

extension OffersService {
    var testSampleData: Data {
        switch self {
        case .offers:
            let url = Bundle.main.url(forResource: "input", withExtension: "json")!
            return try! Data(contentsOf: url)
        }
    }
}

