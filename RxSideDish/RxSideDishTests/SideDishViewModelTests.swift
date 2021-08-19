//
//  SideDishViewModelTests.swift
//  RxSideDishTests
//
//  Created by Ador on 2021/08/18.
//

import XCTest
@testable import RxSwift
@testable import RxSideDish

class SessionManagerStub: SessionManagerType {
  
  var mockURL: URL?
  
  func request(with request: URLRequest) -> Observable<Data> {
    mockURL = request.url
    return Observable.empty()
  }
}

class RepositoryServiceStub: RepositoryServiceType {
  
  var sessionManager: SessionManagerType
  var didFetch = false
  
  func fetch<T: Decodable>(endpoint: Endpoint.Path, decodingType: T.Type) -> Observable<T> {
    didFetch = true
    return Observable.just(Seeds.sideDishes as! T)
  }
  
  init(sessionManager: SessionManagerType) {
    self.sessionManager = sessionManager
  }
}

class SideDishViewModelTests: XCTestCase {
  
  var session: SessionManagerStub!
  var service: RepositoryServiceStub!
  var viewModel: SideDishViewModel!
  
  override func setUpWithError() throws {
    session = SessionManagerStub()
    service = RepositoryServiceStub(sessionManager: session)
    viewModel = SideDishViewModel(repositoryService: service)
  }
  
  override func tearDownWithError() throws {
    session = nil
    service = nil
    viewModel = nil
  }
  
  func testExample() throws {
    // given
    let disposeBag = DisposeBag()
    let promise = expectation(description: "promise")
    promise.assertForOverFulfill = false
    
    // when
    viewModel.sectionUpdated.subscribe { _ in
      promise.fulfill()
    }.disposed(by: disposeBag)

    viewModel.load()
    
    // then
    XCTAssert(service.didFetch)
    wait(for: [promise], timeout: 5.0)
  }
}
