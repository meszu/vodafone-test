//
//  DetailsViewModelTests.swift
//  VodafoneTestTests
//
//  Created by Mészáros Kristóf on 2023. 01. 18..
//

import Foundation
import XCTest
import Moya

@testable import VodafoneTest

class DetailsViewModelTests: XCTestCase {
    
    var provider: MoyaProvider<DetailsService>!
    
    override func setUp() {
        super.setUp()
        
        provider = MoyaProvider<DetailsService>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)    }
    
    func customEndpointClosure(_ target: DetailsService) -> Endpoint {
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: { .networkResponse(200, target.testSampleData) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
    }

    
    func testFetchData() {
        provider.request(.details) { result in
            switch result {
            case .success(let response):
                do {
                    let details = try response.map(DetailRecord.self).record
                    
                    XCTAssertEqual(details.id, "1")
                    XCTAssertEqual(details.name, "One time 1 GB")
                    XCTAssertEqual(details.shortDescription, "Let's choose between our data packages.")
                    XCTAssertEqual(details.description, "1GB 30 day once off prepaid data bundle. This option is ideal if you don’t exceed your bundle often and want to take advantage of the lower in-bundle rates. You can buy as many once-off bundles as you wish.")
                    
                } catch {
                    print("error while mapping response")
                }
            case .failure(let error):
                print("Failed to download the offers list with error: \(error.localizedDescription)")
            }
        }
    }
}

extension DetailsService {
    var testSampleData: Data {
        switch self {
        case .details:
            let url = Bundle.main.url(forResource: "detailInput", withExtension: "json")!
            return try! Data(contentsOf: url)
        }
    }
}
