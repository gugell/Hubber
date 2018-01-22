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
    var selectedRepoViewModel: Driver<RepoViewModel>? { get }
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
        var models: [ProfileSectionModel] = []
          var username = ""
           self.profileObservable =  GitHubAPIManager.sharedAPI.profile()
            .trackActivity(Loading)
            .flatMap { user -> Observable<[Repository]> in
                username = user.login ?? ""
                let profileSectionModel = ProfileSectionModel(model: "", items:
                    [Profile.avatar(title: "avatarUrl", avatarUrl: user.avatarUrl!), Profile.detail(title: "id", detail: username), Profile.detail(title: "createdAt", detail: user.createdAt!), Profile.detail(title: "publicRepos", detail: "\(user.publicRepos ?? 0) repositories")]
                )
                models.append(profileSectionModel)
                return GitHubAPIManager.sharedAPI.repositories(username)
        }.asDriver(onErrorJustReturn: [])
         .trackActivity(Loading)
         .map { repos -> [ProfileSectionModel] in
            self.elements.value = repos

            let list = repos.map { (repo: Repository) -> Profile in
                return  Profile.listItem(title: repo.name ?? "", description: "by " + username, language:repo.language, stars:"\(repo.stargazersCount) stars")
            }
            models.append(ProfileSectionModel(model: "Repositories", items:list))
            return models
        }.debug()
         .trackActivity(Loading)
         .asDriver(onErrorJustReturn: [])

        self.selectedRepoViewModel = self.repository.asDriver().filterNil().flatMapLatest { repo -> Driver<RepoViewModel> in
            return Driver.just(RepoViewModel(repo: repo))
        }

    }

    init(model: User) {

        let Loading = ActivityIndicator()
        self.isLoading = Loading.asDriver()

        self.profileObservable = Driver.empty()

        guard let username = model.login else { return }

        let profileInfoObservable = GitHubAPIManager.sharedAPI.profile(by:username)
            .trackActivity(Loading)
            .asDriver(onErrorJustReturn: model)
            .map { user -> ProfileSectionModel in

                let profileSectionModel = ProfileSectionModel(model: "General", items:
                    [Profile.avatar(title: "avatarUrl", avatarUrl: user.avatarUrl!), Profile.detail(title: "id", detail: user.login!), Profile.detail(title: "createdAt", detail: user.createdAt!), Profile.detail(title: "publicRepos", detail: "\(user.publicRepos ?? 0)")]
                )
                return profileSectionModel
        }

        let reposObservable = GitHubAPIManager.sharedAPI.repositories(username)
            .trackActivity(Loading)
            .asDriver(onErrorJustReturn: [])
            .map { (repos: [Repository]) -> ProfileSectionModel in
                self.elements.value = repos

                let list = repos.map { (repo: Repository) -> Profile in
                    return  Profile.listItem(title: repo.name ?? "", description: "by " + username, language:repo.language, stars:"\(repo.stargazersCount) stars")
                }

                let profileSectionModel = ProfileSectionModel(model: "Repositories", items:
                    list
                )

                return profileSectionModel
        }

        self.profileObservable = Driver.zip([profileInfoObservable, reposObservable])
            .debug()
            .trackActivity(Loading)
            .asDriver(onErrorJustReturn: [])

        self.selectedRepoViewModel = self.repository.asDriver().filterNil().flatMapLatest { repo -> Driver<RepoViewModel> in
            return Driver.just(RepoViewModel(repo: repo))
        }
    }

    let repository = Variable<Repository?>(nil)
    public func tapped(indexRow: Int) {
        let repository = self.elements.value[indexRow]
        self.repository.value = repository
    }

    public var isLoading: Driver<Bool>
    public var profileObservable: Driver<[ProfileSectionModel]>
    public var inputs: ProfileViewModelInputs { return self}
    public var outputs: ProfileViewModelOutputs { return self}
    public var selectedRepoViewModel: Driver<RepoViewModel>?
    public var elements = Variable<[Repository]>([])

}
