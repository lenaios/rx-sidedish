//
//  SideDishViewModel.swift
//  RxSideDish
//
//  Created by Ador on 2021/07/31.
//

import Foundation
import RxSwift
import RxDataSources

final class SideDishViewModel {
  
  typealias Section = SectionModel<String, SideDish>
  
  private let repoService: RepositoryService
  
  private var disposeBag = DisposeBag()
  
  private var sections: [Section] = []
  
  var subject = PublishSubject<[Section]>()
  
  init(repoService: RepositoryService) {
    self.repoService = repoService
  }
  
  func load() {
    repoService.fetch(.main)
      .subscribe { event in
        if let items = event.element?.body {
          let data = SectionModel(
            model: "메인",
            items: items)
          self.sections.append(data)
          self.subject.onNext(self.sections)
        }
      }.disposed(by: disposeBag)
    
    repoService.fetch(.side)
      .subscribe { event in
        if let items = event.element?.body {
          let data = SectionModel(
            model: "반찬",
            items: items)
          self.sections.append(data)
          self.subject.onNext(self.sections)
        }
      }.disposed(by: disposeBag)
  }
}
