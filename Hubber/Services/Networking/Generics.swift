//
//  Generics.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/18/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import Foundation


import RxSwift
import RxCocoa


public enum ValidationResult {
    case ok(message: String)
    case empty
    case validating
    case failed(message: String)
}

public protocol GitHubAPI {
    func signin(_ username: String, password: String) -> Observable<Bool>
    func repositories(_ keyword:String, page:Int) -> Observable<[Repository]>
    func users(_ keyword:String) -> Observable<[User]>
    func usersList(since:Int?) -> Observable<[User]>
    func repositories(_ username:String) -> Observable<[Repository]>
    func recentRepositories(_ language:String, page:Int) -> Observable<[Repository]>
    func profile() -> Observable<User>
}

public protocol GitHubValidationService {
    func validateUserid(_ userid: String) -> Observable<ValidationResult>
    func validatePassword(_ password: String) -> ValidationResult
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}
