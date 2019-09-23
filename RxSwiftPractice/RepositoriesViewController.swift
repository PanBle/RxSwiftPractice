//
//  RepositoriesViewController.swift
//  RxSwiftPractice
//
//  Created by KM_TM on 23/09/2019.
//  Copyright © 2019 KM_TM. All rights reserved.
//

import UIKit
import ObjectMapper
import RxAlamofire
import RxCocoa
import RxSwift

class RepositoriesViewController: UIViewController {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var searchBar:UISearchBar!
    let disposeBag = DisposeBag()
    var repositoryNetworkModel: RepositoryNetworkModel!
    
    var rx_searchBarText: Observable<String?> {
        return searchBar
            .rx.text
            .filter {$0!.count > 0}
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
        
    }
    
    func setupRx() {
        repositoryNetworkModel = RepositoryNetworkModel(withNameObservable: rx_searchBarText )
        
        repositoryNetworkModel
        .rx_repositeries
            .drive(tableView.rx.items(cellIdentifier: "repositoryCell", cellType: UITableViewCell.self)) {(_, repository, cell) in
                cell.textLabel?.text = repository.name
            }
        .disposed(by: disposeBag)
        
        repositoryNetworkModel
        .rx_repositeries
        .drive(onNext: {repositories in
            if repositories.count == 0 {
                let alert = UIAlertController(title: ":(", message: "No repositories for this user", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                if self.navigationController?.visibleViewController?.isMember(of: UIAlertController.self) != true {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
        .disposed(by: disposeBag)
    }

}
