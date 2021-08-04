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
  
  private let repositoryService: RepositoryService<Response>
  
  private var disposeBag = DisposeBag()
  
  private var sections: [SectionModel]
  
  var subject = PublishSubject<IndexSet>()
  
  init(repositoryService: RepositoryService<Response>) {
    var sections:[SectionModel] = []
    Category.allCases.forEach { category in
      sections.append(SectionModel(header: "", category: category, items: []))
    }
    self.sections = sections
    self.repositoryService = repositoryService
  }
  
  func load() {
    repositoryService.fetch(.main)
      .subscribe { event in
        if let items = event.element?.body {
          let category = Category.main.rawValue
          self.sections[category].items = items
          self.sections[category].header = "모두가 좋아하는 메인요리"
          self.subject.onNext(IndexSet(integer: category))
        }
      }.disposed(by: disposeBag)
    
    repositoryService.fetch(.soup)
      .subscribe { event in
        if let items = event.element?.body {
          let category = Category.soup.rawValue
          self.sections[category].items = items
          self.sections[category].header = "정성이 담긴 뜨끈뜨끈 국물요리"
          self.subject.onNext(IndexSet(integer: category))
        }
      }.disposed(by: disposeBag)
    
    repositoryService.fetch(.side)
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
  
  func id(for index: IndexPath) -> String {
    return sections[index.section].items[index.row].detailHash
  }
  
  func title(at index: IndexPath) -> String {
    return sections[index.section].items[index.row].title
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
