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
    String(describing: self)
  }
  
  private let disposeBag = DisposeBag()
  
  var viewModel: SideDishDetailViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = false
  }
  
  private let transform: (String) -> UIImage? = { string in
    let url = URL(string: string)!
    guard let data = try? Data(contentsOf: url) else { return nil }
    return UIImage(data: data)
  }
  
  private func bindUI() {
    viewModel.sideDish
      .subscribe(onNext: {
        self.detailView.title.text = $0.title
        self.detailView.subtitle.text = $0.description
        self.detailView.sale.text = $0.sPrice
        self.detailView.normal.text = $0.nPrice
        self.title = $0.title
      })
      .disposed(by: disposeBag)
      
    viewModel.sideDishDetail
      .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
      .subscribe(onNext: {
        let thumbnail = $0.thumbImages.compactMap(self.transform)
        let detailImages = $0.detailSection.compactMap(self.transform)
        DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          thumbnail.forEach { image in
              let imageView = UIImageView(image: image)
              imageView.configureSize(ratio: 0.75)
              self.imageStackView.addArrangedSubview(imageView)
            }
          detailImages.forEach { image in
            let imageView = UIImageView(image: image)
            imageView.configureSize(ratio: image.ratio)
            self.detailImageStackView.addArrangedSubview(imageView)
          }
        }
      })
      .disposed(by: disposeBag)
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

extension UIImage {
  var ratio: CGFloat {
    size.height / size.width
  }
}
