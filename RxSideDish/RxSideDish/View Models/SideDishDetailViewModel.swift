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
  
  private let repositoryService: RepositoryService<SideDishDetailDTO>
  
  private let disposeBag = DisposeBag()
  
  let sideDish: BehaviorRelay<SideDish>
  
  let subject = PublishSubject<SideDishDetail>()
  
  let thumbnail = PublishSubject<Data>()
  let detailImage = PublishSubject<Data>()
  
  init(
    repositoryService: RepositoryService<SideDishDetailDTO>,
    model: SideDish) {
    self.repositoryService = repositoryService
    self.sideDish = .init(value: model)
    self.load(model.detailHash)
  }
  
  private func load(_ id: String) {
    repositoryService.fetch(.detail(id))
      .map { $0.data }
      .subscribe(onNext: {
        self.subject.onNext($0)
        self.fetch(images: $0.thumbImages, subsriber: self.thumbnail)
        self.fetch(images: $0.detailSection, subsriber: self.detailImage)
      })
      .disposed(by: disposeBag)
  }
  
  func fetch(images: [String], subsriber: PublishSubject<Data>) {
    var iterator = images.makeIterator()
    while let image = iterator.next() {
      self.repositoryService.fetch(image)
        .subscribe(subsriber)
        .disposed(by: self.disposeBag)
    }
  }
}
