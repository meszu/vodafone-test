//
//  OffersService.swift
//  VodafoneTest
//
//  Created by Mészáros Kristóf on 2023. 01. 12..
//

import Foundation
import Moya

public enum OffersService {
    case offers
}

extension OffersService: TargetType {
  
  public var baseURL: URL {
    return URL(string: "https://api.jsonbin.io/v3/b/63bec2c4dfc68e59d57fab71")!
  }

  public var path: String {
    return ""
  }

  public var method: Moya.Method {
    switch self {
    case .offers: return .get
    }
  }

  public var sampleData: Data {
    return Data()
  }

  public var task: Task {
    return .requestPlain
  }

  public var headers: [String: String]? {
      return nil
  }

  public var validationType: ValidationType {
    return .successCodes
  }
}
