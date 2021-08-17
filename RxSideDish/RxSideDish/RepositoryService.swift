//
//  RepositoryService.swift
//  RxSideDish
//
//  Created by Ador on 2021/07/29.
//

import Foundation
import RxSwift

protocol RepositoryServiceType {
  
  associatedtype Output
  
  var sessionManager: SessionManagerType { get }
  
  func fetch(endpoint: Endpoint.Path) -> Observable<Output>
}

enum NetworkError: Error {
  case invalidURL
}

struct SideDishRepositoryService: RepositoryServiceType {
  
  typealias Output = SideDishes
  
  let sessionManager: SessionManagerType
}

struct SideDishDetailRepositoryService: RepositoryServiceType {

  typealias Output = SideDishDetailData

  let sessionManager: SessionManagerType
}

extension RepositoryServiceType where Output: Decodable {

  func fetch(endpoint: Endpoint.Path) -> Observable<Output> {
    let url = Endpoint(path: endpoint).url
    let request = URLRequest(url: url)
    return
      self.sessionManager.request(with: request)
      .compactMap { data in
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try? decoder.decode(Output.self, from: data)
      }
  }
}
