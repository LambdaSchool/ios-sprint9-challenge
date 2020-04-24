//
//  FirebaseClient.swift
//  Albums
//
//  Created by Shawn Gee on 4/6/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

private let baseURL = URL(string: "https://calorietracker-shawngee.firebaseio.com/")!

class FirebaseClient {

    func fetchCalorieEntries(completion: @escaping (Result<[String: CalorieEntryRepresentation], NetworkError>) -> Void) {
        let request = URLRequest(url: baseURL.appendingPathExtension("json"))
        
        URLSession.shared.dataTask(with: request) { result in
            completion(CalorieEntryResultDecoder().decode(result))
        }.resume()
    }
    
//    func putAlbum(_ album: Album, completion: @escaping (NetworkError?) -> Void) {
//        var request = URLRequest(url: baseURL.appendingPathComponent(album.id).appendingPathExtension("json"))
//        request.httpMethod = HTTPMethod.put
//
//        do {
//            request.httpBody = try JSONEncoder().encode(album)
//        } catch {
//            completion(.encodingError(error))
//            return
//        }
//
//        URLSession.shared.dataTask(with: request, errorHandler: completion).resume()
//    }
//
//    func deleteAlbum (_ album: Album, completion: @escaping (NetworkError?) -> Void) {
//        var request = URLRequest(url: baseURL.appendingPathComponent(album.id).appendingPathExtension("json"))
//        request.httpMethod = HTTPMethod.delete
//
//        do {
//            request.httpBody = try JSONEncoder().encode(album)
//        } catch {
//            completion(.encodingError(error))
//            return
//        }
//
//        URLSession.shared.dataTask(with: request, errorHandler: completion).resume()
//    }
//
//    func getImage(with url: URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
//        URLSession.shared.dataTask(with: URLRequest(url: url)) { result in
//            completion(ImageResultDecoder().decode(result))
//        }.resume()
//    }
    
    
//    private let albumsDecoder = ResultDecoder<[Album]> { data in
//        try Array(JSONDecoder().decode([String: Album].self, from: data).values)
//    }
//    
//    private let imageDecoder = ResultDecoder<UIImage> { data in
//        guard let image = UIImage(data: data) else {
//            throw NSError(domain: "Bad image data", code: 0)
//        }
//        return image
//    }
}





