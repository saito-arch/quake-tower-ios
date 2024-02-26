//
//  TestingError.swift
//  QuakeTowerTests
//
//  Created by Saito on 2024/02/26.
//

import Foundation

enum TestingError: Error {
    case preparedApiStubDoesNotAlignWithCalledApi(message: String)
}
