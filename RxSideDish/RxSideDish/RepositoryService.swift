//
//  RepositoryService.swift
//  RxSideDish
//
//  Created by Ador on 2021/07/29.
//

import Foundation
import RxSwift

protocol RepositoryServiceType {
  
  var sessionManager: SessionManagerType { get }
  
  func fetch<T: Decodable>(endpoint: Endpoint.Path, decodingType: T.Type) -> Observable<T>
}

struct SideDishRepositoryService: RepositoryServiceType {
  
  let sessionManager: SessionManagerType
}

struct SideDishDetailRepositoryService: RepositoryServiceType {

  let sessionManager: SessionManagerType
}

extension RepositoryServiceType {

  func fetch<T: Decodable>(endpoint: Endpoint.Path, decodingType: T.Type) -> Observable<T> {
    let url = Endpoint(path: endpoint).url
    let request = URLRequest(url: url)
    return
      self.sessionManager.request(with: request)
      .compactMap { data in
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try? decoder.decode(T.self, from: data)
      }
  }
}
