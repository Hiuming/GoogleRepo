//
//  Resolver+Extension.swift
//  GoogleRepo
//
//  Created by Huynh Minh Hieu on 25/09/2024.
//

import Resolver

extension Resolver: ResolverRegistering {
    static let services = Resolver.root
    
    public static func registerAllServices() {
        self.registerUseCase()
        self.registerRepository()
    }
    
    private static func registerUseCase() {
        Resolver.services.register { GoogleRepoUseCase() as GoogleRepoUseCaseProtocol }.scope(.application)
    }
    
    private static func registerRepository() {
        Resolver.services.register { GoogleRepoRepository() as GoogleRepoRepositoryProtocol }.scope(.application)
    }
}
