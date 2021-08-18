//
//  SideDishViewModel.swift
//  RxSideDish
//
//  Created by Ador on 2021/07/31.
//

import Foundation
import RxSwift
import UIKit.UITableView

protocol ViewModelType {
  var repositoryService: RepositoryServiceType { get }
  func load()
}

final class SideDishViewModel: NSObject {
  
  private let repositoryService: RepositoryServiceType
  
  private var disposeBag = DisposeBag()
  
  private var sections: [SectionModel]
  
  var sectionUpdated = PublishSubject<IndexSet>()
  
  init(
    repositoryService: RepositoryServiceType = SideDishRepositoryService(sessionManager: SessionManager.shared)) {
    self.repositoryService = repositoryService
    var sections: [SectionModel] = []
    Category.allCases.forEach { category in
      sections.append(.init(header: "", category: category, items: []))
    }
    self.sections = sections
  }
  
  func load() {
    let endpoints: [Endpoint.Path] = [.main, .soup, .side]
    endpoints.enumerated().forEach { (index, path) in
      repositoryService.fetch(endpoint: path, decodingType: SideDishes.self)
        .subscribe(onNext: { [weak self] data in
          guard let self = self else { return }
          let items = data.body
          self.sections[index].header = self.sections[index].category.rawValue
          self.sections[index].items = items
          self.sectionUpdated.onNext(IndexSet(integer: index))
        })
        .disposed(by: disposeBag)
    }
  }
  
  func header(at section: Int) -> String {
    sections[section].header
  }
    
  func sideDish(at index: IndexPath) -> SideDish {
    sections[index.section].items[index.row]
  }
}

extension SideDishViewModel: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    3
  }
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    sections[section].items.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard
      let cell = tableView.dequeueReusableCell(
        withIdentifier: SideDishTableViewCell.identifier,
        for: indexPath) as? SideDishTableViewCell
    else {
      return SideDishTableViewCell()
    }
    let data = sections[indexPath.section].items[indexPath.row]
    cell.configure(data)
    cell.thumbnail.setupImage(with: data.image)
    return cell
  }
}
