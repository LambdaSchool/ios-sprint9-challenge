//
//  ResultDecoder.swift
//  Albums
//
//  Created by Shawn Gee on 4/13/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

protocol ResultDecoder {
    
    associatedtype T
    
    var transform: (Data) throws -> T { get }
    
    func decode(_ result: DataResult) -> Result<T, NetworkError>
}

extension ResultDecoder {
    func decode(_ result: DataResult) -> Result<T, NetworkError> {
        result.flatMap { (data) -> Result<T, NetworkError> in
            Result { try transform(data) }
                .mapError { NetworkError.decodingError($0) }
        }
    }
}

struct CalorieEntryResultDecoder: ResultDecoder {
    typealias T = [String: CalorieEntryRepresentation]
    
    var transform = { data in
        try JSONDecoder().decode([String: CalorieEntryRepresentation].self, from: data)
    }
}

