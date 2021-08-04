//
//  BadgeLabel.swift
//  RxSideDish
//
//  Created by Ador on 2021/08/03.
//

import UIKit

@IBDesignable
class BadgeLabel: UILabel {
  
  private let inset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
  
  override func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: inset))
  }
  
  func configure(_ text: String) {
    self.text = text
    self.backgroundColor = #colorLiteral(red: 0.831372549, green: 0.7725490196, blue: 0.9764705882, alpha: 1)
    self.font = .systemFont(ofSize: 14)
  }
  
  override var intrinsicContentSize: CGSize {
    var contentSize = super.intrinsicContentSize
    let inset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    contentSize.height += inset.top + inset.bottom
    contentSize.width += inset.left + inset.right
    return contentSize
  }
}
