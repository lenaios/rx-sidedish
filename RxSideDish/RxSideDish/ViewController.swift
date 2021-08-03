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
    
    tableView.dataSource = self
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

extension ViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.sections[section].items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SideDishTableViewCell else { return SideDishTableViewCell() }
    let data = viewModel.sections[indexPath.section].items[indexPath.row]
    cell.confiugre(data)
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return viewModel.sections[section].header
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = SideDishTableViewHeader()
    let title = viewModel.sections[section].header
    header.configure(title: title)
    return header
  }
}
