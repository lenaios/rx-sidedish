//
//  Endpoint.swift
//  RxSideDish
//
//  Created by Ador on 2021/07/29.
//

import Foundation

struct Endpoint {
  
  enum Path: String, CustomStringConvertible {
    case main = "main"
    case soup = "soup"
    case side = "side"
    case detail = "detail"
    
    var description: String {
      return self.rawValue
    }
  }
  
  var path: Path
  var queryItems: [URLQueryItem] = []
  
  let scheme: String = "https"
  let host: String = "h3rb9c0ugl.execute-api.ap-northeast-2.amazonaws.com"
}

extension Endpoint {
  var url: URL {
    var components = URLComponents()
    components.scheme = scheme
    components.host = host
    components.path = "/develop/baminchan/" + path.description
    components.queryItems = queryItems
    
    guard let url = components.url else {
      preconditionFailure(
        "Invalid URL components: \(components)"
      )
    }
    return url
  }
}

