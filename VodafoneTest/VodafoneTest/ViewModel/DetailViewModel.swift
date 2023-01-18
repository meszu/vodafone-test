//
//  DetailViewModel.swift
//  VodafoneTest
//
//  Created by Mészáros Kristóf on 2023. 01. 18..
//

import Foundation
import Moya
import RxSwift
import RxCocoa

class DetailViewModel {
    let items = PublishSubject<[Detail]>()

    let provider = MoyaProvider<DetailsService>()
    
    var offerDetail: Detail = Detail(id: "0", name: "Sample", shortDescription: "Sample", description: "Sample")

    func fetchData() {
        provider.request(.details) { result in
            switch result {
            case .success(let response):
                do {
                    let details = try response.map(DetailRecord.self).record
                    
                    var detailArray: [Detail] = []
                    var detailToSend = Detail(id: "", name: "", shortDescription: "", description: "")
                    
                        detailToSend = Detail(
                            id: details.id,
                            name: details.name,
                            shortDescription: details.shortDescription,
                            description: details.description)
                        detailArray.append(detailToSend)
                    self.offerDetail = detailToSend

                    self.items.onNext(detailArray)
                } catch {
                    print("Failed to parse the detail data with error: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Failed to download the detail json with error: \(error.localizedDescription)")
            }
        }
    }
}
