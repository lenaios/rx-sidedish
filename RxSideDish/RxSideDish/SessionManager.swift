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
  func request(with url: URL) -> Observable<Data>
}

class SessionManager: SessionManagable {
  
  static let shared = SessionManager()
  
  let session = URLSession(configuration: .default)

  func request(with url: URL) -> Observable<Data> {
    return Observable.create { observer in
      self.session.dataTask(with: url) { data, _, error in
        guard let data = data else {
          return observer.onError(error!)
        }
        observer.onNext(data)
      }.resume()
      return Disposables.create()
    }
  }
}

extension SessionManager {
  func request(with request: URLRequest) -> Observable<Data> {
    return session.rx.data(request: request)
  }
}
