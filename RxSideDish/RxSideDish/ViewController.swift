//
//  ViewController.swift
//  RxSideDish
//
//  Created by Ador on 2021/07/28.
//

import UIKit
import RxSwift
import RxDataSources

class ViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private let disposeBag = DisposeBag()
  
  private let repoService = RepositoryService(sessionManager: SessionManager())
  
  private lazy var viewModel = SideDishViewModel(repoService: repoService)
  
  private let dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(
    configureCell: { (_, tableView, indexPath, element) in
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
      cell.textLabel?.text = element.title
      return cell
    },
    titleForHeaderInSection: { dataSource, sectionIndex in
      return dataSource[sectionIndex].model
    }
  )
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewModel.subject
      .bind(to: tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: disposeBag)
    
    viewModel.load()
  }
}
