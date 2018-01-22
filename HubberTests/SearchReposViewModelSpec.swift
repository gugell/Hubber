//
//  SearchReposViewModelSpec.swift
//  HubberTests
//
//  Created by Ilia Gutu on 1/22/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import Quick
import Nimble
import RxBlocking
import RxTest
import RxSwift
import RxCocoa
import Moya
@testable import Hubber

class SearchReposViewModelSpec: QuickSpec {
    
    override func spec() {
        
        var viewModel: SearchReposViewModel!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        
        beforeEach {
            
            let bundle = Bundle(for: type(of: self))
            guard let path = bundle.path(forResource: "SearchResponse", ofType: "json") else {
                fatalError("Invalid path for json file")
            }
            stubJsonPath = path
            
            scheduler = TestScheduler(initialClock: 0)
            driveOnScheduler(scheduler) {
                viewModel = SearchReposViewModel()
            }
            
            disposeBag = DisposeBag()
        }
        
        afterEach {
            scheduler = nil
            viewModel = nil
            disposeBag = nil
        }
        
        it("returns one repo when queried") {
            let observer = scheduler.createObserver([Repository].self)
            
            scheduler.scheduleAt(100) {
                viewModel.outputs.elements.asObservable()
                    .subscribe(observer)
                    .addDisposableTo(disposeBag)
            }
            
            
            scheduler.scheduleAt(200) {
                viewModel.inputs.searchKeyword.onNext("swift")
                
            }
            
            scheduler.start()
            
            let results = observer.events.first
                .map { event in
                    event.value.element!.count
            }
            
            expect(results) == 1
            
        }
        
    }
}
