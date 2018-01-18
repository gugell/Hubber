//
//  GitHubAPI.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/18/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import Moya

public enum GitHub {
    
    case Token(username: String, password: String)
    case RepoSearch(query: String, page:Int)
    case TrendingReposSinceLastWeek(language: String, page:Int)
    case Repo(fullname: String)
    case RepoReadMe(fullname: String)
    case Pulls(fullname: String)
    case Issues(fullname: String)
    case Commits(fullname: String)
    case User
}


extension GitHub: TargetType {
    
    public var headers: [String : String]? {
        return nil
    }
    
    public var baseURL: URL { return URL(string: "https://api.github.com")! }
    
    public var path: String {
        switch self {
        case .Token(_, _):
            return "/authorizations"
        case .RepoSearch(_,_),
             .TrendingReposSinceLastWeek(_,_):
            return "/search/repositories"
        case .Repo(let fullname):
            return "/repos/\(fullname)"
        case .RepoReadMe(let fullname):
            return "/repos/\(fullname)/readme"
        case .Pulls(let fullname):
            return "/repos/\(fullname)/pulls"
        case .Issues(let fullname):
            return "/repos/\(fullname)/issues"
        case .Commits(let fullname):
            return "/repos/\(fullname)/commits"
        case .User:
            return "/user"
            
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .Token(_, _):
            return .post
        case .RepoSearch(_),
             .TrendingReposSinceLastWeek(_,_),
             .Repo(_),
             .RepoReadMe(_),
             .Pulls(_),
             .Issues(_),
             .Commits(_),
             .User:
            return .get
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .Token(_, _):
            return [
                "scopes": ["public_repo", "user"],
                "note": "(\(NSDate()))"
            ]
        case .Repo(_),
             .RepoReadMe(_),
             .User,
             .Pulls,
             .Issues,
             .Commits:
            return nil
        case .RepoSearch(let query,let page):
            return ["q": query.urlEscaped,"page":page]
        case .TrendingReposSinceLastWeek(let language,let page):
            let lastWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return ["q" :"language:\(language) " + "created:>" + formatter.string(from: lastWeek!),
                    "sort" : "stars",
                    "order" : "desc",
                    "page":page
            ]
        }
    }
    
    var multipartBody: [MultipartFormData]? {
        return nil
    }
    
    public var parameterEncoding: ParameterEncoding {
        
        switch self {
        case .Token(_, _):
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
        
    }
    
    public var task: Task {
        guard let parameters = self.parameters else { return .requestPlain }
        return .requestParameters(parameters: parameters, encoding: self.parameterEncoding)
    }
    
    public var sampleData: Data { return Data() }
    
}
