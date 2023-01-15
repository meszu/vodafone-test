//
//  DetailsService.swift
//  VodafoneTest
//
//  Created by Mészáros Kristóf on 2023. 01. 15..
//

import Foundation
import Moya

public enum DetailsService {
    case details
}

extension DetailsService: TargetType {
  
  public var baseURL: URL {
    return URL(string: "https://api.jsonbin.io/v3/b/63c2a1f201a72b59f24aa38c")!
  }

  public var path: String {
    return ""
  }

  public var method: Moya.Method {
    switch self {
    case .details: return .get
    }
  }

  public var sampleData: Data {
    return Data()
  }

  public var task: Task {
    return .requestPlain // TODO
  }

  public var headers: [String: String]? {
      return nil
  }

  public var validationType: ValidationType {
    return .successCodes
  }
}
