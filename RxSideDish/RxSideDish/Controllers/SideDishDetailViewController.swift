//
//  SideDishDetailViewController.swift
//  RxSideDish
//
//  Created by Ador on 2021/08/03.
//

import UIKit
import RxSwift
import RxCocoa

class SideDishDetailViewController: UIViewController {
  
  @IBOutlet weak var imageScrollView: UIScrollView!
  @IBOutlet weak var imageStackView: UIStackView!
  @IBOutlet weak var detailImageStackView: UIStackView!
  @IBOutlet weak var detailView: SideDishDetailView!
  
  static var identifier: String {
    return String(describing: self)
  }
  
  private let disposeBag = DisposeBag()
  
  var viewModel: SideDishDetailViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.sideDish
      .subscribe(onNext: {
        self.detailView.title.text = $0.title
        self.detailView.subtitle.text = $0.description
        self.detailView.sale.text = $0.sPrice
        self.detailView.normal.text = $0.nPrice
      })
      .disposed(by: disposeBag)
    
    viewModel.detailImage
      .observe(on: MainScheduler.instance)
      .compactMap {
        return UIImage(data: $0)
      }
      .subscribe(onNext: { image in
        let ratio = image.size.height / image.size.width
        let imageView = self.makeImageView(with: image, ratio: ratio)
        self.detailImageStackView.addArrangedSubview(imageView)
      })
      .disposed(by: disposeBag)
    
    viewModel.thumbnail
      .observe(on: MainScheduler.instance)
      .compactMap {
        return UIImage(data: $0)
      }
      .subscribe(onNext: {
        let imageView = self.makeImageView(with: $0, ratio: 0.75)
        self.imageStackView.addArrangedSubview(imageView)
      })
      .disposed(by: disposeBag)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
  }
  
  private func makeImageView(with image: UIImage, ratio: CGFloat = 0) -> UIImageView {
    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.heightAnchor.constraint(
      equalTo: imageView.widthAnchor, multiplier: ratio).isActive = true
    return imageView
  }
}
