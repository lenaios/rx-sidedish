//
//  SideDishDetailViewModel.swift
//  RxSideDish
//
//  Created by Ador on 2021/08/03.
//

import Foundation
import RxSwift
import RxCocoa

class SideDishDetailViewModel {
  
  private let repositoryService: SideDishDetailRepositoryService
  
  private let disposeBag = DisposeBag()
  
  let sideDish: BehaviorRelay<SideDish>
  
  let sideDishDetail = PublishSubject<SideDishDetail>()
  
  let thumbnail = PublishSubject<Data>()
  let detailImage = PublishSubject<Data>()
  
  init(
    repositoryService: SideDishDetailRepositoryService,
    model: SideDish) {
    self.repositoryService = repositoryService
    self.sideDish = .init(value: model)
    self.load(model.detailHash)
  }
  
  private func load(_ id: String) {
    repositoryService.fetch(endpoint: .detail(id))
      .map { $0.data }
      .subscribe(onNext: {
        self.sideDishDetail.onNext($0)
        self.fetch(images: $0.thumbImages, subsriber: self.thumbnail)
        self.fetch(images: $0.detailSection, subsriber: self.detailImage)
      })
      .disposed(by: disposeBag)
  }
  
  func fetch(images: [String], subsriber: PublishSubject<Data>) {
    var iterator = images.makeIterator()
    while let image = iterator.next() {
      self.repositoryService.fetch(url: image)
        .subscribe(subsriber)
        .disposed(by: self.disposeBag)
    }
  }
}
