//
//  GitHubAPIManager.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/18/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import RxSwift
import Moya

public var GithubProvider = RxMoyaProvider<GitHub>(
    endpointClosure:endpointClosure,
    requestClosure:requestClosure,
    stubClosure:stubClosure,
    plugins: [NetworkLoggerPlugin.init(verbose: false, cURL: false, output: nil, requestDataFormatter: nil, responseDataFormatter: JSONResponseDataFormatter)]
)

let requestClosure = { (endpoint: Endpoint<GitHub>, done: MoyaProvider.RequestResultClosure) in
    var request: URLRequest = endpoint.urlRequest!
    //request.httpShouldHandleCookies = false
    done(.success(request))
}

let endpointClosure = { (target: GitHub) -> Endpoint<GitHub> in
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)

    switch target {
    case .Token(let userString, let passwordString):
        let credentialData = "\(userString):\(passwordString)".data(using: String.Encoding.utf8)
        let base64Credentials = credentialData?.base64EncodedString()
        return defaultEndpoint.adding(newHTTPHeaderFields: ["Authorization": "Basic \(base64Credentials!)"])

    default:
        let authManager = AuthManager.shared
        guard let token = authManager.token else { return defaultEndpoint }
        return defaultEndpoint.adding(newHTTPHeaderFields: ["Authorization": "token \(token)"])
    }

}

let stubClosure = { (target: GitHub) -> Moya.StubBehavior in
    switch target{
        case .RepoSearch:
            return isRunningTests  ? .immediate : .never
        default: return .never
    }
}

public func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

public class GitHubAPIManager: GitHubAPI {

    static let sharedAPI = GitHubAPIManager()

    public func signin(_ username: String, password: String) -> Observable<Bool> {
        return GithubProvider.request(GitHub.Token(username: username, password: password))
            .mapObject(Authorizations.self)
            .observeOn(MainScheduler.instance)
            .flatMapLatest { authorization -> Observable<Bool> in
                if authorization.token == nil {
                    return Observable.just(false)
                } else {
                    let authManager = AuthManager.shared
                    authManager.token = authorization.token
                    return Observable.just(true)
                }
        }
    }

    public func repositories(_ keyword: String, page: Int) -> Observable<[Repository]> {
        return GithubProvider.request(GitHub.RepoSearch(query: keyword, page:page))
            .mapObject(Repositories.self)
            .observeOn(MainScheduler.instance)
            .flatMapLatest { repositories -> Observable<[Repository]> in
                guard let items = repositories.items else {
                    return Observable.empty()
                }
                return Observable.just(items)
        }

    }

    public func users(_ keyword: String) -> Observable<[User]> {

        return GithubProvider.request(GitHub.usersSearch(query: keyword))
            .mapObject(Users.self)
            .observeOn(MainScheduler.instance)
            .flatMapLatest { users -> Observable<[User]> in
                guard let items = users.items else {
                    return Observable.empty()
                }
                return Observable.just(items)
        }
    }

    public func repositories(_ username: String) -> Observable<[Repository]> {
        return GithubProvider.request(GitHub.Repos(fullname: username))
            .mapArray(Repository.self)
            .observeOn(MainScheduler.instance)
            .flatMapLatest { repositories -> Observable<[Repository]> in
                return Observable.just(repositories)
        }
    }

    public func usersList(since: Int?) -> Observable<[User]> {
        return GithubProvider.request(GitHub.Users(since:since))
            .mapArray(User.self)
            .observeOn(MainScheduler.instance)
            .flatMapLatest { users -> Observable<[User]> in
                return Observable.just(users)
        }
    }

    public func recentRepositories(_ language: String, page: Int) -> Observable<[Repository]> {
        return GithubProvider.request(GitHub.TrendingReposSinceLastWeek(language: language, page: page))
            .mapObject(Repositories.self)
            .observeOn(MainScheduler.instance)
            .flatMapLatest { repositories -> Observable<[Repository]> in
                guard let items = repositories.items else {
                    return Observable.empty()
                }
                return Observable.just(items)
        }

    }

    public func profile() -> Observable<User> {
        return GithubProvider.request(GitHub.User)
            .mapObject(User.self)
            .observeOn(MainScheduler.instance)
            .flatMapLatest { user -> Observable<User> in
                return Observable.just(user)
        }
    }

    public func profile(by userId: String) -> Observable<User> {
        return GithubProvider.request(GitHub.Profile(userId))
            .mapObject(User.self)
            .observeOn(MainScheduler.instance)
            .flatMapLatest { user -> Observable<User> in
                return Observable.just(user)
        }
    }

}

var isRunningTests: Bool {
    return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
}
