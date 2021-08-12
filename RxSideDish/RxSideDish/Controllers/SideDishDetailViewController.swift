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
      
    viewModel.sideDishDetail
      .observe(on: MainScheduler.instance)
      .do { _ = $0.thumbImages.map { (string) -> Void in
        let imageView = UIImageView()
        imageView.setupImage(with: string)
        imageView.configureSize(ratio: 0.75)
        self.imageStackView.addArrangedSubview(imageView)
      }}
      .subscribe(onNext: { _ in })
      .disposed(by: disposeBag)
    
    viewModel.sideDishDetail
      .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
      .map { $0.detailSection.compactMap(self.transform) }
      .observe(on: MainScheduler.instance)
      .do { $0.forEach {
        let imageView = UIImageView(image: $0)
        imageView.configureSize(ratio: $0.ratio)
        self.detailImageStackView.addArrangedSubview(imageView)
      }}
      .subscribe(onNext: { _ in })
      .disposed(by: disposeBag)
  
    detailView.plus.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        self.viewModel.count.accept(self.viewModel.count.value + 1)
      })
      .disposed(by: disposeBag)
    
    detailView.minus.rx.tap
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        let count = self.viewModel.count.value
        if count > 1 { self.viewModel.count.accept(count - 1) }
      })
      .disposed(by: disposeBag)
    
    viewModel.count
      .asDriver()
      .map { String($0) }
      .drive { [weak self] in
        guard let self = self else { return }
        self.detailView.quantity.text = $0 }
      .disposed(by: disposeBag)
  }
}

extension UIImage {
  var ratio: CGFloat {
    size.height / size.width
  }
}
