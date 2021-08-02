//
//  SectionModel.swift
//  RxSideDish
//
//  Created by Ador on 2021/08/02.
//

import Foundation

enum Category: Int, CaseIterable {
  case main = 0
  case soup
  case side
}

struct SectionModel {
  var model: String
  var category: Category
  var items: [SideDish]
}
