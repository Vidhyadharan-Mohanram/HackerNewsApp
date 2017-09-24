//
//  HKNError.swift
//  HackerNewsApp
//
//  Created by Vidhyadharan Mohanram on 22/09/17.
//  Copyright © 2017 Vidhyadharan. All rights reserved.
//

import UIKit

class HKNError: Error {

    public enum ErrorType {
        case apiError
        case noInternetError
    }

    public let errorType: ErrorType
    public var apiCallDictionary: [String: Any]?
    public var apiCallError: Error?

    public init(_ type: ErrorType) {
        errorType = type
    }

    convenience init(dictionary: [String: Any]?, error: Error?) {
        self.init(.apiError)
        apiCallDictionary = dictionary
        apiCallError = error
    }

}
