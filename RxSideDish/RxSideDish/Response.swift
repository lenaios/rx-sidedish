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
  let badge: [String]?
}

struct SideDishResponse: Decodable {
  let hash: String
  let data: SideDishDetail
}

struct SideDishDetail: Decodable {
  let topImage: String
  let thumbImages: [String]
  let productDescription: String
  let point: String
  let deliveryInfo: String
  let deliveryFee: String
  let prices: [String]
  let detailSection: [String]
}
