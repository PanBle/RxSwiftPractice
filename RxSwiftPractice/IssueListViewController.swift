//
//  IssueListViewController.swift
//  RxSwiftPractice
//
//  Created by KM_TM on 06/09/2019.
//  Copyright © 2019 KM_TM. All rights reserved.
//

import Moya
import Moya_ModelMapper
import UIKit
import RxCocoa
import RxSwift

class IssueListViewController: UIViewController {
    
    
    let disposeBag = DisposeBag()
    var provider:MoyaProvider<GitHub>!
    var latestRepository:Observable<String> {
        return searchBar
        .rx.text
        .orEmpty
        .debounce(0.5, scheduler: MainScheduler.instance)
        .distinctUntilChanged()
    }
    var issueTrackerModel: IssueTrackerModel!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRx()
        // Do any additional setup after loading the view.
    }
    
    func setupRx() {
        //provider 생성
        provider = MoyaProvider<GitHub>()
        
        //model생성
        issueTrackerModel = IssueTrackerModel(provider: provider, repositoryName: latestRepository)
        
        //tableView 에 issues들을 bind 한다
        //단한번 바인딩 한 것으로 3개의 테이블 뷰의 데이터 소스를 채움
        issueTrackerModel
            .trackIssues()
            .bind(to: tableView.rx.items(cellIdentifier: "issueCell")) {(index, item, cell) in
                cell.textLabel?.text = item.title}
            .disposed(by: disposeBag)
        //유저가 셀을 클릭했을 때 테이블뷰에 알림
        //그리고 키보드가 있다면 숨기기
        tableView
        .rx.itemSelected
        .subscribe(onNext: {indexPath in
            if self.searchBar.isFirstResponder == true {
                self.view.endEditing(true)
            }
        })
        .disposed(by: disposeBag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
