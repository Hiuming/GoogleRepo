//
//  ViewModel.swift
//  GoogleRepo
//
//  Created by Huynh Minh Hieu on 26/09/2024.
//

import Foundation
import RxSwift
import Resolver
import RxCocoa

class ViewModel: BaseViewModel, ViewModelType {
    @Injected(container: .services)
    private var useCase: GoogleRepoUseCaseProtocol
    
    struct Input {
        let trigger: Observable<Void>
        let triggerLoadItem: Observable<Void>
    }
    
    struct Output {
        let repo: Driver<RepoModel?>
        let repoItemList: Driver<[RepoItem]>
        let loading: Observable<Bool>
    }
    private var page: Int = 1
    
    func transform(_ input: Input) -> Output {
        let triggerLoad = input.trigger
        let repoModel = BehaviorRelay<RepoModel?>(value: nil)
        let repoList = BehaviorRelay<[RepoItem]>(value: [])
        
        triggerLoad.flatMap { [unowned self] in
            self.loading.accept(true)
            return useCase.getRepo()
        }
        .subscribe { repo in
            repoModel.accept(repo)
            self.loading.accept(false)
        }
        .disposed(by: self.disposeBag)
        
        input.triggerLoadItem.flatMapLatest { [unowned self] in
            return useCase.getItemRepo(page: self.page)
        }
        .subscribe { repoListResult in
            var currentModelList: [RepoItem] = [] // First page
            if self.page > 0 {
                currentModelList = repoList.value
            }
            currentModelList.append(contentsOf: repoListResult)
            repoList.accept(currentModelList)
            self.page = self.page + 1
        }
        .disposed(by: self.disposeBag)
        return Output(repo: repoModel.asDriver(), repoItemList: repoList.asDriver(),loading: self.loading.asObservable())
    }
    
}
