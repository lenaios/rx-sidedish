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
      .map { $0.point }
      .bind(to: self.detailView.points.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.sideDishDetail
      .map { $0.deliveryInfo }
      .bind(to: self.detailView.deliveryInfo.rx.text)
      .disposed(by: disposeBag)
      
    viewModel.sideDishDetail
      .map { $0.deliveryFee }
      .bind(to: self.detailView.deliveryFee.rx.text)
      .disposed(by: disposeBag)
      
    viewModel.image
      .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
      .compactMap(self.transform)
      .observe(on: MainScheduler.instance)
      .map { UIImageView(image: $0) }
      .do { $0.configureSize(ratio: 0.75) }
      .do { self.imageStackView.addArrangedSubview($0) }
      .subscribe(onNext: { _ in })
      .disposed(by: disposeBag)
    
    viewModel.detailImage
      .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
      .compactMap(self.transform)
      .observe(on: MainScheduler.instance)
      .map { UIImageView(image: $0) }
      .do { $0.configureSize(ratio: $0.image!.ratio) }
      .do { self.detailImageStackView.addArrangedSubview($0) }
      .subscribe(onNext: { _ in })
      .disposed(by: disposeBag)
  }
}

extension UIImage {
  var ratio: CGFloat {
    size.height / size.width
  }
}
