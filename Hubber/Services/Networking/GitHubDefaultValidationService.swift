//
//  GitHubDefaultValidationService.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/18/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import RxSwift

public class GitHubDefaultValidationService: GitHubValidationService {
    
    static let sharedValidationService = GitHubDefaultValidationService()
    
    public func validateUserid(_ userid: String) -> Observable<ValidationResult> {
        if userid.count < 6 {
            return .just(.empty)
        } else {
            return .just(.ok(message: "Username available"))
        }
    }
    
    public func validatePassword(_ password: String) -> ValidationResult {
        if password.isEmpty {
            return .empty
        } else {
            return .ok(message: "Password acceptable")
        }
    }
    
}
