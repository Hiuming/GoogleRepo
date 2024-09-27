//
//  BaseViewModel.swift
//  GoogleRepo
//
//  Created by Huynh Minh Hieu on 26/09/2024.
//

import Foundation
import RxSwift
import RxRelay

class BaseViewModel {
    public let disposeBag = DisposeBag()
    public var loading = BehaviorRelay<Bool>(value: false)
    public var errorBR = BehaviorRelay<NSError?>(value: nil)
}

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
