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
  @IBOutlet weak var contentStackView: UIStackView!
  @IBOutlet weak var contentView: SideDishContentView!
  
  static var identifier: String {
    return String(describing: self)
  }
  
  private let disposeBag = DisposeBag()
  
  var viewModel: SideDishDetailViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.contentView.configure(viewModel.sideDish)
    
    viewModel.imagePublisher
//      .subscribe(on: MainScheduler.instance)
      .subscribe { [weak self] event in
        guard let self = self else { return }
        if let data = event.element {
          DispatchQueue.main.async {
            let image = UIImage(data: data)
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.75).isActive = true
            self.imageStackView.addArrangedSubview(imageView)
          }
        }
      }.disposed(by: disposeBag)
    
    viewModel.subject
      .subscribe { [weak self] event in
        guard let self = self else { return }
        if let element = event.element {
          self.viewModel.fetch(images: element.thumbImages)
        }
      }.disposed(by: disposeBag)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
  }
}
