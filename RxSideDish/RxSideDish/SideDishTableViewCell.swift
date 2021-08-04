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
  
  func confiugre(_ data: SideDish) {
    title.text = data.title
    subtitle.text = data.description
    sale.text = data.sPrice
    setup(image: data.image)
    data.badge?.forEach { label in
      let badge = BadgeLabel()
      badge.configure(label)
      badgeStackView.addArrangedSubview(badge)
    }
  }
  
  private func setup(image: String) {
    let url = URL(string: image)!
    URLSession.shared.dataTask(with: url) { data, _, error in
      guard let data = data else { return }
      DispatchQueue.main.async {
        let image = UIImage(data: data)
        self.thumbnail.image = image
      }
    }.resume()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    title.text = nil
    subtitle.text = nil
    sale.text = nil
    badgeStackView.arrangedSubviews.forEach { view in
      view.removeFromSuperview()
    }
  }
}
