//
//  SideDishViewModel.swift
//  RxSideDish
//
//  Created by Ador on 2021/07/31.
//

import Foundation
import RxSwift

final class SideDishViewModel {
  
  private let repoService: RepositoryService
  
  private var disposeBag = DisposeBag()
  
  var subject = PublishSubject<IndexSet>()
  var sections: [SectionModel]
  
  init(repoService: RepositoryService) {
    var sections:[SectionModel] = []
    Category.allCases.forEach { category in
      sections.append(SectionModel(header: "", category: category, items: []))
    }
    self.sections = sections
    self.repoService = repoService
  }
  
  func load() {
    repoService.fetch(.main)
      .subscribe { event in
        if let items = event.element?.body {
          let category = Category.main.rawValue
          self.sections[category].items = items
          self.sections[category].header = "메인"
          self.subject.onNext(IndexSet(integer: category))
        }
      }.disposed(by: disposeBag)
    
    repoService.fetch(.soup)
      .subscribe { event in
        if let items = event.element?.body {
          let category = Category.soup.rawValue
          self.sections[category].items = items
          self.sections[category].header = "국"
          self.subject.onNext(IndexSet(integer: category))
        }
      }.disposed(by: disposeBag)
    
    repoService.fetch(.side)
      .subscribe { event in
        if let items = event.element?.body {
          let category = Category.side.rawValue
          self.sections[category].items = items
          self.sections[category].header = "반찬"
          self.subject.onNext(IndexSet(integer: category))
        }
      }.disposed(by: disposeBag)
  }
}
