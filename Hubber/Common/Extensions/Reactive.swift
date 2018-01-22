//
//  Reactive.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/18/18.
//  Copyright © 2018 Stamax. All rights reserved.
//
import RxSwift
import RxCocoa
import SVProgressHUD

func isLoading(for view: UIView) -> AnyObserver<Bool> {
    return UIBindingObserver(UIElement: view, binding: { (_, isLoading) in
        switch isLoading {
        case true:
            SVProgressHUD.show()
        case false:
            SVProgressHUD.dismiss()
            break
        }
    }).asObserver()
}

extension Reactive where Base: UIScrollView {
    public var reachedBottom: Observable<Void> {
        let scrollView = self.base as UIScrollView
        return self.contentOffset.flatMap { [weak scrollView] (contentOffset) -> Observable<Void> in
            guard let scrollView = scrollView else { return Observable.empty() }
            let visibleHeight = scrollView.frame.height - self.base.contentInset.top - scrollView.contentInset.bottom
            let y = contentOffset.y + scrollView.contentInset.top
            let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
            return (y > threshold - (threshold / 4)) ? Observable.just(()) : Observable.empty()
        }
    }
}
