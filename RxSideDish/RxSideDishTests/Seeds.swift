//
//  Seeds.swift
//  RxSideDishTests
//
//  Created by Ador on 2021/08/18.
//

import XCTest
@testable import RxSideDish

struct Seeds {
  static let sideDish = SideDish(detailHash: "", image: "", alt: "", deliveryType: [], title: "", description: "", nPrice: "", sPrice: "", badge: nil)
  
  static let sideDishes = SideDishes(statusCode: 200, body: [sideDish])
}
