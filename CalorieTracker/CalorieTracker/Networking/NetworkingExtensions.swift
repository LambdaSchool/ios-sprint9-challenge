//
//  NetworkingExtensions.swift
//  Random Users
//
//  Created by Shawn Gee on 4/11/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

typealias DataResult = Result<Data, NetworkError>

extension NetworkError {
    
    init?(data: Data? = Data(), response: URLResponse?, error: Error?) {
        if let error = error {
            self = .transportError(error)
            return
        }

        if let response = response as? HTTPURLResponse,
            !(200...299).contains(response.statusCode) {
            self = .serverError(statusCode: response.statusCode)
            return
        }
        
        if data == nil {
            self = .noData
        }
        
        return nil
    }
}

extension URLSession {
    
    func dataTask(with request: URLRequest, errorHandler: @escaping (NetworkError?) -> Void) -> URLSessionDataTask {
        
        return self.dataTask(with: request) { (data, response, error) in
            errorHandler(NetworkError(response: response, error: error))
        }
    }
    
    func dataTask(with request: URLRequest, resultHandler: @escaping (DataResult) -> Void) -> URLSessionDataTask {
        
        return self.dataTask(with: request) { data, response, error in
            
                if let networkError = NetworkError(data: data, response: response, error: error) {
                    resultHandler(.failure(networkError))
                    return
                }
                
                resultHandler(.success(data!))
        }
    }
}
