//
//  URLSession+NetworkDataLoader.swift
//  WaterMyPlants
//
//  Created by patelpra on 6/22/20.
//  Copyright © 2020 Crus Technologies. All rights reserved.
//

import Foundation

extension URLSession: NetworkDataLoader {
    func loadData(using request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataTask(with: request) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
}
