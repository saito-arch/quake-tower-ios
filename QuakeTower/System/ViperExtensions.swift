//
//  ViperExtensions.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import UIKit
import RxSwift

protocol Scenario {
    func next() -> Single<Self>?
}

extension Usecase {

    func interact<T>(contexts: [T]) -> Single<[T]> where T: Scenario {
        guard let context = contexts.last else { fatalError("context doesn't exist") }

        guard let single = context.next() else {
            return Single<[T]>.just(contexts)
        }

        return single
            .flatMap { nextContext -> Single<[T]> in
                var varContexts = contexts
                varContexts.append(nextContext)

                return self.interact(contexts: varContexts)
            }
    }
}

