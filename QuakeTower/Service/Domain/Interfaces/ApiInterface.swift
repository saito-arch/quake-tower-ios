//
//  ApiInterface.swift
//  QuakeTower
//
//  Created by Saito on 2024/02/24.
//

import Foundation
import RxSwift

enum ApiContext<T, Alternatives> {
    case success(entity: T)
    case failure(by: Alternatives)
}

enum Alternatives {

    enum None {}

    case none(_ error: None)
}

protocol ApiInterface {
}
