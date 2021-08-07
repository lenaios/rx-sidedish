//
//  SideDishDetailView.swift
//  RxSideDish
//
//  Created by Ador on 2021/08/07.
//

import UIKit

class SideDishDetailView: UIView {
  
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = 10
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  let title: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    return label
  }()
  
  let subtitle: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    return label
  }()
  
  let normal: UILabel = {
    let label = UILabel()
    return label
  }()
  
  let sale: UILabel = {
    let label = UILabel()
    return label
  }()
  
  let points: UILabel = {
    let label = UILabel()
    return label
  }()
  
  let deliveryInfo: UILabel = {
    let label = UILabel()
    return label
  }()
  
  let deliveryFee: UILabel = {
    let label = UILabel()
    return label
  }()
  
  let quantity: UILabel = {
    let label = UILabel()
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupSubviews()
    setupConstraints()
  }
  
  private func setupSubviews() {
    addSubview(stackView)
    [title, subtitle, sale].forEach {
      stackView.addArrangedSubview($0)
    }
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
      stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
      stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
    ])
  }
}
