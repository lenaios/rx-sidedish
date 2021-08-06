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
  
  private let repositoryService: RepositoryService<Response>
    = RepositoryService(sessionManager: SessionManager.shared)
  
  private lazy var viewModel = SideDishViewModel(repositoryService: repositoryService)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = viewModel
    tableView.delegate = self
    
    bind()
    
    viewModel.load()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
  }
  
  private func bind() {
    tableView.rx.itemSelected
      .asDriver()
      .drive { self.showDetail(for: $0) }
      .disposed(by: disposeBag)

    viewModel.subject
      .subscribe(onNext: { data in
        DispatchQueue.main.sync {
          self.tableView.reloadSections(data, with: .automatic)
        }
      })
      .disposed(by: disposeBag)
  }
}

private extension ViewController {
  func showDetail(for indexPath: IndexPath) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    guard
      let detailViewController = storyboard.instantiateViewController(
        withIdentifier: SideDishDetailViewController.identifier) as? SideDishDetailViewController else {
      return
    }
    let sideDish = viewModel.sideDish(at: indexPath)
    let service = RepositoryService<SideDishResponse>(sessionManager: SessionManager.shared)
    detailViewController.viewModel = SideDishDetailViewModel(repositoryService: service, model: sideDish)
    navigationController?.pushViewController(detailViewController, animated: true)
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
