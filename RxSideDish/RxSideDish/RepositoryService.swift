//
//  RepositoryService.swift
//  RxSideDish
//
//  Created by Ador on 2021/07/29.
//

import Foundation
import RxSwift

protocol RepositoryServiceable {
  
  associatedtype Output
  
  var sessionManager: SessionManagable { get }
  
  func fetch(endpoint: Endpoint.Path) -> Observable<Output>
}

enum NetworkError: Error {
  case invalidURL
}

struct SideDishRepositoryService: RepositoryServiceable {
  
  typealias Output = SideDishes
  
  let sessionManager: SessionManagable
}

struct SideDishDetailRepositoryService: RepositoryServiceable {
  
  typealias Output = SideDishDetailData
  
  let sessionManager: SessionManagable
}

extension RepositoryServiceable where Output: Decodable {
  
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
