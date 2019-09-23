//
//  IssueTrackerModel.swift
//  RxSwiftPractice
//
//  Created by KM_TM on 06/09/2019.
//  Copyright © 2019 KM_TM. All rights reserved.
//

import Foundation
import Moya
import Mapper
import Moya_ModelMapper
import RxOptional
import RxSwift

struct IssueTrackerModel {
    let provider:MoyaProvider<GitHub>
    let repositoryName:Observable<String>
    
    func trackIssues() -> Observable<[Issue]> {
        return repositoryName
            .observeOn(MainScheduler.instance)
            .flatMapLatest { name -> Observable<Repository?> in
                print("Name: \(name)")
                return self
                    .findRepository(name)
            }
            .flatMapLatest { repository -> Observable<[Issue]?> in
                guard let repository = repository else { return Observable.just(nil) }
                
                print("Repository: \(repository.fullName)")
                return self.findIssues(repository)
            }
            .replaceNilWith([])
    }
    
    internal func findIssues(_ repository: Repository) -> Observable<[Issue]?> {
        return self.provider
        .rx.request(GitHub.issues(repositoryFullName: repository.fullName))
        .debug()
        .mapOptional(to: [Issue].self)
        .asObservable()
    }
    
    internal func findRepository(_ name: String) -> Observable<Repository?> {
       return self.provider
        .rx.request(GitHub.repo(fullName: name))
        .debug()
        .mapOptional(to: Repository.self)
        .asObservable()
    }
}
