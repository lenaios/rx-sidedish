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
  
  enum Category: Int, CaseIterable {
    case main = 0
    case soup
    case side
  }
  
  private let repoService: RepositoryService
  
  private var disposeBag = DisposeBag()
  
  var subject = PublishSubject<[SectionModel]>()
  
  private var sections: [SectionModel] = [] {
    didSet {
      sections.sort { $0.category < $1.category }
    }
  }
  
  init(repoService: RepositoryService) {
    self.repoService = repoService
  }
  
  func load() {
    repoService.fetch(.main)
      .subscribe { event in
        if let items = event.element?.body {
          let data = SectionModel(
            model: "메인",
            category: Category.main.rawValue,
            items: items)
          self.sections.append(data)
          self.subject.onNext(self.sections)
        }
      }.disposed(by: disposeBag)
    
    repoService.fetch(.soup)
      .subscribe { event in
        if let items = event.element?.body {
          let data = SectionModel(
            model: "국 / 찌개",
            category: Category.main.rawValue,
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
            category: Category.main.rawValue,
            items: items)
          self.sections.append(data)
          self.subject.onNext(self.sections)
        }
      }.disposed(by: disposeBag)
  }
}

struct SectionModel {
  var model: String
  var category: Int
  var items: [SideDish]
}

extension SectionModel: SectionModelType {
  init(original: SectionModel, items: [SideDish]) {
    self = original
    self.items = items
  }
}
