//
//  Response.swift
//  RxSideDish
//
//  Created by Ador on 2021/07/31.
//

import Foundation

struct Response: Decodable {
  var statusCode: Int
  var body: [SideDish]
}

struct SideDish: Decodable {
  let detailHash: String
  let image: String
  let alt: String
  let deliveryType: [String]
  let title: String
  let description: String
  let sPrice: String
}
