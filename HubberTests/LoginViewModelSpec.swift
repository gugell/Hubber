//
//  LoginViewModelSpec.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/22/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import Quick
import Nimble
import RxBlocking
import RxSwift
import RxCocoa
import RxTest
import Moya

@testable import Hubber

class LoginViewModelSpec: QuickSpec {
    
    override func spec() {
        var sut: LoginViewModel!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        
        beforeEach {
            scheduler = TestScheduler(initialClock: 0)
            driveOnScheduler(scheduler) {
                sut = LoginViewModel()
            }
            disposeBag = DisposeBag()
        }
        
        afterEach {
            scheduler = nil
            sut = nil
            disposeBag = nil
        }
        
        it("should enable UI elements when valid login credentials are entered") {
            let observer = scheduler.createObserver(Bool.self)
            
            scheduler.scheduleAt(100) {
                sut.outputs.enableLogin.asObservable().subscribe(observer).addDisposableTo(disposeBag)
            }
            
            scheduler.scheduleAt(200) {
                sut.inputs.email.onNext("username")
                sut.inputs.password.onNext("password")
            }
            
            scheduler.start()
            
            let results = observer.events
                .map { event in
                    event.value.element!
            }
            
            expect(results) == [true]
        }
        
        it("should not enable UI elements when invalid credentials are entered") {
            
            let observer = scheduler.createObserver(Bool.self)
            
            scheduler.scheduleAt(100) {
                sut.outputs.enableLogin.asObservable().subscribe(observer).addDisposableTo(disposeBag)
            }
            
            scheduler.scheduleAt(200) {
                sut.inputs.email.onNext("aaa")
                sut.inputs.password.onNext("bbb")
            }
            
            scheduler.start()
            
            let results = observer.events
                .map { event in
                    event.value.element!
            }
            
            expect(results) == [false]
        }
        
    }
    
}

