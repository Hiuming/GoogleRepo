//
//  GoogleRepoUseCase.swift
//  GoogleRepo
//
//  Created by Huynh Minh Hieu on 25/09/2024.
//

import Foundation
import Resolver
import RxSwift

protocol GoogleRepoUseCaseProtocol {
    func getRepo() -> Observable<RepoModel?>
    func getItemRepo(page:Int) -> Observable<[RepoItem]>
}


class GoogleRepoUseCase: GoogleRepoUseCaseProtocol {

    @Injected(container: .services)
    private var repository: GoogleRepoRepositoryProtocol
    
    func getRepo() -> Observable<RepoModel?> {
        self.repository.getRepo()
    }
    
    func getItemRepo(page: Int) -> RxSwift.Observable<[RepoItem]> {
        self.repository.getRepoItem(page: page)
    }
    
    
}
