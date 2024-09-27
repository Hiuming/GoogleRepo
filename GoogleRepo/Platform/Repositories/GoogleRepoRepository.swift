//
//  GoogleRepoRepository.swift
//  GoogleRepo
//
//  Created by Huynh Minh Hieu on 25/09/2024.
//

import Foundation
import RxSwift
import Alamofire


protocol GoogleRepoRepositoryProtocol {
    func getRepo() -> Observable<RepoModel?>
    func getRepoItem(page: Int) -> Observable<[RepoItem]>
}

class GoogleRepoRepository: GoogleRepoRepositoryProtocol {
    func getRepo() -> Observable<RepoModel?> {
        return APIService
            .shared
            .request(nonBaseResponse: APIRouter.getRepo)
            .compactMap({ (response: RepoModel) -> RepoModel in
                return response
            })
            .asObservable()
            .catchAndReturn(nil)
            .share()
    }
    
    func getRepoItem(page: Int) -> Observable<[RepoItem]> {
        return APIService
            .shared
            .requestArray(nonBaseResponse: APIRouter.itemRepo(page: page))
            .compactMap({ (response: [RepoItem]) -> [RepoItem] in
                return response
            })
            .asObservable()
            .catchAndReturn([])
            .share()
    }
}
