//
//  Endpoint.swift
//  RxSideDish
//
//  Created by Ador on 2021/07/29.
//

import Foundation

struct Endpoint {
  
  enum Path {
    case main
    case soup
    case side
    case detail(String)
    
    func string() -> String {
      switch self {
      case .main: return "/main"
      case .soup: return "/soup"
      case .side: return "/side"
      case .detail(let id):
        return "/detail/" + id
      }
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
    components.path = "/develop/baminchan" + path.string()
    components.queryItems = queryItems
    
    guard let url = components.url else {
      preconditionFailure(
        "Invalid URL components: \(components)"
      )
    }
    return url
  }
}

