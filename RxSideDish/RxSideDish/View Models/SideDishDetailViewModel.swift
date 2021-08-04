//
//  SideDishDetailViewModel.swift
//  RxSideDish
//
//  Created by Ador on 2021/08/03.
//

import Foundation
import RxSwift

class SideDishDetailViewModel {
  
  private let repositoryService: RepositoryService<SideDishResponse>
  
  private let disposeBag = DisposeBag()
  
  let subject = PublishSubject<SideDishDetail>()
  
  let imagePublisher = PublishSubject<Data>()
  
  var sideDish: SideDish
  
  init(
    repositoryService: RepositoryService<SideDishResponse>,
    model: SideDish) {
    self.repositoryService = repositoryService
    self.sideDish = model
    self.load(model.detailHash)
  }
  
  private func load(_ id: String) {
    repositoryService.fetch(.detail(id))
      .subscribe { event in
        if let element = event.element {
          self.subject.onNext(element.data)
        }
      }.disposed(by: disposeBag)
  }
  
  func fetch(images: [String]) {
    images.forEach { image in
      repositoryService.fetch(image)
        .subscribe { event in
          if let element = event.element {
            self.imagePublisher.onNext(element)
          }
        }.disposed(by: disposeBag)
    }
  }
}
