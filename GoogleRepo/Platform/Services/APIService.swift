//
//  APIService.swift
//  GoogleRepo
//
//  Created by Huynh Minh Hieu on 26/09/2024.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire
import ObjectMapper
import SwiftyBeaver

final class APIService {
    static let shared : APIService = {
        let instance = APIService()
        return instance
    }()
    
    private let bag = DisposeBag()
    private let session = NetworkManager.session
    private let defaultSession = Session.default
    
    private func cancelRequestURL(url: URL, requireToken: Bool) {
        if requireToken {
            session.request(url).cancel()
        }
        else {
            defaultSession.request(url).cancel()
        }
    }
    
    
    func request<T: Mappable>(nonBaseResponse input: APIInputBase) -> Single<T> {
        
        print("\n------------REQUEST INPUT")
        print("link:", input.url)
        print("param:", input.parameters ?? "No parameters")
        print("method:", input.method.rawValue)
        print("header:", input.headers ?? "No headers")
        print("------------ END REQUEST INPUT\n")
        
        return Single.create { single in
            
            let session = input.requireToken ? self.session.rx : self.defaultSession.rx
            
            session
                .request(input.method,
                         input.url,
                         parameters: input.parameters,
                         encoding: input.encoding,
                         headers: input.headers)
                .subscribe(on: MainScheduler.asyncInstance)
                .validate(statusCode: 200..<500)
                .observe(on: ConcurrentDispatchQueueScheduler.init(queue: .global(qos: .background)))
                .responseJSON()
                .observe(on: ConcurrentDispatchQueueScheduler.init(queue: .global(qos: .background)))
                .subscribe(onNext: { dataRequest in
                    switch dataRequest.result {
                    case .success(let value):
                        if let dict = value as? [String: Any], let json = T.init(JSON: dict) {
                            if dataRequest.response?.statusCode == 200 {
                                single(.success(json))
                            }
                            else {
                                single(.failure(APIError.error(code: dataRequest.response?.statusCode ?? 0, message: "Error")))
                            }
                        }
                        else {
                            single(.failure(APIError.invalidResponseData(data: value)))
                        }
                    case .failure(let error):
                        single(.failure(error))
                    }
                }, onError: { error in
                    single(.failure(error))
                }, onCompleted: {
                    
                }, onDisposed: {
                    
                })
                .disposed(by: self.bag)
            
            return Disposables.create {
                self.cancelRequestURL(url: input.url, requireToken: input.requireToken)
            }
        }
    }
    
    
    func requestArray<T: Mappable>(nonBaseResponse input: APIInputBase) -> Single<[T]> {
            
            print("\n------------REQUEST INPUT")
            print("link:", input.url)
            print("param:", input.parameters ?? "No parameters")
            print("method:", input.method.rawValue)
            print("header:", input.headers ?? "No headers")
            print("------------ END REQUEST INPUT\n")
            
            return Single.create { single in
                
                let session = input.requireToken ? self.session.rx : self.defaultSession.rx
                
                session
                    .request(input.method,
                             input.url,
                             parameters: input.parameters,
                             encoding: input.encoding,
                             headers: input.headers)
                    .subscribe(on: MainScheduler.asyncInstance)
                    .validate(statusCode: 200..<500)
                    .observe(on: ConcurrentDispatchQueueScheduler.init(queue: .global(qos: .background)))
                    .responseJSON()
                    .observe(on: ConcurrentDispatchQueueScheduler.init(queue: .global(qos: .background)))
                    .subscribe(onNext: { dataRequest in
                        switch dataRequest.result {
                        case .success(let value):
                            if let dict = value as? [[String: Any]] {
                                let json = Mapper<T>().mapArray(JSONArray: dict)
                                if dataRequest.response?.statusCode == 200 {
                                    single(.success(json))
                                }
                                else {
                                    single(.failure(APIError.error(code: dataRequest.response?.statusCode ?? 0, message: "Error")))
                                }
                            }
                            else {
                                single(.failure(APIError.invalidResponseData(data: value)))
                            }
                        case .failure(let error):
                            single(.failure(error))
                        }
                    }, onError: { error in
                        single(.failure(error))
                    }, onCompleted: {

                    }, onDisposed: {

                    })
                    .disposed(by: self.bag)
                
                return Disposables.create {
                    self.cancelRequestURL(url: input.url, requireToken: input.requireToken)
                }
            }
        }
    
    
}


struct NetworkManager {
    
    static let kRequestTimeOut: TimeInterval = 30
    
    static let session: Session = {
        let configuration: URLSessionConfiguration = {
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = kRequestTimeOut
            config.timeoutIntervalForResource = kRequestTimeOut
            config.httpMaximumConnectionsPerHost = 10
            return config
        }()
        let session = Session(configuration: configuration, serverTrustManager: nil)
        return session
    }()
}
