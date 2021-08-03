//
//  ViewController.swift
//  RxSideDish
//
//  Created by Ador on 2021/07/28.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private let disposeBag = DisposeBag()
  
  private let repoService = RepositoryService(sessionManager: SessionManager())
  
  private lazy var viewModel = SideDishViewModel(repoService: repoService)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = viewModel
    tableView.delegate = self
    
    viewModel.subject
      .subscribe { event in
        DispatchQueue.main.sync {
          if let indexSet = event.element {
            self.tableView.reloadSections(
              indexSet,
              with: .automatic)
          }
        }
      }
      .disposed(by: disposeBag)
    
    viewModel.load()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  
  func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int) -> UIView? {
    let header = SideDishTableViewHeader()
    let title = viewModel.header(at: section)
    header.configure(title: title)
    return header
  }
}
