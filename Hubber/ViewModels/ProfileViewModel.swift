//
//  ProfileViewModel.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/18/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

public protocol ProfileViewModelInputs {
    var isLoading: Driver<Bool> { get }

}

public protocol ProfileViewModelOutputs {
    var profileObservable: Driver<[ProfileSectionModel]> { get }
}

public protocol ProfileViewModelType {
    var inputs: ProfileViewModelInputs { get  }
    var outputs: ProfileViewModelOutputs { get }
}

public class ProfileViewModel: ProfileViewModelType, ProfileViewModelInputs, ProfileViewModelOutputs {
    
       private let disposeBag = DisposeBag()
    
    init() {
        
        let Loading = ActivityIndicator()
        self.isLoading = Loading.asDriver()

        self.profileObservable = Driver.empty()
        
        self.profileObservable = GitHubAPIManager.sharedAPI.profile()
            .trackActivity(Loading)
            .asDriver(onErrorJustReturn: User())
            .flatMap{ user -> Driver<[ProfileSectionModel]> in
                
                guard let _ = user.login else {
                    return Driver.just([])
                }
                
                let profileSectionModel = ProfileSectionModel(model: "", items:
                    [Profile.avatar(title: "avatarUrl", avatarUrl: user.avatarUrl!)
                    ,Profile.detail(title: "id", detail: user.login!)
                    ,Profile.detail(title: "createdAt", detail: user.createdAt!)
                    ,Profile.detail(title: "publicRepos", detail: "\(user.publicRepos ?? 0)")]
                )
                
                return Driver.just([profileSectionModel])
            }
        
        
    }
    
    public var isLoading: Driver<Bool>
    public var profileObservable: Driver<[ProfileSectionModel]>
    public var inputs: ProfileViewModelInputs { return self}
    public var outputs: ProfileViewModelOutputs { return self}
}


