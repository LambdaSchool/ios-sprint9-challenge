//
//  NetworkingErrorsMethods.swift
//  Calorie Counter
//
//  Created by Sal B Amer on 5/4/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case transportError(Error)
    case serverError(statusCode: Int)
    case noData
    case decodingError(Error)
    case encodingError(Error)
}

enum HTTPMethod {
    static let get = "GET"
    static let put = "PUT"
    static let post = "POST"
    static let patch = "PATCH"
    static let delete = "DELETE"
}
