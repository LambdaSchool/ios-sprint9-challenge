//
//  NetworkDataLoader.swift
//  WaterMyPlants
//
//  Created by patelpra on 6/22/20.
//  Copyright © 2020 Crus Technologies. All rights reserved.
//

import Foundation

protocol NetworkDataLoader {
    func loadData(using request: URLRequest, completion: @escaping (Data?, URLResponse?,
        Error?) -> Void)
}
