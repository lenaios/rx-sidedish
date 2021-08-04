//
//  RepositoryService.swift
//  RxSideDish
//
//  Created by Ador on 2021/07/29.
//

import Foundation
import RxSwift

protocol Service where Output: Decodable {
  
  associatedtype Output
  
  func fetch(_ path: Endpoint.Path) -> Observable<Output>
}

enum NetworkError: Error {
  case invalidURL
}

class RepositoryService<T: Decodable> {
  
  typealias Output = T
  
  let sessionManager: SessionManagable
  
  init(sessionManager: SessionManagable) {
    self.sessionManager = sessionManager
  }
  
  func fetch(_ url: String) -> Observable<Data> {
    guard let url = URL(string: url) else {
      return Observable.error(NetworkError.invalidURL)
    }
    return sessionManager.request(with: url)
  }
}

extension RepositoryService {
  
  func fetch(_ path: Endpoint.Path) -> Observable<Output> {
    let url = Endpoint(path: path).url
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
