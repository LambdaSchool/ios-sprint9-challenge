//
//  ResultsDecoder.swift
//  Calorie Counter
//
//  Created by Sal B Amer on 5/4/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import UIKit

protocol ResultDecoder {
    
    associatedtype ResultType
    
    var transform: (Data) throws -> ResultType { get }
    
    func decode(_ result: DataResult) -> Result<ResultType, NetworkError>
}

extension ResultDecoder {
    func decode(_ result: DataResult) -> Result<ResultType, NetworkError> {
        result.flatMap { data -> Result<ResultType, NetworkError> in
            Result { try transform(data) }
                .mapError { NetworkError.decodingError($0) }
        }
    }
}

struct CalorieEntryResultDecoder: ResultDecoder {
    typealias ResultType = [String: CalorieRepresentation]
    
    var transform = { data in
        try JSONDecoder().decode([String: CalorieRepresentation].self, from: data)
    }
}

