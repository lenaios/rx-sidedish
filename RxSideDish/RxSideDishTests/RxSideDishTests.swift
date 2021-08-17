//
//  RxSideDishTests.swift
//  RxSideDishTests
//
//  Created by Ador on 2021/07/28.
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

class RxSideDishTests: XCTestCase {
  
  let sessionManager = SessionManagerStub()
  var service: SideDishRepositoryService!
  
  override func setUp() {
    super.setUp()
    service = SideDishRepositoryService(sessionManager: sessionManager)
  }
  
  func testAPIRequest() throws {
    
    // given
    let endpoint = Endpoint(path: .main)
    let url = endpoint.url
    
    // when
    _ = service.fetch(endpoint: .main)
    
    // then
    XCTAssert(sessionManager.mockURL == url)
    
  }
  
  override func tearDownWithError() throws {
    service = nil
  }
}
