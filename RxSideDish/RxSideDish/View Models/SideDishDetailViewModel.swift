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
  
  let sideDishDetail = PublishRelay<SideDishDetail>()
  
  let count = BehaviorRelay<Int>(value: 1)
  
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
        self.sideDishDetail.accept($0)
      })
      .disposed(by: disposeBag)
  }
}
