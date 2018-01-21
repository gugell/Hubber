//
//  SearchUsersViewModel.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/20/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import Foundation
import Foundation
import RxCocoa
import RxSwift


public protocol SearchUsersViewModelInputs {
    var searchKeyword:PublishSubject<String?> { get }
    var loadNextPageTrigger:PublishSubject<Void> { get }
    func tapped(user: User)
    
}

public protocol SearchUsersViewModelOutputs {
    var isLoading: Driver<Bool> { get }
    var elements:Variable<[User]> { get }
    var selectedViewModel: Driver<ProfileViewModel> { get }
}

public protocol SearchUsersViewModelType {
    var inputs: SearchUsersViewModelInputs { get  }
    var outputs: SearchUsersViewModelOutputs { get }
}

public class SearchUsersViewModel: SearchUsersViewModelType, SearchUsersViewModelInputs, SearchUsersViewModelOutputs {
    
    private let disposeBag = DisposeBag()
    private let error = PublishSubject<Swift.Error>()
    private var lastUserId:Int? = nil
    
    private var query:String = ""
    init() {
        self.selectedViewModel = Driver.empty()
        self.searchKeyword = PublishSubject<String?>()
        self.loadNextPageTrigger = PublishSubject<Void>()
        self.elements = Variable<[User]>([])
        let isLoading = ActivityIndicator()
        self.isLoading = isLoading.asDriver()
        
        
        let keyRequest = self.searchKeyword.asDriver(onErrorJustReturn: "")
            .throttle(0.3)
            .distinctUntilChanged()
            .flatMap { query -> Driver<[User]> in
                self.lastUserId = nil;
                self.elements.value = []
                self.query = query!
                return GitHubAPIManager.sharedAPI.users(query!)
                    .trackActivity(isLoading)
                    .asDriver(onErrorJustReturn: [])
        }
        
        let nextPageRequest = isLoading
            .asObservable()
            .sample(self.loadNextPageTrigger)
            .flatMap { _isLoading -> Driver<[User]> in
                guard let last = self.elements.value.last , !self.query.isEmpty  else {  return Driver.empty() }
                self.lastUserId = last.id
            return GitHubAPIManager.sharedAPI.users(self.query)
                        .trackActivity(isLoading)
                        .asDriver(onErrorJustReturn: [])
                
              
        }
        
        
        let request = Observable.of(keyRequest.asObservable(),nextPageRequest)
            .merge()
            .shareReplay(1)
        
        
        let response = request.flatMap { users -> Observable<[User]> in
            request
                .do(onError: { _error in
                    self.error.onNext(_error)
                }).catchError({ error -> Observable<[User]> in
                    Observable.empty()
                })
            }.shareReplay(1)
        
        Observable
            .combineLatest(request, response, elements.asObservable()) { request, response, elements in
                return self.lastUserId == nil ? response : elements + response
            }
            .sample(response)
            .bind(to:elements)
            .addDisposableTo(disposeBag)
        
        self.selectedViewModel = self.user.asDriver().filterNil().flatMapLatest{ repo -> Driver<ProfileViewModel> in
            return Driver.just(ProfileViewModel(model: repo))
        }
        }
    
    
    let user = Variable<User?>(nil)
        
    public func tapped(user: User) {
        self.user.value = user
    }
    
    public var selectedViewModel: Driver<ProfileViewModel>
    public var elements:Variable<[User]>
    public var isLoading: Driver<Bool>
    public var searchKeyword:PublishSubject<String?>
    public var loadNextPageTrigger:PublishSubject<Void>
    public var inputs: SearchUsersViewModelInputs { return self}
    public var outputs: SearchUsersViewModelOutputs { return self}
    
}
