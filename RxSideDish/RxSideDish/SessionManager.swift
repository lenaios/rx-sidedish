//
//  SessionManager.swift
//  RxSideDish
//
//  Created by Ador on 2021/07/30.
//

import Foundation
import RxSwift
import RxCocoa

protocol SessionManagerType {
  func request(with request: URLRequest) -> Observable<Data>
}

class SessionManager: SessionManagerType {
  
  static let shared = SessionManager()
  
  let session = URLSession(configuration: .default)
  
  func request(with request: URLRequest) -> Observable<Data> {
    return session.rx.data(request: request)
  }
}
