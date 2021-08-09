//
//  ImageView+Extension.swift
//  RxSideDish
//
//  Created by Ador on 2021/08/08.
//

import UIKit

extension UIImageView {
  func setupImage(with url: String) {
    guard let url = URL(string: url) else {
      image = nil
      return
    }
    
    DispatchQueue.global(qos: .background).async { [weak self] in
      guard let self = self else { return }
      URLSession.shared.dataTask(with: url) { data, response, error in
        guard
          let data = data, error == nil,
          let image = UIImage(data: data)
        else {
          self.image = nil
          return
        }
        DispatchQueue.main.async {
          self.image = image
        }
      }.resume()
    }
  }
}

extension UIImageView {
  func configureSize(ratio: CGFloat = 1) {
    contentMode = .scaleAspectFill
    translatesAutoresizingMaskIntoConstraints = false
    self.heightAnchor.constraint(
      equalTo: self.widthAnchor, multiplier: ratio).isActive = true
  }
}
