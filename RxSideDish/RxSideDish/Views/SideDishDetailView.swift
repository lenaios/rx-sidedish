//
//  SideDishDetailView.swift
//  RxSideDish
//
//  Created by Ador on 2021/08/07.
//

import UIKit

class SideDishDetailView: UIView {
  
  private let containerStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private let quantityCountStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.axis = .horizontal
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
    label.textColor = .systemGray
    label.font = .systemFont(ofSize: 14)
    label.numberOfLines = 2
    return label
  }()
  
  let normal: UILabel = {
    let label = UILabel()
    label.textColor = .systemGray
    label.font = .systemFont(ofSize: 14)
    return label
  }()
  
  let sale: UILabel = {
    let label = UILabel()
    return label
  }()
  
  let points: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14)
    return label
  }()
  
  let deliveryInfo: UILabel = {
    let label = UILabel()
    label.textColor = .systemGray
    label.font = .systemFont(ofSize: 14)
    label.numberOfLines = 3
    return label
  }()
  
  let deliveryFee: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.font = .systemFont(ofSize: 14)
    return label
  }()
  
  let quantity: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14)
    label.textAlignment = .center
    return label
  }()
  
  let plus: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "plus"), for: .normal)
    button.tintColor = .systemIndigo
    return button
  }()
  
  let minus: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "minus"), for: .normal)
    button.tintColor = .systemIndigo
    return button
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
    addSubview(containerStackView)
    
    [UILabel(), minus, quantity, plus].forEach {
      quantityCountStackView.addArrangedSubview($0)
    }
    
    let titleStackView = makeVerticalStackView()
    titleStackView.addArrangedSubview(title)
    titleStackView.addArrangedSubview(subtitle)
    
    let pointsStackView = makeHorizontalStackView()
    pointsStackView.addArrangedSubview(makeLabel(with: "적립금"))
    pointsStackView.addArrangedSubview(points)
    
    let deliveryInfoStackView = makeHorizontalStackView()
    deliveryInfoStackView.addArrangedSubview(makeLabel(with: "배송정보"))
    deliveryInfoStackView.addArrangedSubview(deliveryInfo)
    
    let deliveryFeeStackView = makeHorizontalStackView()
    deliveryFeeStackView.addArrangedSubview(makeLabel(with: "배송비"))
    deliveryFeeStackView.addArrangedSubview(deliveryFee)
    
    let quantityCountContainer = makeHorizontalStackView()
    quantityCountContainer.addArrangedSubview(makeLabel(with: "가격"))
    quantityCountContainer.addArrangedSubview(quantityCountStackView)
    
    let PriceStackView = makeHorizontalStackView()
    PriceStackView.addArrangedSubview(sale)
    PriceStackView.addArrangedSubview(normal)
    
    [titleStackView, PriceStackView, pointsStackView, deliveryInfoStackView, deliveryFeeStackView, quantityCountContainer].forEach {
      containerStackView.addArrangedSubview($0)
    }
  }
  
  private func setupConstraints() {
    sale.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    NSLayoutConstraint.activate([
      containerStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
      containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
      containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
    ])
  }
}

private extension SideDishDetailView {
  func makeVerticalStackView() -> UIStackView {
    let stackView = UIStackView()
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }
  
  func makeHorizontalStackView() -> UIStackView {
    let stackView = UIStackView()
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.axis = .horizontal
    stackView.spacing = 10
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }
  
  func makeLabel(with text: String) -> UILabel {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14)
    label.text = text
    label.translatesAutoresizingMaskIntoConstraints = false
    label.widthAnchor.constraint(equalToConstant: 70).isActive = true
    return label
  }
}
