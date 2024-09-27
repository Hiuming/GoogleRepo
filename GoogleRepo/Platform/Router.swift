//
//  Router.swift
//  GoogleRepo
//
//  Created by Huynh Minh Hieu on 26/09/2024.
//

import Foundation
import Alamofire

enum APIRouter: APIInputBase {
    
    var headers: HTTPHeaders? {
        switch self {
        case .getRepo:
            return nil
        case .itemRepo(_):
            var header = HTTPHeaders()
            header.add(.accept("application/vnd.github+json"))
            header.add(name: "X-GitHub-Api-Version", value: "2022-11-28")
            return header
            
        }
    }
    
    var baseURL: String {
        return "https://api.github.com"
    }
    
    var url: URL {
        let baseURL = URL.init(string: baseURL+path)!
        return baseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .getRepo:
            return .get
        case .itemRepo:
            return .get
        }
    }
    
    var encoding: ParameterEncoding {
        return method == .get ? URLEncoding.default : JSONEncoding.default
    }
    
    
    var parameters: [String : Any]? {
        switch self {
        case .getRepo:
            return [:]
        case .itemRepo(let page):
            return ["page" : page, "per_page" : 10]
        }
    }
    
    var path: String {
        switch self {
        case .getRepo:
            return "/orgs/google"
        case .itemRepo:
            return "/orgs/google/repos"
        }
    }
    
    var requireToken: Bool {
        switch self {
        case .getRepo:
            return false
        case .itemRepo:
            return false
        }
    }
    
    
    //declare route case
    case getRepo
    case itemRepo(page: Int)
}
