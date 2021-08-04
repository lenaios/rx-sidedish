//
//  SideDishDetailViewController.swift
//  RxSideDish
//
//  Created by Ador on 2021/08/03.
//

import UIKit
import RxSwift

class SideDishDetailViewController: UIViewController {
  
  @IBOutlet weak var imageScrollView: UIScrollView!
  @IBOutlet weak var imageStackView: UIStackView!
  
  static var identifier: String {
    return String(describing: self)
  }
  
  private let disposeBag = DisposeBag()
  
  var viewModel: SideDishDetailViewModel?
  
  private var images: [String] = [] {
    didSet {
      images.forEach { image in
        setup(image: image)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel?.subject
      .subscribe { [weak self] event in
        guard let self = self else { return }
        if let element = event.element {
          self.images = element.thumbImages
        }
      }.disposed(by: disposeBag)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
  }
  
  private func setup(image: String) {
    let url = URL(string: image)!
    guard let data = try? Data(contentsOf: url) else {
      return
    }
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      let image = UIImage(data: data)
      let imageView = UIImageView(image: image)
      imageView.contentMode = .scaleAspectFill
      imageView.translatesAutoresizingMaskIntoConstraints = false
      imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.75).isActive = true
      self.imageStackView.addArrangedSubview(imageView)
    }
  }
}
