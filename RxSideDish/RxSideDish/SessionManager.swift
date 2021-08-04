//
//  SessionManager.swift
//  RxSideDish
//
//  Created by Ador on 2021/07/30.
//

import Foundation
import RxSwift
import RxCocoa

protocol SessionManagable {
  func request(with request: URLRequest) -> Observable<Data>
}

class SessionManager: SessionManagable {
  
  static let shared = SessionManager()
  
  let session = URLSession(configuration: .default)

}

extension SessionManager {
  func request(with request: URLRequest) -> Observable<Data> {
    return session.rx.data(request: request)
  }
}
