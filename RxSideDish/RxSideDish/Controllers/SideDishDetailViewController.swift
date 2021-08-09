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
      .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
      .map { $0.thumbImages }
      .subscribe(onNext: {
        $0.forEach { string in
          let url = URL(string: string)!
          do {
            let data = try Data(contentsOf: url)
            DispatchQueue.main.async {
              let image = UIImage(data: data)!
              let imageView = UIImageView(image: image)
              imageView.configureSize(ratio: 0.75)
              self.imageStackView.addArrangedSubview(imageView)
            }
          } catch {
            
          }
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.sideDishDetail
      .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
      .map { $0.detailSection }
      .subscribe(onNext: {
        $0.forEach { string in
          let url = URL(string: string)!
          do {
            let data = try Data(contentsOf: url)
            DispatchQueue.main.async {
              let image = UIImage(data: data)!
              let imageView = UIImageView(image: image)
              imageView.configureSize(ratio: image.ratio)
              self.detailImageStackView.addArrangedSubview(imageView)
            }
          } catch {
            
          }
        }
      })
      .disposed(by: disposeBag)
  }
}

extension UIImage {
  var ratio: CGFloat {
    size.height / size.width
  }
}
