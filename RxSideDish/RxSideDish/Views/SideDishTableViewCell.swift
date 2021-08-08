//
//  SideDishTableViewCell.swift
//  RxSideDish
//
//  Created by Ador on 2021/08/03.
//

import UIKit

class SideDishTableViewCell: UITableViewCell {
  
  @IBOutlet weak var thumbnail: UIImageView!
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var subtitle: UILabel!
  @IBOutlet weak var normal: UILabel!
  @IBOutlet weak var sale: UILabel!
  @IBOutlet weak var badgeStackView: UIStackView!
  
  static var identifier: String {
    String(describing: self)
  }
  
  func configure(_ data: SideDish) {
    title.text = data.title
    subtitle.text = data.description
    sale.text = data.sPrice
    if let price = data.nPrice {
      normal.attributedText = .init(
        string: price, attributes: [.strikethroughStyle: 1])
    }
    data.badge?.forEach { label in
      let badge = BadgeLabel()
      badge.configure(label)
      badgeStackView.addArrangedSubview(badge)
    }
  }
  
  func confiugre(_ image: UIImage) {
    self.thumbnail.image = image
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    normal.text = ""
    badgeStackView.arrangedSubviews.forEach { view in
      view.removeFromSuperview()
    }
  }
}
