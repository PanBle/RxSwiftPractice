//
//  ViewController.swift
//  RxSwiftPractice
//
//  Created by KM_TM on 06/09/2019.
//  Copyright © 2019 KM_TM. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
     @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var shownCities = [String]()
    let allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga"] //고정된 api 데이터
    let disposeBag = DisposeBag() // 뷰의 동적해제를 위한 일회용 가방
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityPrototypeCell", for: indexPath)
        cell.textLabel?.text = shownCities[indexPath.row]
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar
            .rx.text // RxCocoa의 Observable 속성
            .orEmpty // 옵셔널이 아니도록 만듭니다.
            .debounce(0.5, scheduler:  MainScheduler.instance) //0.5초의 대기시간
            .distinctUntilChanged() //새로운 값과 이전의 값을 비교
            .subscribe(onNext: { [unowned self] query in // 이 부분 덕분에 모든 새로운 값에 대한 알림을 받을 수 있습니다.
                self.shownCities = self.allCities.filter { $0.hasPrefix(query) } // 도시를 찾기 위한 “API 요청” 작업을 합니다.
                self.tableView.reloadData() // 테이블 뷰를 다시 불러옵니다.
            }).disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }


}

