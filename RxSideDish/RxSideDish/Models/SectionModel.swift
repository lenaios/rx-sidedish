//
//  SectionModel.swift
//  RxSideDish
//
//  Created by Ador on 2021/08/02.
//

import Foundation

enum Category: String, CaseIterable {
  case main = "모두가 좋아하는 메인요리"
  case soup = "정성이 담긴 뜨끈뜨끈 국물요리"
  case side = "식탁을 풍성하게 하는 밑반찬"
}

struct SectionModel {
  var header: String
  var category: Category
  var items: [SideDish]
}
