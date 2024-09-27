//
//  RepoModel.swift
//  GoogleRepo
//
//  Created by Huynh Minh Hieu on 25/09/2024.
//

import Foundation
import ObjectMapper


class RepoModel: Mappable {
    var login: String?
    var id: Int?
    var nodeid: String?
    var url: String?
    var reposurl: String?
    var eventsurl: String?
    var hooksurl: String?
    var issuesurl: String?
    var membersurl: String?
    var publicMembersurl: String?
    var avatarurl: String?
    var description: String?
    var name: String?
    var company: String?
    var blog: String?
    var location: String?
    var email: String?
    var twitterUsername: String?
    var isVerified: Bool?
    var hasOrganizationProjects: Bool?
    var hasRepositoryProjects: Bool?
    var publicRepos: Int?
    var publicGists: Int?
    var followers: Int?
    var following: Int?
    var htmlurl: String?
    var createdAt: Date?
    var updatedAt: Date?
    var archivedAt: String?
    var type: String?
    
    required init?(map: Map) {
        
    }

    
    
    func mapping(map: Map) {
        login <- map["login"]
        id <- map["id"]
        nodeid <- map["node_id"]
        url <- map["url"]
        reposurl <- map["repos_url"]
        eventsurl <- map["events_url"]
        hooksurl <- map["hooks_url"]
        issuesurl <- map["issues_url"]
        membersurl <- map["members_url"]
        publicMembersurl <- map["public_members_url"]
        avatarurl <- map["avatar_url"]
        description <- map["description"]
        name <- map["name"]
        company <- map["company"]
        blog <- map["blog"]
        location <- map["location"]
        email <- map["email"]
        twitterUsername <- map["twitter_username"]
        isVerified <- map["is_verified"]
        hasOrganizationProjects <- map["has_organization_projects"]
        hasRepositoryProjects <- map["has_repository_projects"]
        publicRepos <- map["public_repos"]
        publicGists <- map["public_gists"]
        followers <- map["followers"]
        following <- map["following"]
        htmlurl <- map["html_url"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        archivedAt <- map["archived_at"]
        type <- map["type"]
    }
    
}
