//
//  SideDishViewModel.swift
//  RxSideDish
//
//  Created by Ador on 2021/07/31.
//

import Foundation
import RxSwift
import UIKit.UITableView

final class SideDishViewModel: NSObject {
  
  private let repoService: RepositoryService
  
  private var disposeBag = DisposeBag()
  
  private var sections: [SectionModel]
  
  var subject = PublishSubject<IndexSet>()
  
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
          self.sections[category].header = "모두가 좋아하는 메인요리"
          self.subject.onNext(IndexSet(integer: category))
        }
      }.disposed(by: disposeBag)
    
    repoService.fetch(.soup)
      .subscribe { event in
        if let items = event.element?.body {
          let category = Category.soup.rawValue
          self.sections[category].items = items
          self.sections[category].header = "정성이 담긴 뜨끈뜨끈 국물요리"
          self.subject.onNext(IndexSet(integer: category))
        }
      }.disposed(by: disposeBag)
    
    repoService.fetch(.side)
      .subscribe { event in
        if let items = event.element?.body {
          let category = Category.side.rawValue
          self.sections[category].items = items
          self.sections[category].header = "식탁을 풍성하게 하는 밑반찬"
          self.subject.onNext(IndexSet(integer: category))
        }
      }.disposed(by: disposeBag)
  }
  
  func header(at section: Int) -> String {
    return sections[section].header
  }
}

extension SideDishViewModel: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
    return sections[section].items.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = tableView.dequeueReusableCell(
            withIdentifier: "Cell",
            for: indexPath) as? SideDishTableViewCell else {
      return SideDishTableViewCell()
    }
    let data = sections[indexPath.section].items[indexPath.row]
    cell.confiugre(data)
    return cell
  }
}
