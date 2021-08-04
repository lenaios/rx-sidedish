//
//  SideDishContentView.swift
//  RxSideDish
//
//  Created by Ador on 2021/08/04.
//

import UIKit

@IBDesignable
class SideDishContentView: UIView {
  
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var subtitle: UILabel!
  @IBOutlet weak var price: UILabel!
  
  func configure(_ data: SideDish) {
    title.text = data.title
    subtitle.text = data.description
    price.text = data.sPrice
  }
}
