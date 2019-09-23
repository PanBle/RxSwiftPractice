//
//  RepositoryNetworkModel.swift
//  RxSwiftPractice
//
//  Created by KM_TM on 23/09/2019.
//  Copyright © 2019 KM_TM. All rights reserved.
//

import Foundation
import ObjectMapper
import RxAlamofire
import RxCocoa
import RxSwift

struct RepositoryNetworkModel {
    
    lazy var rx_repositeries:Driver<[SRepository]> = self.fetchRepositories()
    private var repositoryName: Observable<String?>
    
    init(withNameObservable nameObservable: Observable<String?>) {
        self.repositoryName = nameObservable
    }
    
    private func fetchRepositories() -> Driver<[SRepository]> {
        return repositoryName
            .subscribeOn(MainScheduler.instance)
            .do(onNext: {response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            })
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest{ text in
                return RxAlamofire
                .requestJSON(.get, "https://api.github.com/users/\(String(describing: text!))/repos")
                .debug()
                .catchError{error in
                        return Observable.never()
                }
        }
        .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .map{(response, json) -> [SRepository] in
            if let repos = Mapper<SRepository>().mapArray(JSONObject: json) {
                return repos
            } else {
                return []
            }
        }
        .observeOn(MainScheduler.instance)
        .do(onNext: {response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        })
        .asDriver(onErrorJustReturn: [])
    }
}
