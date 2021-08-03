//
//  SideDishTableViewHeader.swift
//  RxSideDish
//
//  Created by Ador on 2021/08/03.
//

import UIKit

class SideDishTableViewHeader: UIView {
  
  private let title: UILabel = {
    let lable = UILabel()
    lable.translatesAutoresizingMaskIntoConstraints = false
    lable.font = .systemFont(ofSize: 20, weight: .medium)
    lable.textColor = .label
    return lable
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white.withAlphaComponent(0.5)
    addSubview(title)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    backgroundColor = .white.withAlphaComponent(0.5)
    addSubview(title)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    NSLayoutConstraint.activate([
      title.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
      title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
      title.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
    ])
  }
  
  func configure(title: String) {
    self.title.text = title
  }
}
